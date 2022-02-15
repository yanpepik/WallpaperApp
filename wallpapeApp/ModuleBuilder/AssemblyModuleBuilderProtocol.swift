//
//  AssemblyModuleBuilderProtocol.swift
//  wallpapeApp
//
//  Created by Yan Pepik on 13.02.22.
//

import UIKit

protocol AssemblyBuilderProtocol {
    func createMainModule(router: RouterProtocol) -> UIViewController
    func createDetailModule(router: RouterProtocol, model: Photo?) -> UIViewController
}
