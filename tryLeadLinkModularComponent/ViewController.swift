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
            case 0: // radio
                
                let options = ["Paris", "London", "Maroco", "Madrid", "Moscow"]
                let q = Question.init(id: 3, type: "radioBtn", headlineText: "Headline", inputTxt: "whatever", options: options)
                let height = getOneRowHeightFor(componentType: "radioBtn")
                let fr = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: viewFactory.bounds.width, height: height))
                
                let answer = RadioAnswer.init(questionId: q.id, optionId: 3, content: ["Madrid"]) // ovo ces izvuci iz REALM-a! ili dataLayer-a
            
                let (stackerView, btnViews) = getRadioBtnsView(question: q, answer: nil, frame: fr)
                
                //let radioViewModel = RadioViewModel.init(question: q, answer: nil)  //all good..
                let radioViewModel = RadioViewModel.init(question: q, answer: answer)  //all good..
                
                //hookUp(view: stackerView, radioViewmodel: radioViewModel)
                hookUp(view: stackerView, btnViews: btnViews, radioViewmodel: radioViewModel)
            
            self.view.addSubview(stackerView)
            
            
        case 1: // checkbox
            
            let options = ["Soccer", "Basketball", "Swimming", "Tennis", "Waterpolo", "Car racing"]
            let q = Question.init(id: 2, type: "checkbox", headlineText: "Sports", inputTxt: "whatever", options: options)
            
            let height = getOneRowHeightFor(componentType: "checkboxBtn")
            let fr = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: viewFactory.bounds.width, height: height))
            
            // ovo ces izvuci iz REALM-a! ili dataLayer-a:
            let answer = CheckboxAnswer.init(questionId: q.id, optionId: [1,2,3,4], content: ["Basketball", "Swimming", "Tennis", "Waterpolo"])
            
            let (stackerView, btnViews) = getCheckboxBtnsView(question: q, answer: nil, frame: fr)
            
            let checkboxViewModel = CheckboxViewModel.init(question: q, answer: answer)
//            let checkboxViewModel = CheckboxViewModel.init(question: q, answer: nil) // test me...

            hookUp(view: stackerView, btnViews: btnViews, checkboxViewmodel: checkboxViewModel)

            self.view.addSubview(stackerView)
            
            
        case 2: // radio with input
            
