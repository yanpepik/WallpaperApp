//
//  DetailInfoPresenter.swift
//  WallpaperApplication
//
//  Created by Yan Pepik on 30.01.22.
//

import UIKit
import Kingfisher

final class DetailInfoPresenter: NSObject {
    // MARK: - Properties
    weak var view: DetailInfoViewProtocol?
    
    private let router: RouterProtocol?
    private let model: Photo?
    
    // MARK: - Initialization
    init(view: DetailInfoViewProtocol, router: RouterProtocol, model: Photo?) {
        self.view = view
        self.router = router
        self.model = model
    }
    
    // MARK: - Private Methods
    @objc private func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error != nil {
            view?.displayError()
        } else {
            view?.displaySuccessMessage()
        }
    }
}

// MARK: - DetailPresenterProtocol
extension DetailInfoPresenter: DetailInfoPresenterProtocol {
    func presentDetailInfo() {
        guard
            let url = model?.originalSrcUrl,
            let photographer = model?.photographer,
            let imageName = model?.photoTitle
        else {
            return
        }
        
        let model = DetailInfoViewModel(
            url: url,
            photographer: photographer,
            imageName: imageName
        )
        
        view?.displayDetailInfo(viewModel: model)
    }
    
    func savePhoto() {
        guard let model = model else { return }
        KingfisherManager.shared.retrieveImage(with: model.mediumSrcUrl, options: nil, progressBlock: nil) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let value):
                    let image: UIImage? = value.image
                    guard let image = image else { return }
                    UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.saveCompleted), nil)
                case .failure:
                    self.view?.displayError()
                }
            }
        }
    }
    
    func shareDetailInfo() {
        guard
            let url = model?.originalSrcUrl.absoluteString,
            let photographer = model?.photographer,
            let imageName = model?.photoTitle
        else {
            return
        }
        
        view?.displayActivityController(items: [url, photographer, imageName])
    }
}
