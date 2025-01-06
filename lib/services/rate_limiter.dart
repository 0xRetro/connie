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
/// if (limiter.checkLimit()) {
///   // Make API request
/// } else {
///   final waitTime = limiter.timeUntilNextWindow();
///   print('Rate limit exceeded. Try again in $waitTime');
/// }
/// ```
class RateLimiter {
  final int maxRequests;
  final Duration interval;
  final _timestamps = <DateTime>[];

  RateLimiter({
    required this.maxRequests,
    required this.interval,
  });

  /// Checks if a request can be made within the current rate limit window
  bool checkLimit() {
    final now = DateTime.now();
    _timestamps.removeWhere(
      (timestamp) => now.difference(timestamp) > interval,
    );
    if (_timestamps.length >= maxRequests) {
      return false;
    }
    _timestamps.add(now);
    return true;
  }

  /// Returns the duration until the next rate limit window
  Duration timeUntilNextWindow() {
    if (_timestamps.isEmpty) return Duration.zero;
    
    final now = DateTime.now();
    final oldestTimestamp = _timestamps.reduce(
      (a, b) => a.isBefore(b) ? a : b,
    );
    
    final timeUntilExpiry = interval - now.difference(oldestTimestamp);
    return timeUntilExpiry.isNegative ? Duration.zero : timeUntilExpiry;
  }

  /// Clears all timestamps, effectively resetting the rate limiter
  void reset() {
    _timestamps.clear();
  }
} 