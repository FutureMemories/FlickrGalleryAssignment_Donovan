//
//  FlickrRoute.swift
//  FlickrGalleryAssignment
//
//  Created by Donovan Söderlund on 2020-04-07.
//  Copyright © 2020 Future Memories. All rights reserved.
//

import Foundation

enum FlickrRoute {
    
    /// Returns a list of the latest public photos uploaded to flickr.
    case getRecent(perPage: Int, page: Int)
    
    /// Return a list of photos matching some criteria.
    case search(searchTerm: String, tags: String, perPage: Int, page: Int)
    
}

extension FlickrRoute: Route {
    
    var host: String { "https://www.flickr.com/services/rest/" }
    
    var path: String { "" }
    
    var method: String {
        switch self {
        case .getRecent, .search:
            return "GET"
        }
    }
    
    var headers: [String : String]? { nil }
    
    var parameters: [String : String]? {
        switch self {
        case let .getRecent(perPage, page):
            return [
                "method" : "flickr.photos.getRecent",
                "per_page" : "\(perPage)",
                "page" : "\(page)"
            ]
        case let .search(searchTerm, tags, perPage, page):
            return [
                "method" : "flickr.photos.search",
                "tags" : tags,
                "text" : searchTerm,
                "per_page" : "\(perPage)",
                "page" : "\(page)"
            ]
        }
    }
    
    var body: Data? { nil }
    
}
