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
                
                let options = ["Paris", "London", "Maroco", "Madrid", "Moscow"]
                let q = Question.init(id: 3, type: "radioBtn", headlineText: "Headline", inputTxt: "whatever", options: options)
                let height = getOneRowHeightFor(componentType: "radioBtn")
                let fr = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: viewFactory.bounds.width, height: height))
            
                let stackerView = getRadioBtnsView(question: q, answer: nil, frame: fr)
                let radioViewModel = RadioViewModel.init(question: q)
                
                hookUp(view: stackerView, viewmodel: radioViewModel)
            
            self.view.addSubview(stackerView)
            
        default: break
        }
        
    }
    
    private func scenarioIsTapped(sender: UIButton) {
        
    }
    
    private func radioScenarioIsTapped(sender: UIButton) {
        
    }
    
    // hocu da Tap na embeded radio btn (nalazi se digged in u ViewStacker-u) pogoni ostale btn-e da menjaju sliku + da save actual za MODEL
    // s druge strane, ANSWER bi trebalo da pogoni sve btns, jer moze da se upari i preko "id" i preko "value"
    
    private func hookUp(view: ViewStacker, viewmodel: RadioViewModel) {
    
        // moze li moj radioViewModel kao Input param da dobije niz sa radioBtns - mislim da je to u redu.
        
        let btnViews = view.components.flatMap { view -> [RadioBtnView] in
            return (view as? OneRowStacker)?.components as? [RadioBtnView] ?? [ ]
        }
        
        // text drivers start
        
        let textDrivers = viewmodel.question.options.map { (text) -> Driver<String> in
            return Observable.from([text]).asDriver(onErrorJustReturn: "")
        }
        
        _ = textDrivers.enumerated().map { (offset, textDriver) in
                textDriver.drive(btnViews[offset].rx.optionText)
            }
        
        // text drivers end
        
        let buttons = btnViews.compactMap {$0.radioBtn} // ne moras da pises : btnViews.map {$0.radioBtn!}
        _ = buttons.enumerated().map { $0.element.tag = $0.offset } // dodeli svakome unique TAG
        
        let tags = buttons
            .map { ($0.rx.tap, $0.tag) }
            .map { obs, tag in obs.map { tag } }
        
        let values = Observable
                        .merge(tags)
        
        let input = RadioViewModel.Input.init(ids: values)
        
        let output = viewmodel.transform(input: input) // vratio sam identican input na output
        
        output.ids.subscribe(onNext: { val in
            print("emitovan je val = \(val)")
            let active = buttons.first(where: { $0.tag == val })
            var inactive = buttons
            inactive.remove(at: val) // jer znam da su indexed redom..
            _ = inactive.map({
                print("pogasi ove", $0.tag)
            })
            _ = active.map({
                print("ukljuci ovaj", $0.tag)
            })
        }).disposed(by: bag)
        
    }
    
    private func getRadioBtnsView(question: Question, answer: Answer?, frame: CGRect) -> ViewStacker {
        
        let stackerView = viewFactory.getStackedRadioBtns(question: question, answer: answer, frame: frame)
        
        return stackerView
        
    }
    
    
    // saznao si da je user tap na radio btn sa tag == index
    func radioBtnTapped(index: Int) {
        print("radioBtnTapped za index = \(index)")
        // ako je radioBtn emitovao, pogasi sve preostale, sacuvaj na sebi vrednost itd...
        
    }
    
    private var bag = DisposeBag()
    
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
