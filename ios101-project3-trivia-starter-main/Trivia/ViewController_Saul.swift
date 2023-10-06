//
//  ViewController_Saul.swift
//  Trivia
//
//  Created by Saul Rios on 10/5/23.
//

import UIKit

class ViewController_Saul: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
        @IBOutlet weak var answerButton1: UIButton!
        @IBOutlet weak var answerButton2: UIButton!
        @IBOutlet weak var answerButton3: UIButton!
        @IBOutlet weak var answerButton4: UIButton!
        
 
        struct Question {
            let questionText: String
            let answers: [String]
            let correctAnswerIndex: Int
        }
        
        let questions: [Question] = [
            Question(questionText: "What is the capital of France?", answers: ["London", "Berlin", "Madrid", "Paris"], correctAnswerIndex: 3),
            Question(questionText: "What is the color of grass", answers: ["blue", "green", "pink", "white"], correctAnswerIndex: 2),
            Question(questionText: "Which planet is known as the Red Planet?", answers: ["Earth", "Mars", "Venus", "Jupiter"], correctAnswerIndex: 1),
            Question(questionText: "What is the largest mammal in the world?", answers: ["Giraffe", "Elephant", "Whale", "Horse"], correctAnswerIndex: 2)
        ]
        
        var currentQuestionIndex = 0
        
        override func viewDidLoad() {
            super.viewDidLoad()

            showQuestion(index: currentQuestionIndex)
        }
        
        func showQuestion(index: Int) {
            let question = questions[index]
            questionLabel.text = question.questionText
            answerButton1.setTitle(question.answers[0], for: .normal)
            answerButton2.setTitle(question.answers[1], for: .normal)
            answerButton3.setTitle(question.answers[2], for: .normal)
            answerButton4.setTitle(question.answers[3], for: .normal)
        }
        
        @IBAction func answerButtonTapped(_ sender: UIButton) {
            let question = questions[currentQuestionIndex]
            if sender.tag == question.correctAnswerIndex {
                
                print("Correct!")
            } else {
                
                print("Incorrect!")
            }
            
          
            currentQuestionIndex += 1
            if currentQuestionIndex < questions.count {
                showQuestion(index: currentQuestionIndex)
            } else {

                print("Quiz finished")
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
