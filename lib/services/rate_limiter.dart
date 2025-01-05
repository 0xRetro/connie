/// A token bucket rate limiter implementation for controlling request rates.
/// 
/// This rate limiter uses a token bucket algorithm where tokens are replenished
/// at a fixed interval. Each request consumes one token, and requests are only
/// allowed when tokens are available.
///
/// Example usage:
/// ```dart
/// final limiter = RateLimiter(
///   maxRequests: 60,
///   interval: Duration(minutes: 1),
/// );
///
/// if (limiter.tryAcquire()) {
///   // Make API request
/// } else {
///   final waitTime = limiter.timeUntilNextToken;
///   print('Rate limit exceeded. Try again in $waitTime');
/// }
/// ```
class RateLimiter {
  /// Creates a new rate limiter.
  /// 
  /// [maxRequests] is the maximum number of requests allowed per [interval].
  /// [interval] is the time period after which the tokens are fully replenished.
  RateLimiter({
    required this.maxRequests,
    required this.interval,
  }) : _lastRefill = DateTime.now(),
       _tokens = maxRequests;

  /// Maximum number of requests allowed per interval
  final int maxRequests;

  /// Time period for token replenishment
  final Duration interval;

  /// Current number of available tokens
  int _tokens;

  /// Timestamp of the last token refill
  DateTime _lastRefill;

  /// Attempts to acquire a token for making a request.
  /// 
  /// Returns true if a token was acquired, false otherwise.
  bool tryAcquire() {
    _refillTokens();
    if (_tokens > 0) {
      _tokens--;
      return true;
    }
    return false;
  }

  /// Refills the token bucket based on the time passed since last refill.
  void _refillTokens() {
    final now = DateTime.now();
    final timePassed = now.difference(_lastRefill);
    if (timePassed >= interval) {
      _tokens = maxRequests;
      _lastRefill = now;
    }
  }

  /// Returns the duration until the next token becomes available.
  /// 
  /// Returns Duration.zero if tokens are currently available.
  Duration? get timeUntilNextToken {
    _refillTokens();
    if (_tokens > 0) return Duration.zero;
    final timePassed = DateTime.now().difference(_lastRefill);
    return interval - timePassed;
  }

  /// Returns the current number of available tokens.
  int get availableTokens {
    _refillTokens();
    return _tokens;
  }

  /// Resets the rate limiter to its initial state.
  /// 
  /// This will restore all tokens and reset the last refill timestamp.
  void reset() {
    _tokens = maxRequests;
    _lastRefill = DateTime.now();
  }
} 