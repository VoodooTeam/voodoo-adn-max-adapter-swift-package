import AppLovinSDK
import Foundation
import VoodooAdn

// swiftlint:disable file_types_order
public extension AdnSdk {
    /// Represents the AppLovin Adn adapater.
    @objc(ALVoodooAdapter)
    final class AppLovinAdapter: ALMediationAdapter {
        /// Version of the Adn SDK.
        var SDKVersion: String {
            AdnSdk.version
        }

        private var servicesProvider: ServicesProvider = ServicesProviderBase()

        private var signalProvider: MASignalProvider {
            servicesProvider.signalProvider
        }

        private lazy var interstitialAdAdapter: FullscreenAdAdapter = FullscreenAdAdapterBase(
            adStorage: .init(queue: .init(label: "AdnSdk.AppLovin.InterstitialAdStorage")),
            adService: servicesProvider.interstitialAdService
        )
        private lazy var rewardedAdAdapter: FullscreenAdAdapter = FullscreenAdAdapterBase(
            adStorage: .init(queue: .init(label: "AdnSdk.AppLovin.RewardedAdStorage")),
            adService: servicesProvider.rewardedAdService
        )
        private lazy var nativeAdAdapter: NativeAdAdapter = NativeAdAdapterBase(
            adService: servicesProvider.nativeAdService
        )
    }
}

// ALMediationAdapter overrides
public extension AdnSdk.AppLovinAdapter {
    /// Version of the AppLovin Adn adapter.
    override var adapterVersion: String {
        Constants.adapterVersion
    }

    /// Main constructor.
    override func initialize(with parameters: any MAAdapterInitializationParameters) async -> (MAAdapterInitializationStatus, String?) {
        do {
            try await AdnSdk.initialize(options: .withMediationName(Constants.mediationName))
            return (.initializedSuccess, nil)
        } catch {
            return (.initializedFailure, error.localizedDescription)
        }
    }
}

extension AdnSdk.AppLovinAdapter: MASignalProvider {
    public func collectSignal(with parameters: any MASignalCollectionParameters, andNotify delegate: any MASignalCollectionDelegate) {
        signalProvider.collectSignal(with: parameters, andNotify: delegate)
    }
}

extension AdnSdk.AppLovinAdapter: MAInterstitialAdapter {
    public func loadInterstitialAd(for parameters: any MAAdapterResponseParameters, andNotify delegate: any MAInterstitialAdapterDelegate) {
        let bridge = MAInterstitialAdapterDelegateBridge(original: delegate)
        interstitialAdAdapter.loadAd(for: parameters) { result in
            bridge.handleLoadAdResult(result)
        }
    }

    public func showInterstitialAd(for parameters: any MAAdapterResponseParameters, andNotify delegate: any MAInterstitialAdapterDelegate) {
        let bridge = MAInterstitialAdapterDelegateBridge(original: delegate)
        interstitialAdAdapter.showAd(for: parameters) { result in
            bridge.handleShowAdResult(result)
        }
    }
}

extension AdnSdk.AppLovinAdapter: MARewardedAdapter {
    public func loadRewardedAd(for parameters: any MAAdapterResponseParameters, andNotify delegate: any MARewardedAdapterDelegate) {
        let bridge = MARewardedAdapterDelegateBridge(original: delegate,
                                                     reward: reward,
                                                     shouldAlwaysRewardUser: shouldAlwaysRewardUser)
        rewardedAdAdapter.loadAd(for: parameters) { result in
            bridge.handleLoadAdResult(result)
        }
    }

    public func showRewardedAd(for parameters: any MAAdapterResponseParameters, andNotify delegate: any MARewardedAdapterDelegate) {
        configureReward(for: parameters)
        let bridge = MARewardedAdapterDelegateBridge(original: delegate,
                                                     reward: reward,
                                                     shouldAlwaysRewardUser: shouldAlwaysRewardUser)
        rewardedAdAdapter.showAd(for: parameters) { result in
            bridge.handleShowAdResult(result)
        }
    }
}

extension AdnSdk.AppLovinAdapter: MANativeAdAdapter {
    public func loadNativeAd(for parameters: any MAAdapterResponseParameters, andNotify delegate: any MANativeAdAdapterDelegate) {
        let bridge = MANativeAdAdapterDelegateBridge(original: delegate)
        nativeAdAdapter.loadAd(for: parameters,
                               eventsHandler: bridge.handleAdEvents,
                               completionHandler: bridge.handleLoadAdResult)
    }
}
