import AppLovinSDK
import Foundation

final class MARewardedAdapterDelegateBridge {
    weak var original: MARewardedAdapterDelegate?
    var shouldAlwaysRewardUser: Bool
    var reward: MAReward?
    private var hasBeenRewarded = false

    init(original: MARewardedAdapterDelegate? = nil, reward: MAReward? = nil, shouldAlwaysRewardUser: Bool = false) {
        self.original = original
        self.shouldAlwaysRewardUser = shouldAlwaysRewardUser
        self.reward = reward
    }

    func handleLoadAdResult(_ result: MAAdapterErrorResult) {
        switch result {
        case .success:
            original?.didLoadRewardedAd()

        case .failure(let error):
            original?.didFailToLoadRewardedAdWithError(error)
        }
    }

    func handleShowAdResult(_ result: AdUnitShowStateResult) {
        switch result {
        case .click:
            original?.didClickRewardedAd()

        case .started:
            original?.didDisplayRewardedAd()

        case .dismissed:
            if shouldAlwaysRewardUser {
                rewardUser()
            }
            original?.didHideRewardedAd()

        case .rewarded:
            rewardUser()

        case .failure(let error):
            original?.didFailToDisplayRewardedAdWithError(error.adapterDisplayAdError)

        @unknown default:
            return
        }
    }

    private func rewardUser() {
        guard let reward, !hasBeenRewarded else {
            return
        }
        hasBeenRewarded = true
        original?.didRewardUser(with: reward)
    }
}
