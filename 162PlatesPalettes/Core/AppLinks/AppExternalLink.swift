//
//  AppExternalLink.swift
//  162PlatesPalettes
//

import Foundation

/// Central place for outbound URLs. Update hosts for production.
enum AppExternalLink {
    case privacyPolicy
    case termsOfUse
    
    
    var url: URL? {
        switch self {
        case .privacyPolicy:
            return URL(string: "https://plates162palettes.site/privacy/164")
        case .termsOfUse:
            return URL(string: "https://plates162palettes.site/terms/164")
            
        }
    }
}
