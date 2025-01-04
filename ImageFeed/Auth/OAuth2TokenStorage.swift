//
//  Untitled.swift
//  ImageFeed
//
//  Created by Михаил Атоян on 03.01.2025.
//

import UIKit


class OAuth2TokenStorage {
    private let tokenKey = "oauth2Token"
    
    var token: String? {
        get {
            return UserDefaults.standard.string(forKey: tokenKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: tokenKey)
        }
    }
}
