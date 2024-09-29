//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Jojo Smith on 9/19/24.
//

import Foundation
import UIKit

class AlertPresenter: AlertPresentorProtocol {
    weak var delegate: AlertPresntorDelegate?
    
    func presentAlert(_ result: AlertModel) {
        guard let viewController = delegate as? UIViewController else {return}
        
        let alert = UIAlertController(
            title: result.title,
            message: result.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            result.complection()
        }
        
        
        alert.addAction(action)
        
        viewController.present(alert, animated: true)
    }
}

