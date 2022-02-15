//
//  DetailInfoViewProtocol.swift
//  WallpaperApplication
//
//  Created by Yan Pepik on 30.01.22.
//

protocol DetailInfoViewProtocol: AnyObject {
    func displayDetailInfo(viewModel: DetailInfoViewModel)
    func displayActivityController(items: [String])
    func displayError()
    func displaySuccessMessage()
}
