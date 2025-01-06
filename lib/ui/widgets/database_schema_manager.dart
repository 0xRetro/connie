import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../layout/spacing_constants.dart';
import '../layout/typography_styles.dart';
import '../layout/color_palette.dart';
import '../../database/database.dart';

/// A widget that displays and manages the database schema
/// Allows viewing table structures and modifying the schema
class DatabaseSchemaManager extends ConsumerStatefulWidget {
  const DatabaseSchemaManager({super.key});

  @override
  ConsumerState<DatabaseSchemaManager> createState() => _DatabaseSchemaManagerState();
}

class _DatabaseSchemaManagerState extends ConsumerState<DatabaseSchemaManager> {
  String? _selectedTable;
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(kSpacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Database Schema', style: kHeadline3),
                ElevatedButton.icon(
                  onPressed: () => _showCreateTableDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Create Table'),
                ),
              ],
            ),
            const SizedBox(height: kSpacingMedium),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Table List Panel
                  SizedBox(
                    width: 200,
                    child: _buildTableList(),
                  ),
                  const VerticalDivider(),
                  // Table Details Panel
                  Expanded(
                    child: _selectedTable != null
                        ? _buildTableDetails(_selectedTable!)
                        : const Center(
                            child: Text('Select a table to view its schema'),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableList() {
    final db = ref.watch(databaseProvider);
    final tables = db.allTables.toList();

    return ListView.builder(
      itemCount: tables.length,
      itemBuilder: (context, index) {
        final table = tables[index];
        final isSelected = table.actualTableName == _selectedTable;

        return ListTile(
          title: Text(table.actualTableName),
          selected: isSelected,
          onTap: () => setState(() => _selectedTable = table.actualTableName),
          leading: const Icon(Icons.table_chart),
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditTableDialog(context, table),
          ),
        );
      },
    );
  }

  Widget _buildTableDetails(String tableName) {
    final db = ref.watch(databaseProvider);
    final table = db.allTables.firstWhere(
      (t) => t.actualTableName == tableName,
    );

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Table Header with Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(tableName, style: kHeadline3),
              ElevatedButton.icon(
                onPressed: () => _showCreateFieldDialog(context, table),
                icon: const Icon(Icons.add),
                label: const Text('Create Field'),
              ),
            ],
          ),
          const SizedBox(height: kSpacingMedium),
          // Column Headers
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kSpacingSmall),
            child: Row(
              children: [
                Expanded(child: Text('Column', style: kBodyText)),
                Expanded(child: Text('Type', style: kBodyText)),
                Expanded(child: Text('Constraints', style: kBodyText)),
                const SizedBox(width: 48), // Space for actions
              ],
            ),
          ),
          const Divider(),
          // Column List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: table.$columns.length,
            itemBuilder: (context, index) {
              final column = table.$columns[index];
              return _buildColumnRow(column);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildColumnRow(drift.GeneratedColumn column) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: kSpacingSmall,
        vertical: kSpacingSmall,
      ),
      child: Row(
        children: [
          Expanded(child: Text(column.name)),
          Expanded(child: Text(_getColumnType(column))),
          Expanded(
            child: Wrap(
              spacing: 4,
              children: _getColumnConstraints(column),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditColumnDialog(context, column),
          ),
        ],
      ),
    );
  }

  String _getColumnType(drift.GeneratedColumn column) {
    if (column is drift.IntColumn) return 'INTEGER';
    if (column is drift.TextColumn) return 'TEXT';
    if (column is drift.BoolColumn) return 'BOOLEAN';
    if (column is drift.DateTimeColumn) return 'DATETIME';
    if (column is drift.RealColumn) return 'REAL';
    if (column is drift.BlobColumn) return 'BLOB';
    return 'UNKNOWN';
  }

  List<Widget> _getColumnConstraints(drift.GeneratedColumn column) {
    final constraints = <Widget>[];
    
    // Common constraints
    if (column.$nullable) {
      constraints.add(_buildConstraintChip('Nullable'));
    } else {
      constraints.add(_buildConstraintChip('Not Null'));
    }

    // Type-specific constraints
    if (column is drift.IntColumn && column.hasAutoIncrement) {
      constraints.add(_buildConstraintChip('Auto Increment'));
    }

    return constraints;
  }

  Widget _buildConstraintChip(String label) {
    return Chip(
      label: Text(
        label,
        style: const TextStyle(fontSize: 12),
      ),
      backgroundColor: kPrimaryColor.withOpacity(0.1),
      visualDensity: VisualDensity.compact,
    );
  }

  void _showCreateTableDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final tableNameController = TextEditingController();
    final List<Map<String, dynamic>> columns = [
      {
        'name': TextEditingController(),
        'type': 'TEXT',
        'nullable': false,
        'autoIncrement': false,
        'primaryKey': false,
      }
    ];

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 600,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Padding(
            padding: const EdgeInsets.all(kSpacingMedium),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Create New Table', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(),
                  // Content
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Table Name
                          TextFormField(
                            controller: tableNameController,
                            decoration: const InputDecoration(
                              labelText: 'Table Name',
                              hintText: 'Enter table name',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a table name';
                              }
                              if (!RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*$').hasMatch(value)) {
                                return 'Table name must start with a letter and contain only letters, numbers, and underscores';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: kSpacingMedium),
                          
                          // Columns Section
                          const Text('Columns', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: kSpacingSmall),
                          
                          // Column List
                          StatefulBuilder(
                            builder: (context, setState) => Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ...columns.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final column = entry.value;
                                  return Card(
                                    margin: const EdgeInsets.only(bottom: kSpacingSmall),
                                    child: Padding(
                                      padding: const EdgeInsets.all(kSpacingSmall),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text('Column ${index + 1}', 
                                                  style: const TextStyle(fontWeight: FontWeight.bold)
                                                ),
                                              ),
                                              if (columns.length > 1)
                                                IconButton(
                                                  icon: const Icon(Icons.delete_outline, size: 20),
                                                  onPressed: () {
                                                    setState(() {
                                                      columns.removeAt(index);
                                                    });
                                                  },
                                                ),
                                            ],
                                          ),
                                          const SizedBox(height: kSpacingSmall),
                                          // Column Name
                                          TextFormField(
                                            controller: column['name'] as TextEditingController,
                                            decoration: const InputDecoration(
                                              labelText: 'Column Name',
                                              hintText: 'Enter column name',
                                            ),
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Required';
                                              }
                                              if (!RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*$').hasMatch(value)) {
                                                return 'Invalid format';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: kSpacingSmall),
                                          // Column Type
                                          DropdownButtonFormField<String>(
                                            value: column['type'] as String,
                                            items: [
                                              'INTEGER',
                                              'TEXT',
                                              'BOOLEAN',
                                              'DATETIME',
                                              'REAL',
                                              'BLOB',
                                            ].map((type) => DropdownMenuItem(
                                              value: type,
                                              child: Text(type),
                                            )).toList(),
                                            onChanged: (value) {
                                              if (value != null) {
                                                setState(() {
                                                  columns[index]['type'] = value;
                                                  // Reset auto-increment if not INTEGER
                                                  if (value != 'INTEGER') {
                                                    columns[index]['autoIncrement'] = false;
                                                  }
                                                });
                                              }
                                            },
                                            decoration: const InputDecoration(
                                              labelText: 'Column Type',
                                            ),
                                          ),
                                          const SizedBox(height: kSpacingSmall),
                                          // Constraints
                                          const Text('Constraints:', 
                                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)
                                          ),
                                          const SizedBox(height: kSpacingSmall),
                                          
                                          // Basic Constraints
                                          Wrap(
                                            spacing: 8,
                                            runSpacing: 8,
                                            children: [
                                              FilterChip(
                                                label: const Text('Nullable'),
                                                selected: column['nullable'] as bool,
                                                onSelected: (value) {
                                                  setState(() {
                                                    columns[index]['nullable'] = value;
                                                    if (value) {
                                                      columns[index]['primaryKey'] = false;
                                                    }
                                                  });
                                                },
                                              ),
                                              FilterChip(
                                                label: const Text('Primary Key'),
                                                selected: column['primaryKey'] as bool,
                                                onSelected: (value) {
                                                  setState(() {
                                                    columns[index]['primaryKey'] = value;
                                                    if (value) {
                                                      columns[index]['nullable'] = false;
                                                    }
                                                  });
                                                },
                                              ),
                                              FilterChip(
                                                label: const Text('Unique'),
                                                selected: column['unique'] ?? false,
                                                onSelected: (value) {
                                                  setState(() {
                                                    columns[index]['unique'] = value;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: kSpacingSmall),

                                          // Type-specific constraints
                                          if (column['type'] == 'INTEGER') ...[
                                            const Text('Integer Constraints:', 
                                              style: TextStyle(fontSize: 12, color: Colors.grey)
                                            ),
                                            Wrap(
                                              spacing: 8,
                                              runSpacing: 8,
                                              children: [
                                                FilterChip(
                                                  label: const Text('Auto Increment'),
                                                  selected: column['autoIncrement'] ?? false,
                                                  onSelected: (value) {
                                                    setState(() {
                                                      columns[index]['autoIncrement'] = value;
                                                      if (value) {
                                                        columns[index]['primaryKey'] = true;
                                                        columns[index]['nullable'] = false;
                                                      }
                                                    });
                                                  },
                                                ),
                                                FilterChip(
                                                  label: const Text('Foreign Key'),
                                                  selected: column['foreignKey'] ?? false,
                                                  onSelected: (value) {
                                                    setState(() {
                                                      columns[index]['foreignKey'] = value;
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                            if (column['foreignKey'] == true)
                                              DropdownButtonFormField<String>(
                                                value: column['referencedTable'] as String?,
                                                decoration: const InputDecoration(
                                                  labelText: 'Referenced Table',
                                                  helperText: 'Select the table this foreign key references',
                                                ),
                                                items: ['people', 'other_tables'].map((table) => // TODO: Get actual tables
                                                  DropdownMenuItem(
                                                    value: table,
                                                    child: Text(table),
                                                  ),
                                                ).toList(),
                                                onChanged: (value) {
                                                  setState(() {
                                                    columns[index]['referencedTable'] = value;
                                                  });
                                                },
                                              ),
                                          ] else if (column['type'] == 'TEXT') ...[
                                            const Text('Text Constraints:', 
                                              style: TextStyle(fontSize: 12, color: Colors.grey)
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: TextFormField(
                                                    decoration: const InputDecoration(
                                                      labelText: 'Max Length',
                                                      helperText: 'Leave empty for unlimited',
                                                    ),
                                                    keyboardType: TextInputType.number,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        columns[index]['maxLength'] = int.tryParse(value);
                                                      });
                                                    },
                                                  ),
                                                ),
                                                const SizedBox(width: kSpacingSmall),
                                                Expanded(
                                                  child: TextFormField(
                                                    decoration: const InputDecoration(
                                                      labelText: 'Pattern (Regex)',
                                                      helperText: 'Validation pattern',
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        columns[index]['pattern'] = value;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ] else if (column['type'] == 'DATETIME') ...[
                                            const Text('DateTime Constraints:', 
                                              style: TextStyle(fontSize: 12, color: Colors.grey)
                                            ),
                                            Wrap(
                                              spacing: 8,
                                              runSpacing: 8,
                                              children: [
                                                FilterChip(
                                                  label: const Text('Default to Current Time'),
                                                  selected: column['defaultToCurrentTime'] ?? false,
                                                  onSelected: (value) {
                                                    setState(() {
                                                      columns[index]['defaultToCurrentTime'] = value;
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ] else if (column['type'] == 'REAL') ...[
                                            const Text('Numeric Constraints:', 
                                              style: TextStyle(fontSize: 12, color: Colors.grey)
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: TextFormField(
                                                    decoration: const InputDecoration(
                                                      labelText: 'Precision',
                                                      helperText: 'Total digits',
                                                    ),
                                                    keyboardType: TextInputType.number,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        columns[index]['precision'] = int.tryParse(value);
                                                      });
                                                    },
                                                  ),
                                                ),
                                                const SizedBox(width: kSpacingSmall),
                                                Expanded(
                                                  child: TextFormField(
                                                    decoration: const InputDecoration(
                                                      labelText: 'Scale',
                                                      helperText: 'Decimal places',
                                                    ),
                                                    keyboardType: TextInputType.number,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        columns[index]['scale'] = int.tryParse(value);
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],

                                          // Default Value Section
                                          const SizedBox(height: kSpacingMedium),
                                          TextFormField(
                                            decoration: const InputDecoration(
                                              labelText: 'Default Value',
                                              helperText: 'Leave empty for no default',
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                columns[index]['defaultValue'] = value.isEmpty ? null : value;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                                
                                // Add Column Button
                                OutlinedButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      columns.add({
                                        'name': TextEditingController(),
                                        'type': 'TEXT',
                                        'nullable': false,
                                        'autoIncrement': false,
                                        'primaryKey': false,
                                      });
                                    });
                                  },
                                  icon: const Icon(Icons.add),
                                  label: const Text('Add Column'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                  // Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: kSpacingSmall),
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState?.validate() ?? false) {
                            // TODO: Implement table creation
                            // 1. Create a new Drift table class
                            // 2. Add it to the database
                            // 3. Generate migration
                            // 4. Update schema
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Table creation not implemented yet'),
                              ),
                            );
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Create Table'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showEditTableDialog(BuildContext context, drift.TableInfo table) {
    // TODO: Implement edit table dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Table: ${table.actualTableName}'),
        content: const Text('Table editing dialog coming soon...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showEditColumnDialog(BuildContext context, drift.GeneratedColumn column) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: column.name);
    final Map<String, dynamic> field = {
      'type': _getColumnType(column),
      'nullable': column.$nullable,
      'autoIncrement': column is drift.IntColumn ? column.hasAutoIncrement : false,
      'primaryKey': false, // TODO: Get actual primary key status
    };

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 400,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Padding(
            padding: const EdgeInsets.all(kSpacingMedium),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Edit Field', 
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(),
                  // Content
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Field Name
                          TextFormField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              labelText: 'Field Name',
                              hintText: 'Enter field name',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a field name';
                              }
                              if (!RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*$').hasMatch(value)) {
                                return 'Field name must start with a letter and contain only letters, numbers, and underscores';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: kSpacingMedium),
                          
                          // Field Type
                          StatefulBuilder(
                            builder: (context, setState) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DropdownButtonFormField<String>(
                                  value: field['type'] as String,
                                  decoration: const InputDecoration(
                                    labelText: 'Field Type',
                                  ),
                                  items: [
                                    'INTEGER',
                                    'TEXT',
                                    'BOOLEAN',
                                    'DATETIME',
                                    'REAL',
                                    'BLOB',
                                  ].map((type) => DropdownMenuItem(
                                    value: type,
                                    child: Text(type),
                                  )).toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() {
                                        field['type'] = value;
                                        if (value != 'INTEGER') {
                                          field['autoIncrement'] = false;
                                        }
                                      });
                                    }
                                  },
                                ),
                                const SizedBox(height: kSpacingMedium),
                                
                                // Constraints
                                const Text('Constraints:', 
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  )
                                ),
                                const SizedBox(height: kSpacingSmall),
                                
                                // Basic Constraints
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    FilterChip(
                                      label: const Text('Nullable'),
                                      selected: field['nullable'] as bool,
                                      onSelected: (value) {
                                        setState(() {
                                          field['nullable'] = value;
                                          if (value) {
                                            field['primaryKey'] = false;
                                          }
                                        });
                                      },
                                    ),
                                    FilterChip(
                                      label: const Text('Primary Key'),
                                      selected: field['primaryKey'] as bool,
                                      onSelected: (value) {
                                        setState(() {
                                          field['primaryKey'] = value;
                                          if (value) {
                                            field['nullable'] = false;
                                          }
                                        });
                                      },
                                    ),
                                    FilterChip(
                                      label: const Text('Unique'),
                                      selected: field['unique'] ?? false,
                                      onSelected: (value) {
                                        setState(() {
                                          field['unique'] = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: kSpacingSmall),
                                
                                // Type-specific constraints
                                if (field['type'] == 'INTEGER') ...[
                                  const Text('Integer Constraints:', 
                                    style: TextStyle(fontSize: 12, color: Colors.grey)
                                  ),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      FilterChip(
                                        label: const Text('Auto Increment'),
                                        selected: field['autoIncrement'] ?? false,
                                        onSelected: (value) {
                                          setState(() {
                                            field['autoIncrement'] = value;
                                            if (value) {
                                              field['primaryKey'] = true;
                                              field['nullable'] = false;
                                            }
                                          });
                                        },
                                      ),
                                      FilterChip(
                                        label: const Text('Foreign Key'),
                                        selected: field['foreignKey'] ?? false,
                                        onSelected: (value) {
                                          setState(() {
                                            field['foreignKey'] = value;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  if (field['foreignKey'] == true)
                                    DropdownButtonFormField<String>(
                                      value: field['referencedTable'] as String?,
                                      decoration: const InputDecoration(
                                        labelText: 'Referenced Table',
                                        helperText: 'Select the table this foreign key references',
                                      ),
                                      items: ['people', 'other_tables'].map((table) => // TODO: Get actual tables
                                        DropdownMenuItem(
                                          value: table,
                                          child: Text(table),
                                        ),
                                      ).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          field['referencedTable'] = value;
                                        });
                                      },
                                    ),
                                ] else if (field['type'] == 'TEXT') ...[
                                  const Text('Text Constraints:', 
                                    style: TextStyle(fontSize: 12, color: Colors.grey)
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                            labelText: 'Max Length',
                                            helperText: 'Leave empty for unlimited',
                                          ),
                                          keyboardType: TextInputType.number,
                                          onChanged: (value) {
                                            setState(() {
                                              field['maxLength'] = int.tryParse(value);
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: kSpacingSmall),
                                      Expanded(
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                            labelText: 'Pattern (Regex)',
                                            helperText: 'Validation pattern',
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              field['pattern'] = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ] else if (field['type'] == 'DATETIME') ...[
                                  const Text('DateTime Constraints:', 
                                    style: TextStyle(fontSize: 12, color: Colors.grey)
                                  ),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      FilterChip(
                                        label: const Text('Default to Current Time'),
                                        selected: field['defaultToCurrentTime'] ?? false,
                                        onSelected: (value) {
                                          setState(() {
                                            field['defaultToCurrentTime'] = value;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ] else if (field['type'] == 'REAL') ...[
                                  const Text('Numeric Constraints:', 
                                    style: TextStyle(fontSize: 12, color: Colors.grey)
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                            labelText: 'Precision',
                                            helperText: 'Total digits',
                                          ),
                                          keyboardType: TextInputType.number,
                                          onChanged: (value) {
                                            setState(() {
                                              field['precision'] = int.tryParse(value);
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: kSpacingSmall),
                                      Expanded(
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                            labelText: 'Scale',
                                            helperText: 'Decimal places',
                                          ),
                                          keyboardType: TextInputType.number,
                                          onChanged: (value) {
                                            setState(() {
                                              field['scale'] = int.tryParse(value);
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                
                                // Default Value Section
                                const SizedBox(height: kSpacingMedium),
                                TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Default Value',
                                    helperText: 'Leave empty for no default',
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      field['defaultValue'] = value.isEmpty ? null : value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                  // Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: kSpacingSmall),
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState?.validate() ?? false) {
                            // TODO: Implement field update
                            // 1. Modify column in table
                            // 2. Generate migration
                            // 3. Update schema
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Field update not implemented yet'),
                              ),
                            );
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Update Field'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showCreateFieldDialog(BuildContext context, drift.TableInfo table) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final Map<String, dynamic> field = {
      'type': 'TEXT',
      'nullable': false,
      'autoIncrement': false,
      'primaryKey': false,
    };

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 400,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Padding(
            padding: const EdgeInsets.all(kSpacingMedium),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Add Field to ${table.actualTableName}', 
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(),
                  // Content
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Field Name
                          TextFormField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              labelText: 'Field Name',
                              hintText: 'Enter field name',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a field name';
                              }
                              if (!RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*$').hasMatch(value)) {
                                return 'Field name must start with a letter and contain only letters, numbers, and underscores';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: kSpacingMedium),
                          
                          // Field Type
                          StatefulBuilder(
                            builder: (context, setState) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DropdownButtonFormField<String>(
                                  value: field['type'] as String,
                                  decoration: const InputDecoration(
                                    labelText: 'Field Type',
                                  ),
                                  items: [
                                    'INTEGER',
                                    'TEXT',
                                    'BOOLEAN',
                                    'DATETIME',
                                    'REAL',
                                    'BLOB',
                                  ].map((type) => DropdownMenuItem(
                                    value: type,
                                    child: Text(type),
                                  )).toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() {
                                        field['type'] = value;
                                        if (value != 'INTEGER') {
                                          field['autoIncrement'] = false;
                                        }
                                      });
                                    }
                                  },
                                ),
                                const SizedBox(height: kSpacingMedium),
                                
                                // Constraints
                                const Text('Constraints:', 
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  )
                                ),
                                const SizedBox(height: kSpacingSmall),
                                
                                // Basic Constraints
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    FilterChip(
                                      label: const Text('Nullable'),
                                      selected: field['nullable'] as bool,
                                      onSelected: (value) {
                                        setState(() {
                                          field['nullable'] = value;
                                          if (value) {
                                            field['primaryKey'] = false;
                                          }
                                        });
                                      },
                                    ),
                                      FilterChip(
                                      label: const Text('Primary Key'),
                                      selected: field['primaryKey'] as bool,
                                        onSelected: (value) {
                                          setState(() {
                                          field['primaryKey'] = value;
                                            if (value) {
                                              field['nullable'] = false;
                                            }
                                          });
                                        },
                                      ),
                                    FilterChip(
                                      label: const Text('Unique'),
                                      selected: field['unique'] ?? false,
                                      onSelected: (value) {
                                        setState(() {
                                          field['unique'] = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: kSpacingSmall),
                                
                                // Type-specific constraints
                                if (field['type'] == 'INTEGER') ...[
                                  const Text('Integer Constraints:', 
                                    style: TextStyle(fontSize: 12, color: Colors.grey)
                                  ),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      FilterChip(
                                        label: const Text('Auto Increment'),
                                        selected: field['autoIncrement'] ?? false,
                                        onSelected: (value) {
                                          setState(() {
                                            field['autoIncrement'] = value;
                                          if (value) {
                                              field['primaryKey'] = true;
                                            field['nullable'] = false;
                                          }
                                        });
                                      },
                                    ),
                                      FilterChip(
                                        label: const Text('Foreign Key'),
                                        selected: field['foreignKey'] ?? false,
                                        onSelected: (value) {
                                          setState(() {
                                            field['foreignKey'] = value;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  if (field['foreignKey'] == true)
                                    DropdownButtonFormField<String>(
                                      value: field['referencedTable'] as String?,
                                      decoration: const InputDecoration(
                                        labelText: 'Referenced Table',
                                        helperText: 'Select the table this foreign key references',
                                      ),
                                      items: ['people', 'other_tables'].map((table) => // TODO: Get actual tables
                                        DropdownMenuItem(
                                          value: table,
                                          child: Text(table),
                                        ),
                                      ).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          field['referencedTable'] = value;
                                        });
                                      },
                                    ),
                                ] else if (field['type'] == 'TEXT') ...[
                                  const Text('Text Constraints:', 
                                    style: TextStyle(fontSize: 12, color: Colors.grey)
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                            labelText: 'Max Length',
                                            helperText: 'Leave empty for unlimited',
                                          ),
                                          keyboardType: TextInputType.number,
                                          onChanged: (value) {
                                            setState(() {
                                              field['maxLength'] = int.tryParse(value);
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: kSpacingSmall),
                                      Expanded(
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                            labelText: 'Pattern (Regex)',
                                            helperText: 'Validation pattern',
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              field['pattern'] = value;
                                            });
                                          },
                                        ),
                                ),
                              ],
                            ),
                                ] else if (field['type'] == 'DATETIME') ...[
                                  const Text('DateTime Constraints:', 
                                    style: TextStyle(fontSize: 12, color: Colors.grey)
                                  ),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      FilterChip(
                                        label: const Text('Default to Current Time'),
                                        selected: field['defaultToCurrentTime'] ?? false,
                                        onSelected: (value) {
                                          setState(() {
                                            field['defaultToCurrentTime'] = value;
                                          });
                                        },
                          ),
                        ],
                      ),
                                ] else if (field['type'] == 'REAL') ...[
                                  const Text('Numeric Constraints:', 
                                    style: TextStyle(fontSize: 12, color: Colors.grey)
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                            labelText: 'Precision',
                                            helperText: 'Total digits',
                                          ),
                                          keyboardType: TextInputType.number,
                                          onChanged: (value) {
                                            setState(() {
                                              field['precision'] = int.tryParse(value);
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: kSpacingSmall),
                                      Expanded(
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                            labelText: 'Scale',
                                            helperText: 'Decimal places',
                                          ),
                                          keyboardType: TextInputType.number,
                                          onChanged: (value) {
                                            setState(() {
                                              field['scale'] = int.tryParse(value);
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                
                                // Default Value Section
                                const SizedBox(height: kSpacingMedium),
                                TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Default Value',
                                    helperText: 'Leave empty for no default',
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      field['defaultValue'] = value.isEmpty ? null : value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                  // Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: kSpacingSmall),
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState?.validate() ?? false) {
                            // TODO: Implement field creation
                            // 1. Add column to table
                            // 2. Generate migration
                            // 3. Update schema
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Field creation not implemented yet'),
                              ),
                            );
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Add Field'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 