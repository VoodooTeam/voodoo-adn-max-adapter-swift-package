import AppLovinSDK
import Foundation
import VoodooAdn

struct PrivacyServiceBase: PrivacyService {
    func updatePrivacySettings(_ settings: MAAdapterParameters) {
        updateUserConsent(settings)
    }

    private func updateUserConsent(_ settings: MAAdapterParameters) {
        guard let hasUserConsent = settings.userConsent else {
            return
        }
        AdnSdk.updateUserConsent(hasUserConsent.boolValue)
    }
}
