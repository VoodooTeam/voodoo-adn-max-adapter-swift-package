import AppLovinSDK
import Foundation
import VoodooAdn

struct NativeAdServiceBase: NativeAdService {
    func loadAd(_ options: AdServiceLoadOptions, completion: @escaping (Result<any AdnSdk.NativeAdUnit, any Error>) -> Void) {
        AdnSdk.loadNativeAd(.init(placement: .native, adMarkup: options.adMarkup)) { result in
            completion(result)
        }
    }
}
