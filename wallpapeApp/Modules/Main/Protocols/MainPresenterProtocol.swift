//
//  MainViewPresenter.swift
//  WallpaperApplication
//
//  Created by Yan Pepik on 28.01.22.
//

protocol MainPresenterProtocol: AnyObject {
    func fetchData(page: Int)
    func fetchSearchData(page: Int, text: String?)
    func tapOnThePhoto(model: Photo?)
}
