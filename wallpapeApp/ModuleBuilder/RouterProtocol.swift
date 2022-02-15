//
//  RouterProtocol.swift
//  wallpapeApp
//
//  Created by Yan Pepik on 13.02.22.
//

import UIKit

protocol RouterMain: AnyObject {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyBuilderProtocol? { get set }
}

protocol RouterProtocol: RouterMain {
    func initialViewController()
    func showDetail(model: Photo?)
}
