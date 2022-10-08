//
//  ResultViewController.swift
//  PersonalQuiz
//
//  Created by Святослав on 08.10.2022.
//

import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var answers: [Answer]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        searchMaxAnimal()
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true)
    }
    private func searchMaxAnimal() {
        var dictionaryOfAnimal: [Animal : Int] = [:]
        
        answers.forEach { answer in
            let animal = answer.animal
            switch animal {
            case .dog:
                dictionaryOfAnimal[animal] = (dictionaryOfAnimal[animal] ?? 0) + 1
            case .cat:
                dictionaryOfAnimal[animal] = (dictionaryOfAnimal[animal] ?? 0) + 1
            case .rabbit:
                dictionaryOfAnimal[animal] = (dictionaryOfAnimal[animal] ?? 0) + 1
            case .turtle:
                dictionaryOfAnimal[animal] = (dictionaryOfAnimal[animal] ?? 0) + 1
            }
        }
        
        guard let animal = dictionaryOfAnimal.sorted(by: { $0.value > $1.value }).first?.key else { return }
        resultLabel.text = "Вы - \(animal.rawValue)"
        descriptionLabel.text = animal.definition
    }
}

