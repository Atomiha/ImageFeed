//
//  ViewController.swift
//  ImageFeed
//
//  Created by Михаил Атоян on 27.10.2024.
//

import UIKit

final class ImagesListViewController: UIViewController {
    
    private let  photoName = Array(0 ..< 20).map {"\($0)"}
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()

    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let cellName = photoName[indexPath.row]
        guard let image = UIImage(named: cellName) else {return}
        cell.cellImage.image = image
        
        cell.dateLabel.text = dateFormatter.string(from: Date())
        
        let likeImage = indexPath.row % 2 == 0 ?
            UIImage(named: "ActiveLikeButton"):
            UIImage(named: "NoActiveLikeButton")
        
        cell.likeButton.setImage(likeImage, for: .normal)
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoName.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        let cellName = photoName[indexPath.row]
        guard let image = UIImage(named: cellName) else {return 0}
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        guard imageWidth != 0 else {return 0}
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}
