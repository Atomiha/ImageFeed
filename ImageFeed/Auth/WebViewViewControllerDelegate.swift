//
//  WebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Михаил Атоян on 10.12.2024.
//


protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
