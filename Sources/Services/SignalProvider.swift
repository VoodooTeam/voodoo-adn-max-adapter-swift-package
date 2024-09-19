import AppLovinSDK
import Foundation
import VoodooAdn

class SignalProvider: NSObject, MASignalProvider {
    private var privacyService: PrivacyService

    init(privacyService: PrivacyService) {
        self.privacyService = privacyService
    }

    func collectSignal(with parameters: any MASignalCollectionParameters, andNotify delegate: any MASignalCollectionDelegate) {
        privacyService.updatePrivacySettings(parameters)
        AdnSdk.getBidToken(placement: parameters.adFormat.adnFormat) { token, _ in
            delegate.didCollectSignal(token)
        }
    }
}

private extension MAAdFormat {
    var adnFormat: AdnPlacementType {
        switch self {
        case .banner:
                .banner

        case .interstitial:
                .interstitial

        case .rewarded:
                .rewarded

        default:
                .none
        }
    }
}
