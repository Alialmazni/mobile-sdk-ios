//
//  Locale.swift
//  CrowdinSDK
//
//  Created by Serhii Londar on 1/25/19.
//  Copyright © 2019 Crowdin. All rights reserved.
//

import Foundation

extension Locale {
    static var preferredLanguageIdentifiers: [String] {
        return Locale.preferredLanguages.compactMap ({
            let comps = Locale.components(fromIdentifier: $0)
            return comps.values.first?.lowercased() ?? ""
        })
    }
}