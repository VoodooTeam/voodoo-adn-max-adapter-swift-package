import AppLovinSDK
import Foundation
import VoodooAdn

protocol ServicesProvider {
    var privacyService: PrivacyService { get }
    var signalProvider: MASignalProvider { get }
    var interstitialAdService: FullScreenAdService { get }
    var rewardedAdService: FullScreenAdService { get }
    var nativeAdService: NativeAdService { get }
}
