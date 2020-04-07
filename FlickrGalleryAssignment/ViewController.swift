//
//  ViewController.swift
//  FlickrGalleryAssignment
//
//  Created by Donovan Söderlund on 2020-04-07.
//  Copyright © 2020 Future Memories. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var client: NetworkClient = .shared
    private lazy var dataSource = makeDataSource()
    
    private var tags: String = "sports"
    private var currentPage: Int = 0
    private var isLoadingPhotos: Bool = false
    private var spinner: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = dataSource
        tableView.delegate = self
        
        spinner = view.addSpinner()
        loadPhotos(page: currentPage)
    }
    
    private func loadMore() {
        loadPhotos(page: currentPage+1)
    }
    
    private func loadPhotos(page: Int) {
        isLoadingPhotos = true
        client.perform(FlickrRoute.search(searchTerm: "", tags: tags, perPage: 10, page: page)) { [weak self] (result: Result<PhotosContainer, NetworkClientError>) in
            guard let self = self else { return }
            self.isLoadingPhotos = false
            self.spinner?.removeFromSuperview()
            self.spinner = nil
            switch result {
            case .success(let photosContainer):
                self.addPhotos(photosContainer.photos.photo)
                self.currentPage = photosContainer.photos.page
            case .failure:
                let alertController = UIAlertController(title: "Error", message: "Could not load photos", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alertController, animated: true)
            }
        }
    }
    
    private func addPhotos(_ photos: [Photo]) {
        var snapshot = dataSource.snapshot()
        if snapshot.sectionIdentifiers.isEmpty {
            snapshot.appendSections(["Section"])
        }
        snapshot.appendItems(photos)
        dataSource.apply(snapshot)
    }

    private func makeDataSource() -> UITableViewDiffableDataSource<String, Photo> {
        return UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, photo -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
            if let aspectRatio = photo.aspectRatio {
                let height = tableView.frame.size.width/CGFloat(aspectRatio)
                cell.imageHeightConstraint.constant = height
            } else {
                cell.imageHeightConstraint.constant = tableView.frame.size.width
            }
            cell.photoView.loadPhoto(photo)
            cell.titleLabel.text = photo.title
            return cell
        }
    }

}

extension ViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !isLoadingPhotos else { return }
        if scrollView.contentOffset.y + scrollView.frame.size.height + 200 > scrollView.contentSize.height {
            loadMore()
        }
    }
    
}

