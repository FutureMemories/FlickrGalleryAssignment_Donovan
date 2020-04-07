//
//  Photos.swift
//  FlickrGalleryAssignment
//
//  Created by Donovan Söderlund on 2020-04-07.
//  Copyright © 2020 Future Memories. All rights reserved.
//

import Foundation

struct PhotosContainer: Decodable {
    let photos: Photos
}

struct Photos: Decodable {
    let page: Int
    let pages: Int
    let perpage: Int
    let photo: [Photo]
}

struct Photo: Decodable, Hashable {
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    let height_m: Double?
    let width_m: Double?
}

extension Photo {
    
    var aspectRatio: Double? {
        guard let width = width_m, let height = height_m else { return nil }
        return width/height
    }
    
}
