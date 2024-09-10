import AppLovinSDK
import Foundation
import VoodooAdn

class NativeAdAdapterBase {
    private let privacyService: PrivacyService
    private let adService: NativeAdService

    init(privacyService: PrivacyService, adService: NativeAdService) {
        self.privacyService = privacyService
        self.adService = adService
    }

    private func updatePrivacySettings(_ settings: any MAAdapterParameters) {
        privacyService.updatePrivacySettings(settings)
    }
}

extension NativeAdAdapterBase: NativeAdAdapter {
    func loadAd(for parameters: any MAAdapterResponseParameters,
                eventsHandler: @escaping (AdnSdk.NativeAdUnit) -> Void,
                completionHandler: @escaping (Result<MANativeAd, MAAdapterError>) -> Void) {
        guard #available(iOS 14, *) else {
            completionHandler(.failure(MAAdapterError.invalidConfiguration))
            return
        }

        updatePrivacySettings(parameters)

        adService.loadAd(.init(adMarkup: parameters.bidResponse,
                               thirdPartyAdPlacementIdentifier: parameters.thirdPartyAdPlacementIdentifier)) { [weak self] result in
            self?.handleLoadAd(result, eventsHandler: eventsHandler, completionHandler: completionHandler)
        }
    }

    private func handleLoadAd(_ result: Result<AdnSdk.NativeAdUnit, Error>,
                              eventsHandler: @escaping (AdnSdk.NativeAdUnit) -> Void,
                              completionHandler: @escaping (Result<MANativeAd, MAAdapterError>) -> Void) {
        switch result {
        case .success(let adUnit):
            eventsHandler(adUnit)
            completionHandler(.success(adUnit.MANativeAd))

        case .failure(let error):
            completionHandler(.failure(error.adapterLoadAdError))
        }
    }
}

extension AdnSdk.NativeAdUnit {
    // swiftlint:disable closure_body_length
    var MANativeAd: ADNMANativeAd {
        .init(container: self, format: .native) { builder in
            builder.title = getRawData(of: .title)
            builder.advertiser = getRawData(of: .advertiser)
            builder.body = getRawData(of: .body)
            builder.callToAction = getRawData(of: .cta)
            builder.starRating = getRawData(of: .starRating)
            builder.mediaView = getUIView(of: .mainVideo) ?? getUIView(of: .mainImage)
            builder.iconView = getUIView(of: .icon)
            builder.optionsView = getUIView(of: .privacy)
        }
    }
    // swiftlint:enable closure_body_length
}
