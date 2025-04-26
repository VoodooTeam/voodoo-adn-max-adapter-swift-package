import AppLovinSDK
import Foundation
import VoodooAdn

final class MANativeAdAdapterDelegateBridge {
    weak var original: MANativeAdAdapterDelegate?

    init(original: MANativeAdAdapterDelegate? = nil) {
        self.original = original
    }

    func handleLoadAdResult(_ result: Result<MANativeAd, MAAdapterError>) {
        switch result {
        case .success(let ad):
            original?.didLoadAd(for: ad, withExtraInfo: nil)

        case .failure(let error):
            original?.didFailToLoadNativeAdWithError(error)
        }
    }

    func handleAdEvents(_ adUnit: AdnSdk.NativeAdUnit) {
        adUnit.observeShowEvents { event in
            self.handleShowEvent(event)
        }
    }

    private func handleShowEvent(_ event: AdnSdk.AdNativeShowState) {
        switch event {
        case .click:
            original?.didClickNativeAd()

        case .impression:
            original?.didDisplayNativeAd(withExtraInfo: nil)

        case .started:
            return
            // do nothing since mediation doesn't distinct impression vs displayed ad.

        default:
            break
        }
    }
}
