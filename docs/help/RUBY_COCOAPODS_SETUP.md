# Ruby and CocoaPods Setup Guide for macOS

## Problem
macOS comes with a system Ruby installation that can cause conflicts with Homebrew's Ruby version, particularly when working with CocoaPods for Flutter development. This guide helps you set up Ruby properly using Homebrew and configure CocoaPods for Flutter development.

## Solution Steps

### 1. Install Ruby via Homebrew
```bash
brew install ruby
```

### 2. Configure Ruby Path
Add these lines to your shell configuration file (`~/.zshrc` for Zsh or `~/.bash_profile` for Bash):

```bash
# Ruby from Homebrew
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export PATH="`gem env gemdir`/bin:$PATH"
```

### 3. Apply Changes
```bash
# For Zsh
source ~/.zshrc

# For Bash
source ~/.bash_profile
```

### 4. Verify Ruby Installation
```bash
# Should show Homebrew Ruby path (usually /opt/homebrew/opt/ruby/bin/ruby)
which ruby

# Should show Homebrew Ruby version
ruby --version
```

### 5. Install CocoaPods
```bash
gem install cocoapods
```

### 6. Verify CocoaPods Installation
```bash
pod --version
```

## Troubleshooting

### Common Issues

1. **Ruby Version Mismatch**
   - If `which ruby` still shows system Ruby (`/usr/bin/ruby`):
     - Ensure Homebrew is in your PATH
     - Check that the Ruby path configuration is correct in your shell config
     - Try opening a new terminal window

2. **Permission Issues**
   - If you get permission errors during gem installation:
     ```bash
     gem install cocoapods --user-install
     ```

3. **Path Issues**
   - If commands aren't found after installation:
     ```bash
     # Add this to your shell config file
     export GEM_HOME=$HOME/.gem
     export PATH=$GEM_HOME/bin:$PATH
     ```

## Notes

- The system Ruby in macOS is intended for system use only and should not be modified
- Using Homebrew's Ruby provides a cleaner, more maintainable development environment
- Keep Ruby and CocoaPods updated with:
  ```bash
  brew upgrade ruby
  gem update cocoapods
  ```

## Related Documentation
- [Flutter Platform Plugins](https://flutter.dev/to/platform-plugins)
- [CocoaPods Installation Guide](https://guides.cocoapods.org/using/getting-started.html)
- [Homebrew Documentation](https://docs.brew.sh) 