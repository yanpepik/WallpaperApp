//
//  Model.swift
//  WallpaperApplication
//
//  Created by Yan Pepik on 28.01.22.
//

struct CuratedPhotoDTO: Decodable {
    let page: Int
    let per_page: Int
    let next_page: String?
    let total_results: Int
    let photos: [PexelPhoto]
}

struct PexelPhoto: Decodable {
    let id: Int
    let photographer: String
    let src: PexelPhotoSrc
    let alt: String
}

struct PexelPhotoSrc: Decodable {
    let original: String
    let medium: String
}


