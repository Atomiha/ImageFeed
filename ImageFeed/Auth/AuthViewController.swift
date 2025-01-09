//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Михаил Атоян on 09.12.2024.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

final class AuthViewController: UIViewController, WebViewViewControllerDelegate {
    private let webViewIdentifier = "ShowWebView"
    private let oauth2Service = OAuth2Service.shared
    
    weak var delegate: AuthViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
    }
    
    func configureBackButton()  {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "backward_button")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "backward_button")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "YPBlack")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == webViewIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else {
                assertionFailure("Failed to prepare for \(webViewIdentifier)")
                return
            }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        oauth2Service.fetchOAuthToken(code: code) {[weak self] result in
            switch result {
            case .success(let token):
                print("Successfully fetched token: \(token)")
                guard let self else { return }
                OAuth2TokenStorage.shared.token = token
                delegate?.authViewController(self, didAuthenticateWithCode: code)
            case .failure(let error):
                print("Failed to fetch token: \(error.localizedDescription)")
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
    
}
