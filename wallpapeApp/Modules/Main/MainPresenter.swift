//
//  MainPresenter.swift
//  WallpaperApplication
//
//  Created by Yan Pepik on 28.01.22.
//

import Foundation
import UIKit

final class MainPresenter {
    // MARK: - Properties
    weak var view: MainViewProtocol?
    var router: RouterProtocol?
    let networkService: NetworkServiceProtocol!
    var curatedPhotoDTO: CuratedPhotoDTO?
    
    var isLoading: Bool = false
    
    // MARK: - Initialization
    init(view: MainViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
        self.networkService = networkService
    }
    
    // MARK: - Private Methods
    private func dataToString<T: CVarArg>(data: T) -> String {
        let value = String(format: "%.0f", data)
        return value
    }
    
    private func presentCuratedPhotos(curatedPhotoDTO: CuratedPhotoDTO) {
        let mapped = curatedPhotoDTO.photos.compactMap { (data) -> Photo? in
            guard let originalSrcUrl = URL(string: data.src.original) else { return nil }
            guard let mediumSrcUrl = URL(string: data.src.medium) else { return nil }
            let idString = dataToString(data: data.id)
            let photographer = data.photographer
            let photoTitle = data.alt
            let photo = Photo(
                originalSrcUrl: originalSrcUrl,
                mediumSrcUrl: mediumSrcUrl,
                id: idString,
                photographer: photographer,
                photoTitle: photoTitle
            )
            return photo
        }
        view?.displayPhotos(model: mapped)
    }
    
    private func setNextPage(from urlString: String?) {
        guard let urlString = urlString else { return }
        let components = URLComponents(string: urlString)
        guard let nextPageString = components?.queryItems?.first(where: { $0.name == "page" })?.value else { return }
        guard let nextPage = Int(nextPageString) else { return }
        view?.updateNextPage(page: nextPage)
    }
}

// MARK: - DetailPresenterProtocol
extension MainPresenter: MainPresenterProtocol {
    func tapOnThePhoto(model: Photo?) {
        router?.showDetail(model: model)
    }
    
    func fetchSearchData(page: Int, text: String?) {
        guard let keyword = text else { return }
        if !keyword.isEmpty {
            networkService.performRequest(endpoint: MainEndpoint.getPhotosByName(keyword: keyword, page: page)) {
                [weak self] (result: Result<CuratedPhotoDTO, Error>) in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        self.presentCuratedPhotos(curatedPhotoDTO: data)
                        self.setNextPage(from: data.next_page)
                    case .failure:
                        self.view?.displayError()
                    }
                }
            }
        }
    }
    
    func fetchData(page: Int) {
        if !isLoading {
            isLoading = true
            networkService.performRequest(endpoint: MainEndpoint.getCuratedPhotos(page: page)) { [weak self] (result: Result<CuratedPhotoDTO, Error>) in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        self.presentCuratedPhotos(curatedPhotoDTO: data)
                        self.setNextPage(from: data.next_page)
                    case .failure:
                        self.view?.displayError()
                    }
                    self.isLoading = false
                }
            }
        }
    }
}
