//
//  PhotoCell.swift
//  FlickrGalleryAssignment
//
//  Created by Donovan Söderlund on 2020-04-07.
//  Copyright © 2020 Future Memories. All rights reserved.
//

import UIKit

final class PhotoCell: UITableViewCell {
    
    @IBOutlet weak var photoView: FlickrImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    
}
