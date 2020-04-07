//
//  UIImageView+Extensions.swift
//  FlickrGalleryAssignment
//
//  Created by Donovan Söderlund on 2020-04-07.
//  Copyright © 2020 Future Memories. All rights reserved.
//

import UIKit

class FlickrImageView: UIImageView {
    
    private var dataTask: URLSessionDataTask?
    private var spinner: UIActivityIndicatorView?
    
    var urlSession: URLSession = .shared
    
    func loadPhoto(_ photo: Photo) {
        guard let url = URL(string: "https://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret)_z.jpg") else {
            return
        }
        loadImage(from: url)
    }
    
    override var image: UIImage? {
        didSet {
            dataTask?.cancel()
        }
    }
    
    private func loadImage(from url: URL) {
        image = nil
        self.spinner = addSpinner()
        dataTask = urlSession.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                self.spinner?.removeFromSuperview()
                self.spinner = nil
                if error == nil, let data = data {
                    self.image = UIImage(data: data)
                }
            }
        }
        dataTask?.resume()
    }
    
}
