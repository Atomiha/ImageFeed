//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Михаил Атоян on 03.01.2025.
//

import UIKit


final class OAuth2TokenStorage {
    private let tokenKey = "oauth2Token"
    static let shared = OAuth2TokenStorage() 
    
    var token: String? {
        get {
            UserDefaults.standard.string(forKey: tokenKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: tokenKey)
        }
    }
}
