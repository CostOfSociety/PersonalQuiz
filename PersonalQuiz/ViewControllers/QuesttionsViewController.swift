//
//  ViewController.swift
//  PersonalQuiz
//
//  Created by Alexey Efimov on 03.10.2022.
//

import UIKit

class QuesttionsViewController: UIViewController {
    //MARK: - @IBOutlet
    @IBOutlet weak var questionProgressView: UIProgressView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var singelStackView: UIStackView!
    @IBOutlet var singleButtons: [UIButton]!
    @IBOutlet weak var multiplieStackView: UIStackView!
    @IBOutlet var multiplieLabels: [UILabel]!
    @IBOutlet var mutiplieSwitches: [UISwitch]!
    @IBOutlet weak var rangeStackView: UIStackView!
    @IBOutlet var rangedLabels: [UILabel]!
    @IBOutlet weak var rangeSlider: UISlider! {
        didSet {
            let answerCount = Float(currentAnswers.count - 1)
            rangeSlider.maximumValue = answerCount
            rangeSlider.value = answerCount / 2
        }
    }
    
    //MARK: - Private Properties
    private let questions = Question.getQuestions()
    private var answersChosen: [Answer] = []
    private var questionsIndex = 0
    private var currentAnswers: [Answer] {
        questions[questionsIndex].answers
    }
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let resultsVC = segue.destination as? ResultViewController else { return }
        resultsVC.answers = answersChosen
    }
    
    //MARK: - @IBAction
    @IBAction func singleAnswerButtonPressed(_ sender: UIButton) {
        guard let buttonIndex = singleButtons.firstIndex(of: sender) else { return }
        let currentAnswer = currentAnswers[buttonIndex]
        answersChosen.append(currentAnswer)
        nextQuestion()
    }
    
  
    @IBAction func multipleButtonPressed() {
        for (multipleSwitch, answer) in zip(mutiplieSwitches, currentAnswers) {
            if multipleSwitch.isOn {
                answersChosen.append(answer)
            }
        }
        nextQuestion()
    }
    
    
    @IBAction func rangedButtonPressed() {
        let index = lrintf(rangeSlider.value)
        answersChosen.append(currentAnswers[index])
        nextQuestion()
    }
}

//MARK: - Private Methods
extension QuesttionsViewController {
    private func updateUI() {
        let stackViews = [singelStackView, multiplieStackView, rangeStackView]
        for stackView in stackViews {
            stackView?.isHidden = true
        }
        
        let currentQuestion = questions[questionsIndex]
        questionLabel.text = currentQuestion.title
        
        let totalProgress = Float(questionsIndex) / Float(questions.count)
        
        questionProgressView.setProgress(totalProgress, animated: true)
        
        title = "???????????? ??? \(questionsIndex + 1) ???? \(questions.count)"
        
        showCurrentAnswers(for: currentQuestion.responseType)
    }
    
    private func showCurrentAnswers(for type: ResponseType) {
        switch type {
        case .single:
            showSingleStackView(with: currentAnswers)
        case .multiple:
            showMultupleStackView(with: currentAnswers)
        case .ranged:
            showRangedStackView(with: currentAnswers)
        }
    }
    private func showSingleStackView(with answers: [Answer] ) {
        singelStackView.isHidden.toggle()
        
        for (button, answer) in zip(singleButtons,answers) {
            button.setTitle(answer.title, for: .normal)
        }
    }
    
    private func showMultupleStackView(with answers: [Answer]) {
        multiplieStackView.isHidden.toggle()
        for (label, answer) in zip(multiplieLabels, answers) {
            label.text = answer.title
        }
    }
    private func showRangedStackView(with answers: [Answer]) {
        rangeStackView.isHidden.toggle()
        rangedLabels.first?.text = answers.first?.title
        rangedLabels.last?.text =  answers.last?.title
    }
    
    private func nextQuestion() {
        questionsIndex += 1
        
        if questionsIndex < questions.count {
            updateUI()
            return
        }
        
        performSegue(withIdentifier: "showResult", sender: nil)
    }
}
