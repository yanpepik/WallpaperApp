//
//  ModuleBuilder.swift
//  wallpapeApp
//
//  Created by Yan Pepik on 1.02.22.
//

import UIKit

final class AssemblyModuleBuilder: AssemblyBuilderProtocol {
    func createMainModule(router: RouterProtocol) -> UIViewController {
        let view = MainViewController()
        let networkService = NetworkService()
        let presenter = MainPresenter(view: view, networkService: networkService, router: router)
        view.presenter = presenter
        return view
    }
    
    func createDetailModule(router: RouterProtocol, model: Photo?) -> UIViewController {
        let view = DetailInfoViewController()
        let presenter = DetailInfoPresenter(view: view, router: router, model: model)
        view.presenter = presenter
        return view
    }
}
