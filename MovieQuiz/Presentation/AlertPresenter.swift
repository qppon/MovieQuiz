//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Jojo Smith on 9/19/24.
//

import Foundation
import UIKit

class AlertPresenter: AlertPresenterProtocol {
    private var viewController: MovieQuizViewControllerProtocol?
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
    }
    
    func presentAlert(_ result: AlertModel) { 
        guard let viewController = self.viewController else {return}
        
        let alert = UIAlertController(
            title: result.title,
            message: result.message,
            preferredStyle: .alert)
        
        alert.view.accessibilityIdentifier = "Game results"
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            result.complection()
        }
        
        
        alert.addAction(action)
        
        viewController.presentAlert(alert: alert)

    }
}

