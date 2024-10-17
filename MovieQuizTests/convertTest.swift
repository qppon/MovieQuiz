//
//  convertTest.swift
//  MovieQuiz
//
//  Created by Jojo Smith on 10/17/24.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func presentAlert(alert: UIAlertController) {
        
    }
    
    func buttonsIsEnabled(_ isEnabled: Bool) {
        
    }
    
    func hideImageLayer() {
        
    }
    
    func show(quiz step: QuizStepViewModel) {
    
    }
    
    
    func highlightImageBorder(isCorrect: Bool) {
    
    }
    
    func showLoadingIndicator() {
    
    }
    
    func hideLoadingIndicator() {
    
    }
    
    func showNetworkError(message: String) {
    
    }
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
