/// Centralised, type-safe route names.
///
/// Even with a single screen today, funnelling navigation through named routes
/// (rather than scattering `MaterialPageRoute`s) keeps the app ready to scale
/// to a real OTT product without rewrites.
abstract final class AppRoutes {
  const AppRoutes._();

  static const String home = '/';
}
