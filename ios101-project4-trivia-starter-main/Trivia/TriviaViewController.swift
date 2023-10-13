import UIKit

class TriviaViewController: UIViewController {
  
    @IBOutlet weak var currentQuestionNumberLabel: UILabel!
    @IBOutlet weak var questionContainerView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var answerButton0: UIButton!
    @IBOutlet weak var answerButton1: UIButton!
    @IBOutlet weak var answerButton2: UIButton!
    @IBOutlet weak var answerButton3: UIButton!
  
    private var questions = [TriviaQuestion]()
    private var currQuestionIndex = 0
    private var numCorrectQuestions = 0
    private let triviaService = TriviaQuestionService()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black  // Set the background color to black
        questionContainerView.layer.cornerRadius = 8.0
              
                triviaService.fetchQuestions { [weak self] questions, error in
                    DispatchQueue.main.async {
                        if let questions = questions {
                            self?.questions = questions
                            print("Questions fetched: \(questions.count)")
                            self?.updateQuestion(withQuestionIndex: 0)
                        } else {
                            if let error = error {
                                print("Error fetching questions: \(error.localizedDescription)")
                            }
                        }
                    }
                }
    }
    private func updateQuestion(withQuestionIndex questionIndex: Int) {
        
        guard questionIndex < questions.count else {
            print("Error: Trying to access question at index \(questionIndex) but only \(questions.count) questions are available.")
            return
        }
        
        currentQuestionNumberLabel.text = "Question: \(questionIndex + 1)/\(questions.count)"
        let question = questions[questionIndex]
        
        // Add the print statement here
        print("Updating UI for question: \(question.question)")
        
        questionLabel.text = question.question
        categoryLabel.text = question.category
        let answers = ([question.correctAnswer] + question.incorrectAnswers).shuffled()
        
        answerButton0.setTitle(answers.count > 0 ? answers[0] : "", for: .normal)
        answerButton0.isHidden = answers.count < 1
        
        answerButton1.setTitle(answers.count > 1 ? answers[1] : "", for: .normal)
        answerButton1.isHidden = answers.count < 2
        
        answerButton2.setTitle(answers.count > 2 ? answers[2] : "", for: .normal)
        answerButton2.isHidden = answers.count < 3
        
        answerButton3.setTitle(answers.count > 3 ? answers[3] : "", for: .normal)
        answerButton3.isHidden = answers.count < 4
    }

  
    private func updateToNextQuestion(answer: String) {
        if isCorrectAnswer(answer) {
            numCorrectQuestions += 1
        }
        currQuestionIndex += 1
        guard currQuestionIndex < questions.count else {
            showFinalScore()
            return
        }
        updateQuestion(withQuestionIndex: currQuestionIndex)
    }
  
    private func isCorrectAnswer(_ answer: String) -> Bool {
        return answer == questions[currQuestionIndex].correctAnswer
    }
  
    private func showFinalScore() {
        let alertController = UIAlertController(title: "Game over!",
                                                message: "Final score: \(numCorrectQuestions)/\(questions.count)",
                                                preferredStyle: .alert)
        let resetAction = UIAlertAction(title: "Restart", style: .default) { [unowned self] _ in
            currQuestionIndex = 0
            numCorrectQuestions = 0
            updateQuestion(withQuestionIndex: currQuestionIndex)
        }
        alertController.addAction(resetAction)
        present(alertController, animated: true, completion: nil)
    }
  
  
    @IBAction func didTapAnswerButton0(_ sender: UIButton) {
        updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
    }
  
    @IBAction func didTapAnswerButton1(_ sender: UIButton) {
        updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
    }
  
    @IBAction func didTapAnswerButton2(_ sender: UIButton) {
        updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
    }
  
    @IBAction func didTapAnswerButton3(_ sender: UIButton) {
        updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
    }
}
