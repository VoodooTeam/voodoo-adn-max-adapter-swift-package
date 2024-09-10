import AppLovinSDK
import Foundation
import VoodooAdn

struct PrivacyServiceBase: PrivacyService {
    func updatePrivacySettings(_ settings: MAAdapterParameters) {
        updateAgeRestriction(settings)
        updateUserConsent(settings)
    }

    private func updateAgeRestriction(_ settings: MAAdapterParameters) {
        guard let isAgeRestrictedUser = settings.ageRestrictedUser else {
            return
        }
        AdnSdk.updateAgeRestriction(status: isAgeRestrictedUser.boolValue)
    }

    private func updateUserConsent(_ settings: MAAdapterParameters) {
        guard let hasUserConsent = settings.userConsent else {
            return
        }
        AdnSdk.updateHasUserConsent(status: hasUserConsent.boolValue)
    }
}
