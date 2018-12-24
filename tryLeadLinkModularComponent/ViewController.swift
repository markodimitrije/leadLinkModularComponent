//
//  ViewController.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 17/12/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController, RadioBtnListener {
    
    lazy var viewFactory = ViewFactory.init(bounds: self.view.bounds)
    
    @IBAction func leftBtnsTapped(_ sender: UIButton) {
        leftScenariosTapped(sender: sender)
    }
    
    @IBAction func scenarioTapped(_ sender: UIButton) {
        scenarioIsTapped(sender: sender)
    }
    
    @IBAction func radioScenarioTapped(_ sender: UIButton) {
        radioScenarioIsTapped(sender: sender)
    }
    
    private func leftScenariosTapped(sender: UIButton) {
        
        switch sender.tag {
            case 0:
            
                let stackerView = getRadioBtnsView()
                let radioViewModel = RadioViewModel.init()
                
                hookUp(view: stackerView, viewmodel: radioViewModel)
            
            self.view.addSubview(stackerView)
            
        default: break
        }
        
    }
    
    private func scenarioIsTapped(sender: UIButton) {
        
    }
    
    private func radioScenarioIsTapped(sender: UIButton) {
        
    }
    
    
    
    private func hookUp(view: ViewStacker, viewmodel: RadioViewModel) {
        print("implement me")
    }
    
    
    private func getRadioBtnsView() -> ViewStacker {
        
        let options = ["Paris", "London", "Maroco", "Madrid", "Moscow"]
        let q = Question.init(id: 3, type: "radioBtn", headlineText: "Headline", inputTxt: "whatever", options: options)
        let height = getOneRowHeightFor(componentType: "radioBtn")
        let fr = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: viewFactory.bounds.width, height: height))
        
        return provideRadioBtnsView(question: q, answer: nil, frame: fr)
        
    }
    
    private func provideRadioBtnsView(question: Question, answer: Answer?, frame: CGRect) -> ViewStacker {
        
        let myBtnsStack = viewFactory.getStackedRadioBtns(question: question, answer: nil, frame: frame)
        
        //let components = [a,b,c,myBtnsStack]
        let components = [myBtnsStack]
        
        let frame = viewFactory.getRect(forComponents: components)
        let stackerView = ViewStacker.init(frame: frame , components: components)
        
        return stackerView
        
    }
    
    
    
    // saznao si da je user tap na radio btn sa tag == index
    func radioBtnTapped(index: Int) {
        print("radioBtnTapped za index = \(index)")
        // ako je radioBtn emitovao, pogasi sve preostale, sacuvaj na sebi vrednost itd...
        
    }
    
}

func getOneRowHeightFor(componentType type: String) -> CGFloat {
    switch type {
    case "textField":
        return CGFloat.init(80)
    case "radioBtn":
        return CGFloat.init(50)
    case "checkboxBtn":
        return CGFloat.init(50)
    case "switch":
        return CGFloat.init(60)
    default:
        return 0.0
    }
}


struct Question {
    var id: Int
    var type: String
    var headlineText = ""
    var inputTxt = ""
    var options = [String]()
}
