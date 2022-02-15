//
//  MainEndpoint.swift
//  WallpaperApplication
//
//  Created by Yan Pepik on 28.01.22.
//

import Foundation

enum MainEndpoint: EndpointProtocol {
    case getCuratedPhotos(page: Int)
    case getPhotosByName(keyword: String, page: Int)
    
    var scheme: String {
        return "https"
    }
    
    var host: String {
        return "api.pexels.com"
    }
    
    var method: RequestMethod {
        return .GET
    }
    
    var headers: [String: String]? {
        return ["Authorization" : "563492ad6f91700001000001efff8c9f45a946c1a8e7d51afbacaa2d"]
    }
    
    var path: String {
        switch self {
        case .getCuratedPhotos:
            return "/v1/curated"
        case .getPhotosByName:
            return "/v1/search"
        }
    }
    
    var parameters: [URLQueryItem]? {
        switch self {
        case .getCuratedPhotos(let page):
            return [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "per_page", value: "16")
            ]
        case .getPhotosByName(let query , let page):
            return [
                URLQueryItem(name: "query", value: "\(query)"),
                URLQueryItem(name: "page", value: "\(page)"),
            ]
        }
    }
}
