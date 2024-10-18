import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol{
    
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    
    private var presenter: MovieQuizPresenter!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MovieQuizPresenter(viewController: self)
        
    }
    
    // MARK: - Actions
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        presenter.yesButtonClicked()
    }
    
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        presenter.noButtonClicked()
    }
    
    // MARK: - Private functions
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    
    func showNetworkError(message: String) {
        activityIndicator.isHidden = true
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            
            self.presenter.restartGame()
        }
        
        presenter.alertPresenter?.presentAlert(model)
    }
    
    
    func buttonsIsEnabled(_ isEnabled: Bool) {
        self.yesButton.isEnabled = isEnabled
        self.noButton.isEnabled = isEnabled
        
    }
    
    
    func hideImageLayer() {
        self.imageView.layer.borderWidth = 0
    }
    
    
    func show(quiz step: QuizStepViewModel) {
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    
    func highlightImageBorder(isCorrect: Bool) {
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor(named: "YP Green")?.cgColor : UIColor(named: "YP Red")?.cgColor
        
        
    }
    
    func presentAlert(alert: UIAlertController) {
        self.present(alert, animated: true)
    }
}
