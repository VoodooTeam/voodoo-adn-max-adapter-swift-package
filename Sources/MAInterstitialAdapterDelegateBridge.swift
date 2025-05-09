import AppLovinSDK
import Foundation

final class MAInterstitialAdapterDelegateBridge {
    weak var original: MAInterstitialAdapterDelegate?

    init(original: MAInterstitialAdapterDelegate? = nil) {
        self.original = original
    }

    func handleLoadAdResult(_ result: MAAdapterErrorResult) {
        switch result {
        case .success:
            original?.didLoadInterstitialAd()

        case .failure(let error):
            original?.didFailToLoadInterstitialAdWithError(error)
        }
    }

    func handleShowAdResult(_ result: AdUnitShowStateResult) {
        switch result {
        case .click:
            original?.didClickInterstitialAd()

        case .impression:
            original?.didDisplayInterstitialAd()

        case .dismissed:
            original?.didHideInterstitialAd()

        case .rewarded:
            return

        case .failure(let error):
            original?.didFailToDisplayInterstitialAdWithError(error.adapterDisplayAdError)

        case .started:
            return
            // do nothing since mediation doesn't distinct impression vs displayed ad.

        @unknown default:
            return
        }
    }
}
