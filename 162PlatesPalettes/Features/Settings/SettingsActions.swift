//
//  SettingsActions.swift
//  162PlatesPalettes
//

import StoreKit
import UIKit

enum SettingsActions {
    static func openExternalURL(_ link: AppExternalLink) {
        if let url = link.url {
            UIApplication.shared.open(url)
        }
    }

    static func rateApp() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
}
