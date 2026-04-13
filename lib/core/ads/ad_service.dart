/// Stub ad service — ready for AdMob integration in v1.1.
///
/// To activate:
///   1. Add `google_mobile_ads: ^5.1.0` to pubspec.yaml
///   2. Configure AndroidManifest with your AdMob App ID
///   3. Uncomment the real implementation below and remove the stub.
///
/// Child-safety rules (ALWAYS keep when enabling real ads):
///   - maxAdContentRating: MaxAdContentRating.g
///   - tagForChildDirectedTreatment: TagForChildDirectedTreatment.yes
///   - tagForUnderAgeOfConsent: TagForUnderAgeOfConsent.yes
///   - Show ads ONLY between completed mysteries — never during gameplay
class AdService {
  static final AdService instance = AdService._();
  AdService._();

  bool _initialized = false;

  Future<void> initialize() async {
    // TODO(v1.1): await MobileAds.instance.initialize();
    // TODO(v1.1): MobileAds.instance.updateRequestConfiguration(
    //   RequestConfiguration(
    //     maxAdContentRating: MaxAdContentRating.g,
    //     tagForChildDirectedTreatment: TagForChildDirectedTreatment.yes,
    //     tagForUnderAgeOfConsent: TagForUnderAgeOfConsent.yes,
    //   ),
    // );
    _initialized = true;
  }

  /// Call after a mystery is completed. Shows an interstitial if ready.
  /// In the stub implementation this is a no-op.
  Future<void> showPostMysteryAd() async {
    if (!_initialized) return;
    // TODO(v1.1): load and show interstitial
  }

  /// Optional reward ad. Returns true if the user watched it fully.
  Future<bool> showRewardedAd() async {
    if (!_initialized) return false;
    // TODO(v1.1): load and show rewarded ad
    return false;
  }
}