//            let options = ["Paris", "London", "Maroco", "Madrid", "Moscow", "Rome"]
            let options = ["Paris", "London", "Maroco", "Madrid", "Moscow"]
            let q = Question.init(id: 22, type: "radioBtn", headlineText: "Headline", inputTxt: "whatever", options: options)
            let height = getOneRowHeightFor(componentType: "radioBtn")
            let fr = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: viewFactory.bounds.width, height: height))
            
            //let answer = RadioAnswer.init(questionId: q.id, optionId: 1, content: ["London"]) // ovo ces izvuci iz REALM-a! ili dataLayer-a
            let answer = RadioAnswer.init(questionId: q.id, optionId: 5, content: ["Palermo"]) // ovo ces izvuci iz REALM-a! ili dataLayer-a
            
            let (stackerView, btnViews) = getRadioBtnsWithInputView(question: q, answer: nil, frame: fr)
            
            let radioWithInputViewModel = RadioWithInputViewModel.init(question: q, answer: nil)  //all good..
            //let radioWithInputViewModel = RadioWithInputViewModel.init(question: q, answer: answer)  //all good..
            
            hookUp(view: stackerView, btnViews: btnViews, radioWithInputViewModel: radioWithInputViewModel)
            
            self.view.addSubview(stackerView)
            
            
            
            
            
        case 3: // checkbox with input
            
            let options = ["Soccer", "Basketball", "Swimming", "Tennis", "Waterpolo", "Car racing"]
            let q = Question.init(id: 2, type: "checkbox", headlineText: "Sports", inputTxt: "whatever", options: options)
            
            let height = getOneRowHeightFor(componentType: "checkboxBtn") // radilo i sa "checkbox" ??
            let fr = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: viewFactory.bounds.width, height: height))
            
            // ovo ces izvuci iz REALM-a! ili dataLayer-a:
            //let answer = CheckboxAnswer.init(questionId: q.id, optionId: [1,2,3,4], content: ["Basketball", "Swimming", "Tennis", "Waterpolo"])
            let answer = CheckboxAnswer.init(questionId: q.id, optionId: [1,2,3,4,6], content: ["Basketball", "Swimming", "Tennis", "Waterpolo", "Bocanje"])
            
            let (stackerView, btnViews) = getCheckboxBtnsWithInputView(question: q, answer: nil, frame: fr)
            
            let checkboxViewModel = CheckboxWithInputViewModel.init(question: q, answer: answer)
            //            let checkboxViewModel = CheckboxViewModel.init(question: q, answer: nil) // test me...
            
            hookUp(view: stackerView, btnViews: btnViews, checkboxWithInputViewModel: checkboxViewModel)
            
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
    
    private func hookUp(view: ViewStacker, btnViews: [RadioBtnView], radioViewmodel viewmodel: RadioViewModel) { // osim Question viewmodel treba da ima i Answer !!!
        
        let inputCreator = RadioViewmodelInputCreator(viewmodel: viewmodel)
        
        let buttons = btnViews.compactMap {$0.radioBtn}
        
        let textDrivers = inputCreator.createTxtDrivers()
        
        _ = textDrivers.enumerated().map { (offset, textDriver) in
                textDriver.drive(btnViews[offset].rx.optionTxt)
            }
        
        let values = inputCreator.createRadioBtnsInput(btnViews: btnViews)
        
        let input = RadioViewModel.Input.init(ids: values, answer: viewmodel.answer)
        
        let output = viewmodel.transform(input: input) // vratio sam identican input na output
        
        // ovo radi... ali nije PRAVI Reactive !
        output.ids.subscribe(onNext: { val in
            let active = buttons.first(where: { $0.tag == val })
            var inactive = buttons
            inactive.remove(at: val) // jer znam da su indexed redom..
            _ = inactive.map({
                btnViews[$0.tag].isOn = false
            })
            _ = active.map({
                btnViews[$0.tag].isOn = true
            })
        }).disposed(by: bag)
        
    }
    
    
    private func hookUp(view: ViewStacker, btnViews: [CheckboxView], checkboxViewmodel viewmodel: CheckboxViewModel) { // osim Question viewmodel treba da ima i Answer !!!
        
        let inputCreator = CheckboxViewmodelInputCreator(viewmodel: viewmodel)
        
        _ = inputCreator.createTxtDrivers().enumerated().map { (offset, textDriver) in
            textDriver.drive(btnViews[offset].rx.optionText)
        }

        let initial = viewmodel.answer?.optionId ?? [ ]
        
        let checkedArr = BehaviorRelay<[Int]>.init(value: initial) // mozda treba sa answer !!?
        
        let values = inputCreator.createCheckboxBtnsInput(btnViews: btnViews)
        
        values.subscribe(onNext: { tag in
            var arr = checkedArr.value
            if let i = checkedArr.value.firstIndex(of: tag) { // vec je u nizu...
                arr.remove(at: i)
                checkedArr.accept(arr)
            } else {
                arr.append(tag)
                checkedArr.accept(arr)
            }
        }).disposed(by: bag)
        
        let input = CheckboxViewModel.Input.init(ids: checkedArr.asObservable(), answer: viewmodel.answer)

        let output = viewmodel.transform(input: input) // vratio sam identican input na output

        // ovo radi... ali nije PRAVI Reactive !
        output.ids.subscribe(onNext: { array in
            
            print("subscribe.array = \(array)")
            
            let active = btnViews.filter { view -> Bool in
                array.contains(view.radioBtn.tag)
            }
            
            _ = btnViews.map({ btn in
                let checked = active.contains(btn)
                btn.isOn = checked
            })
            
        }).disposed(by: bag)
        
    }
    
    
    
    
    
    private func hookUp(view: ViewStacker, btnViews: [UIView], radioWithInputViewModel viewmodel: RadioWithInputViewModel) { // osim Question viewmodel treba da ima i Answer !!!
        
        let inputCreator = RadioWithInputViewmodelInputCreator.init(viewmodel: viewmodel)
        let textDrivers = inputCreator.createTxtDrivers()
        
        _ = textDrivers.enumerated().map { (offset, textDriver) in
            print(offset)
            guard let observer = (btnViews[offset] as? OptionTxtUpdatable)?.optionTxt else { return }

            textDriver
                .drive(observer)
                .disposed(by: bag)
            
            textDrivers.last?.asObservable()
                .subscribe(onNext: { (val) in
                    if val == "" {
                        (btnViews.last as? UITextField)?.placeholder = "type city"
                    }
                })
                .disposed(by: bag)
        }

        var allViews = btnViews
        guard let txtField = allViews.popLast() as? UITextField else {return}
        
        var radioBtnViews: [RadioBtnView] {
            return allViews as? [RadioBtnView] ?? [ ]
        }
        
        var buttons: [UIButton] {
            return radioBtnViews.compactMap { $0.radioBtn }
        }
        
        let values = inputCreator.createRadioBtnsInput(btnViews: radioBtnViews)
        
        let obOptionTxt = Observable.of(txtField.text ?? "")

        let input = RadioWithInputViewModel.Input.init(ids: values, optionTxt: obOptionTxt, answer: viewmodel.answer)

        let output = viewmodel.transform(input: input) // vratio sam identican input na output

        output.ids.subscribe(onNext: { val in
            let active = buttons.first(where: { $0.tag == val })
            var inactive = buttons
            inactive.remove(at: val) // jer znam da su indexed redom..
            _ = inactive.map {
                radioBtnViews[$0.tag].isOn = false
            }
            _ = active.map {
                radioBtnViews[$0.tag].isOn = true
            }
        }).disposed(by: bag)
        
    }
    
    
    // implement me !!!
    
    private func hookUp(view: ViewStacker, btnViews: [UIView], checkboxWithInputViewModel viewmodel: CheckboxWithInputViewModel) { // osim Question viewmodel treba da ima i Answer !!!
        
//        let inputCreator = CheckboxWithInputViewmodelInputCreator.init(viewmodel: viewmodel)
//        let textDrivers = inputCreator.createTxtDrivers()
//
//        _ = textDrivers.enumerated().map { (offset, textDriver) in
//            print(offset)
//            guard let observer = (btnViews[offset] as? OptionTxtUpdatable)?.optionTxt else { return }
//
//            textDriver
//                .drive(observer)
//                .disposed(by: bag)
//
//            textDrivers.last?.asObservable()
//                .subscribe(onNext: { (val) in
//                    if val == "" {
//                        (btnViews.last as? UITextField)?.placeholder = "type city"
//                    }
//                })
//                .disposed(by: bag)
//        }
//
        
        
        
        //        let values = inputCreator.createRadioBtnsInput(btnViews: btnViews)
        //
        //        let input = RadioViewModel.Input.init(ids: values, answer: viewmodel.answer)
        //
        //        let output = viewmodel.transform(input: input) // vratio sam identican input na output
        //
        //        // ovo radi... ali nije PRAVI Reactive !
        //        output.ids.subscribe(onNext: { val in
        //            let active = buttons.first(where: { $0.tag == val })
        //            var inactive = buttons
        //            inactive.remove(at: val) // jer znam da su indexed redom..
        //            _ = inactive.map({
        //                btnViews[$0.tag].isOn = false
        //            })
        //            _ = active.map({
        //                btnViews[$0.tag].isOn = true
        //            })
        //        }).disposed(by: bag)
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    private func getRadioBtnsView(question: Question, answer: Answer?, frame: CGRect) -> (ViewStacker, [RadioBtnView]) {
        
        let stackerView = viewFactory.getStackedRadioBtns(question: question, answer: answer, frame: frame)
        
        let btnViews = stackerView.components.flatMap { view -> [RadioBtnView] in
            return (view as? OneRowStacker)?.components as? [RadioBtnView] ?? [ ]
        }
        
        _ = btnViews.enumerated().map { $0.element.radioBtn.tag = $0.offset } // dodeli svakome unique TAG
        
        return (stackerView, btnViews)
        
    }
    
    private func getCheckboxBtnsView(question: Question, answer: Answer?, frame: CGRect) -> (ViewStacker, [CheckboxView]) {
        
        let stackerView = viewFactory.getStackedCheckboxBtns(question: question, answer: answer, frame: frame)
        
        let btnViews = stackerView.components.flatMap { view -> [CheckboxView] in
            return (view as? OneRowStacker)?.components as? [CheckboxView] ?? [ ]
        }
        
        _ = btnViews.enumerated().map { $0.element.radioBtn.tag = $0.offset } // dodeli svakome unique TAG
        
        return (stackerView, btnViews)
        
    }
    
    private func getRadioBtnsWithInputView(question: Question, answer: Answer?, frame: CGRect) -> (ViewStacker, [UIView]) {
        
        let stackerView = viewFactory.getStackedRadioBtnsWithInput(question: question, answer: answer, frame: frame)
        
        let elements = stackerView.components.flatMap { view -> [UIView] in
            return (view as? OneRowStacker)?.components ?? [ ]
        }
        
        _ = elements.enumerated().map {
            if $0.offset == elements.count - 1 {
                $0.element.tag = $0.offset
            } else if let btnView = $0.element as? RadioBtnView  {
                btnView.radioBtn.tag = $0.offset
            }
        } // dodeli svakome unique TAG
        
        return (stackerView, elements)
        
    }
    
    
    // uradi refactor, sve su iste samo je TYPE razlicit....
    
    
    
    private func getCheckboxBtnsWithInputView(question: Question, answer: Answer?, frame: CGRect) -> (ViewStacker, [UIView]) {
        
        let stackerView = viewFactory.getStackedCheckboxBtnsWithInput(question: question, answer: answer, frame: frame)
        
        let elements = stackerView.components.flatMap { view -> [UIView] in
            return (view as? OneRowStacker)?.components ?? [ ]
        }
        
        _ = elements.enumerated().map { $0.element.tag = $0.offset } // dodeli svakome unique TAG
        
        return (stackerView, elements)
        
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




class CheckboxViewmodelInputCreator {
    
    var viewmodel: CheckboxViewModel
    
    init(viewmodel: CheckboxViewModel) {
        self.viewmodel = viewmodel
    }
    
    func createTxtDrivers() -> [Driver<String>] {
        let textDrivers = viewmodel.question.options.map { (text) -> Driver<String> in
            return Observable.from([text]).asDriver(onErrorJustReturn: "")
        }
        return textDrivers
    }

    func createCheckboxBtnsInput(btnViews: [CheckboxView] ) -> Observable<Int> {
        
        let tags = btnViews
            .map { ($0.radioBtn.rx.tap, $0.radioBtn.tag) }
            .map { obs, tag in obs.map { tag } } // ovo zelim da je [Observable<(Int,Bool)>] da znam da li je checked ili nije
        
        return Observable.merge(tags)
        
    }
    
}

class RadioViewmodelInputCreator {
    
    var viewmodel: RadioViewModel
    
    init(viewmodel: RadioViewModel) {
        self.viewmodel = viewmodel
    }
    
    func createTxtDrivers() -> [Driver<String>] {
        let textDrivers = viewmodel.question.options.map { (text) -> Driver<String> in
            return Observable.from([text]).asDriver(onErrorJustReturn: "")
        }
        return textDrivers
    }
    
    func createRadioBtnsInput(btnViews: [RadioBtnView] ) -> Observable<Int> {
        
        let tags = btnViews
            .map { ($0.radioBtn.rx.tap, $0.radioBtn.tag) }
            .map { obs, tag in obs.map { tag } } // ovo zelim da je [Observable<(Int,Bool)>] da znam da li je checked ili nije
        
        return Observable.merge(tags)
        
    }
        
}

class RadioWithInputViewmodelInputCreator {
    
    var viewmodel: RadioWithInputViewModel
    
    init(viewmodel: RadioWithInputViewModel) {
        self.viewmodel = viewmodel
    }
    
    func createTxtDrivers() -> [Driver<String>] {
        
        var answerTxt: String? { return viewmodel.answer?.content.last }
        var options: [String] {return viewmodel.question.options}
        
        let anserIsOptionTxt = (answerTxt != nil) ? !options.contains(answerTxt!) : nil
        let optionTxt = (anserIsOptionTxt == nil) ? "" : (anserIsOptionTxt != nil && anserIsOptionTxt!) ? (answerTxt!) : ""
        
        let allOptions = options + [optionTxt]
        
        let textDrivers = allOptions.map { (text) -> Driver<String> in
            return Observable.from([text]).asDriver(onErrorJustReturn: "")
        }
        return textDrivers
    }
    
    func createRadioBtnsInput(btnViews: [RadioBtnView] ) -> Observable<Int> {
        
        let tags = btnViews
            .map { ($0.radioBtn.rx.tap, $0.radioBtn.tag) }
            .map { obs, tag in obs.map { tag } } // ovo zelim da je [Observable<(Int,Bool)>] da znam da li je checked ili nije
        
        return Observable.merge(tags)
        
    }
    
}


class CheckboxWithInputViewmodelInputCreator {
    
    var viewmodel: CheckboxWithInputViewModel
    
    init(viewmodel: CheckboxWithInputViewModel) {
        self.viewmodel = viewmodel
    }
    
    func createTxtDrivers() -> [Driver<String>] {
        
        var answerTxt: String? { return viewmodel.answer?.content.last }
        var options: [String] {return viewmodel.question.options}
        
        let anserIsOptionTxt = (answerTxt != nil) ? !options.contains(answerTxt!) : nil
        let optionTxt = (anserIsOptionTxt == nil) ? "" : (anserIsOptionTxt != nil && anserIsOptionTxt!) ? (answerTxt!) : ""
        
        let allOptions = options + [optionTxt]
        
        let textDrivers = allOptions.map { (text) -> Driver<String> in
            return Observable.from([text]).asDriver(onErrorJustReturn: "")
        }
        return textDrivers
    }
    
    func createChecboxBtnsInput(btnViews: [CheckboxView] ) -> Observable<Int> {
        
        let tags = btnViews
            .map { ($0.radioBtn.rx.tap, $0.radioBtn.tag) }
            .map { obs, tag in obs.map { tag } } // ovo zelim da je [Observable<(Int,Bool)>] da znam da li je checked ili nije
        
        return Observable.merge(tags)
        
    }
    
}

