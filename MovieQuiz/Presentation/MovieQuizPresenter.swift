//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Jojo Smith on 10/16/24.
//
import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate, AlertPresnterDelegate {
    
    private var questionsAmount = 10
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    private weak var viewController: MovieQuizViewControllerProtocol?
    private var questionFactory: QuestionFactoryProtocol?
    var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticServiceProtocol!
    
    private var currentQuestion: QuizQuestion?
    
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
        
        self.alertPresenter = AlertPresenter(viewController: viewController)
        self.statisticService = MovieQuiz.StatisticService()
    }
    
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    
    func showNextQuestionOrResults() {
        if self.isLastQuestion() {
            alertPresenter?.presentAlert(createAlertModel())
        } else {
            self.switchToNextQuestion()
            self.questionFactory?.requestNextQuestion()
        }
    }
    
    
    func createAlertModel() -> AlertModel {
        
        let message = makeMessage()
        
        let alertModel = AlertModel(
            title: "Этот раунд окончен!",
            message: "Ваш результат: \(self.correctAnswers)/10\n \(message)",
            buttonText: "Сыграть ещё раз") { [weak self] in
                guard let self = self else { return }
                self.resetQuestionIndex()
                self.correctAnswers = 0
                
                questionFactory?.requestNextQuestion()
            }
        return alertModel
    }
    
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = self.convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }

    
    func didFailToLoadData(with error: String) {
        let message = error
        viewController?.showNetworkError(message: message)
    }
    
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    
    func showAnswerResult(isCorrect: Bool) {
        viewController?.highlightImageBorder(isCorrect: isCorrect)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
            viewController?.buttonsIsEnabled(true)
            viewController?.hideImageLayer()
            self.showNextQuestionOrResults()
        }
    }
    
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        viewController?.buttonsIsEnabled(false)
        
        let givenAnswer = isYes
        
        self.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        
        if givenAnswer == currentQuestion.correctAnswer {
            correctAnswers += 1
        }
    }
    
    
    private func makeMessage() -> String {
        var message: String = ""
        if let statisticService {
            statisticService.store(correct: self.correctAnswers, total: 10)
            let gamesCount = "Количество сыгранных игр: \(statisticService.gamesCount)\n"
            let record = "Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))\n"
            let acuracy = "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
            
            message += gamesCount + record + acuracy
        }
        return message
    }
    
}
