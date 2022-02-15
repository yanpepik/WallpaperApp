//
//  MainViewProtocol.swift
//  WallpaperApplication
//
//  Created by Yan Pepik on 28.01.22.
//

protocol MainViewProtocol: AnyObject {
    func displayPhotos(model: [Photo])
    func updateNextPage(page: Int)
    func displayError()
}
