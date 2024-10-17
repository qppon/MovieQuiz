//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Jojo Smith on 10/17/24.
//

import UIKit

protocol MovieQuizViewControllerProtocol: AnyObject {
    
    func buttonsIsEnabled(_ isEnabled: Bool)
    
    func hideImageLayer()
    
    func show(quiz step: QuizStepViewModel)
    
    func highlightImageBorder(isCorrect: Bool)
    
    func showLoadingIndicator()
    
    func hideLoadingIndicator()
    
    func showNetworkError(message: String)
    
    func presentAlert(alert: UIAlertController)
}
