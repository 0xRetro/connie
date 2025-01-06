# Ollama Rate Limiter

## File Location
`lib/services/ollama/rate_limiter.dart`

## Purpose
Provides token bucket rate limiting for Ollama API requests to prevent overloading and ensure fair usage.

## Key Features
- Token bucket algorithm
- Configurable request limits
- Automatic token refills
- Time tracking
- Token availability checks

## Implementation
```dart
class RateLimiter {
  RateLimiter({
    required int maxRequests,
    required Duration interval,
  });
}
```

## Configuration
- `maxRequests`: Maximum requests per interval
- `interval`: Time period for token refresh

## Methods
- `tryAcquire()`: Attempt to acquire a token
- `timeUntilNextToken`: Get wait time for next token
- `availableTokens`: Get current token count
- `reset()`: Reset the limiter state

## Usage Example
```dart
final limiter = RateLimiter(
  maxRequests: 60,
  interval: Duration(minutes: 1),
);

// Try to make a request
if (limiter.tryAcquire()) {
  // Make API request
} else {
  final waitTime = limiter.timeUntilNextToken;
  print('Rate limit exceeded. Try again in $waitTime');
}
```

## Integration Points
- Used by `OllamaService` for request rate limiting
- Integrated with Dio interceptors
- Configurable through `OllamaConfig`

## Error Handling
- Returns `false` when rate limit exceeded
- Provides time until next available token
- Integrates with `OllamaRateLimitError`

## Best Practices
1. Configure limits based on API requirements
2. Handle rate limit errors gracefully
3. Implement backoff strategies
4. Monitor token usage
5. Reset on configuration changes

## Performance
- O(1) time complexity for token checks
- Minimal memory footprint
- Thread-safe operations
- Efficient token refill 