import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresntorDelegate {
    
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    
    private var correctAnswers = 0
    private var currentQuestionIndex: Int = 0
    private let questionsAmount: Int = 10
    
    
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresentorProtocol?
    private var currentQuestion: QuizQuestion?
    private var statisticService: StatisticServiceProtocol?
    
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        guard let currentQuestion else {
            return
        }
        yesButton.isEnabled = false
        noButton.isEnabled = false
        let givenAnswear = true
        showAnswerResult(isCorrect: givenAnswear == currentQuestion.correctAnswer)
        if givenAnswear == currentQuestion.correctAnswer {
            correctAnswers += 1
        }
    }
    
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        guard let currentQuestion else {
            return
        }
        noButton.isEnabled = false
        yesButton.isEnabled = false
        let givenAnswear = false
        showAnswerResult(isCorrect: givenAnswear == currentQuestion.correctAnswer)
        if givenAnswear == currentQuestion.correctAnswer {
            correctAnswers += 1
        }
    }
    
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor(named: "YP Green")?.cgColor : UIColor(named: "YP Red")?.cgColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
            yesButton.isEnabled = true
            noButton.isEnabled = true
            self.imageView.layer.borderWidth = 0
            self.showNextQuestionOrResults()
        }
    }
    
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            alertPresenter?.presentAlert(createAlertModel())
        } else {
            currentQuestionIndex += 1
            self.questionFactory?.requestNextQuestion()
        }
    }
    
    
    private func makeMessage() -> String {
        var message: String = ""
        if let statisticService {
            statisticService.store(correct: correctAnswers, total: 10)
            let gamesCount = "Количество сыгранных игр: \(statisticService.gamesCount)\n"
            let record = "Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))\n"
            let acuracy = "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
            
            message += gamesCount + record + acuracy
        }
        return message
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let questionFactory = QuestionFactory()
        questionFactory.setDelegate(self)
        self.questionFactory = questionFactory
        
        let alertPresnter = AlertPresenter()
        alertPresnter.delegate = self
        self.alertPresenter = alertPresnter
        
        statisticService = MovieQuiz.StatisticService()
        
        questionFactory.requestNextQuestion()
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    // MARK: - AlertPresenterDelegate
    
    func createAlertModel() -> AlertModel {
        
        let message = makeMessage()
        
        let alertModel = AlertModel(
            title: "Этот раунд окончен!",
            message: "Ваш результат: \(correctAnswers)/10\n \(message)",
            buttonText: "Сыграть ещё раз") { [weak self] in
                guard let self = self else { return }
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                
                questionFactory?.requestNextQuestion()
            }
        return alertModel
    }
}
