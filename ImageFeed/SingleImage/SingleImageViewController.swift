//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Михаил Атоян on 23.11.2024.
//

import UIKit

class SingleImageViewController: UIViewController {
    var image: UIImage? {
        didSet {
            guard isViewLoaded else { return } // 1
            imageView.image = image // 2
        }
    }
    @IBOutlet var imageView: UIImageView!
    @IBAction private func didTapBackButton() {
            dismiss(animated: true, completion: nil)
        }
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
}
