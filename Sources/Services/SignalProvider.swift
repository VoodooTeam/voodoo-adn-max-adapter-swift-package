import AppLovinSDK
import Foundation
import VoodooAdn

class SignalProvider: NSObject, MASignalProvider {
    private var errorToken: String {
        "eyJ0b2tlbl9lcnJvciI6ICJVbnN1cHBvcnRlZCBpT1MgdmVyc2lvbiAoZnJvbSBhZGFwdGVyKSIsICJzZGtfdmVyc2lvbiI6ICIyLjMuMTMifQ=="
    }

    private var privacyService: PrivacyService

    init(privacyService: PrivacyService) {
        self.privacyService = privacyService
    }

    func collectSignal(with parameters: any MASignalCollectionParameters, andNotify delegate: any MASignalCollectionDelegate) {
        guard #available(iOS 14, *) else {
            // Send an error token, never send a fail to the mediation.
            delegate.didCollectSignal(errorToken)
            return
        }

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
