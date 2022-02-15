//
//  AlertService.swift
//  wallpapeApp
//
//  Created by Yan Pepik on 15.02.22.
//

import UIKit

final class AlertService {
    // MARK: - Nested Types
    enum AlertType {
        case success
        case error
    }
    
    // MARK: - Properties
    static let shared = AlertService()
    
    // MARK: - Initialization
    private init() {}
    
    // MARK: - Methods
    func showAlert(viewController: UIViewController, type: AlertType, action: (() -> Void)? = nil) {
        var title: String
        var message: String
        switch type {
        case .success:
            title = "Ok"
            message = "Saved."
        case .error:
            title = "Retry"
            message = "Something wrong. Please, try again later."
        }
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(
            title: title,
            style: UIAlertAction.Style.cancel
        ) { (result: UIAlertAction) -> Void in
            action?()
        }
        alertController.addAction(alertAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
}


