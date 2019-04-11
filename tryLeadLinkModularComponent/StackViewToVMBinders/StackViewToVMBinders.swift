//
//  StackViewToVMBinders.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 26/03/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class StackViewToRadioBtnsViewModelBinder: StackViewToViewModelBinder {
    
    func hookUp(view: ViewStacker, btnViews: [RadioBtnView], viewmodel: RadioViewModel, bag: DisposeBag) {
        
        let inputCreator = RadioViewmodelInputCreator(viewmodel: viewmodel)
        
        let buttons = btnViews.compactMap {$0.radioBtn}
        
        let textDrivers = inputCreator.createTxtDrivers()
        
        _ = textDrivers.enumerated().map { (offset, textDriver) in
            textDriver.drive(btnViews[offset].rx.optionTxt)
        }
        
        let values = inputCreator.createRadioBtnsInput(btnViews: btnViews)
        
        let input = RadioViewModel.Input.init(ids: values, answer: viewmodel.answer)
        
        let output = viewmodel.transform(input: input) // vratio sam identican input na output
        
        output.ids
            .bind(to: viewmodel.rx.optionSelected)
            .disposed(by: bag)
        
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
}

class StackViewToRadioBtnsWithInputViewModelBinder: StackViewToViewModelBinder {
    
    func hookUp(view: ViewStacker, btnViews: [UIView], viewmodel: RadioWithInputViewModel, bag: DisposeBag) {
        
        var allViews = btnViews
        guard let txtField = allViews.popLast() as? UITextField else {return}
        var radioBtnViews: [RadioBtnView] { return allViews as? [RadioBtnView] ?? [ ] }
        
        var buttons: [UIButton] { return radioBtnViews.compactMap { $0.radioBtn } }
        
        let inputCreator = RadioWithInputViewmodelInputCreator.init(viewmodel: viewmodel, radioBtnViews: radioBtnViews)
        
        let textDrivers = inputCreator.textDrivers
        let values = inputCreator.radioBtnsInput
        
        _ = textDrivers.enumerated().map { (offset, textDriver) in
            print(offset)
            guard let observer = (btnViews[offset] as? OptionTxtUpdatable)?.optionTxt else {
                print("nisam prosao za offset = \(offset)")
                return
            }
            
            textDriver
                .drive(observer)
                .disposed(by: bag)
            
            textDrivers.last?.asObservable()
                .subscribe(onNext: { (val) in
                    if val == "" {
                        (btnViews.last as? UITextField)?.placeholder = "Type your text here"
                    }
                })
                .disposed(by: bag)
        }
        
        //let obOptionTxt = Observable.from([txtField.text!]) GRESKA !
        let obOptionTxt = txtField.rx.text.asObservable() // OK
        
        let input = RadioWithInputViewModel.Input.init(ids: values, optionTxt: obOptionTxt, answer: viewmodel.answer)
        
        let output = viewmodel.transform(input: input) // vratio sam identican input na output
        
        // bind to viewmodel
        output.ids
            .bind(to: viewmodel.rx.optionSelected)
            .disposed(by: bag)
        
        output.optionTxt.map {$0 ?? ""}
            .bind(to: viewmodel.rx.txtChanged)
            .disposed(by: bag)
        
        // drive UI
        
        output.ids.subscribe(onNext: { val in
            let active = buttons.first(where: { $0.tag == val })
            var inactive = buttons
            inactive.remove(at: val) // jer znam da su indexed redom..
            _ = inactive.map {
                radioBtnViews[$0.tag].isOn = false
            }
            _ = active.map {
                if $0.tag < radioBtnViews.count-1 {
                    txtField.text = ""
                    txtField.resignFirstResponder()
                    
                } else {
                    txtField.becomeFirstResponder()
                }
                radioBtnViews[$0.tag].isOn = true
            }
        }).disposed(by: bag)
        
        output.optionTxt.subscribe(onNext: { val in
            if val != "" {
                if let answer = viewmodel.answer, answer.optionId == radioBtnViews.last?.radioBtn.tag {
                    _ = radioBtnViews.map {$0.isOn = false}
                }
                _ = radioBtnViews.map {$0.isOn = false}
                radioBtnViews.last?.isOn = true // we want other option to be selected
            }
        }).disposed(by: bag)
    }
    
}

class StackViewToCheckboxBtnsViewModelBinder: StackViewToViewModelBinder {
    
    func hookUp(view: ViewStacker, btnViews: [CheckboxView], viewmodel: CheckboxViewModel, bag: DisposeBag) {
        
        let inputCreator = CheckboxViewmodelInputCreator(viewmodel: viewmodel)
        
        _ = inputCreator.createTxtDrivers().enumerated().map { (offset, textDriver) in
            textDriver.drive(btnViews[offset].rx.optionTxt)
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
        output.ids
            .debug()
            .subscribe(onNext: { array in
            
            print("checkbox.subscribe.array = \(array)")
            
            let active = btnViews.filter { view -> Bool in
                array.contains(view.radioBtn.tag)
            }
            
            _ = btnViews.map({ btn in
                let checked = active.contains(btn)
                btn.isOn = checked
            })
            
        }).disposed(by: bag)
        
        output.ids
            .bind(to: viewmodel.rx.optionSelected)
            .disposed(by: bag)
        
    }
    
}

class StackViewToCheckboxBtnsWithInputViewModelBinder: StackViewToViewModelBinder {
    
    func hookUp(view: ViewStacker, btnViews: [UIView], viewmodel: CheckboxWithInputViewModel, bag: DisposeBag) {
        
        var allViews = btnViews
        guard let txtField = allViews.popLast() as? UITextField else {return}
        var radioBtnViews: [CheckboxView] { return allViews as? [CheckboxView] ?? [ ] }
        
        var buttons: [UIButton] { return radioBtnViews.compactMap { $0.radioBtn } }
        
        let inputCreator = CheckboxWithInputViewmodelCreator.init(viewmodel: viewmodel, checkboxBtnViews: radioBtnViews)
        
        let textDrivers = inputCreator.textDrivers
        let values = inputCreator.checkboxBtnsInput
        
        _ = textDrivers.enumerated().map { (offset, textDriver) in
            print(offset)
            guard let observer = (btnViews[offset] as? OptionTxtUpdatable)?.optionTxt else {
                print("CheckboxWithInputViewModel/nisam prosao za offset = \(offset)")
                return
            }
            
            textDriver
                .drive(observer)
                .disposed(by: bag)
            
            textDrivers.last?.asObservable()
                .subscribe(onNext: { (val) in
                    if val == "" {
                        (btnViews.last as? UITextField)?.placeholder = "Type your text here"
                    }
                })
                .disposed(by: bag)
        }
        
        let obOptionTxt = txtField.rx.text.asObservable() // OK
        
        let input = CheckboxWithInputViewModel.Input.init(ids: values, optionTxt: obOptionTxt, answer: viewmodel.answer)
        
        let output = viewmodel.transform(input: input) // vratio sam identican input na output
        
        // bind to viewmodel
        output.ids
            .bind(to: viewmodel.rx.optionSelected)
            .disposed(by: bag)
        
        output.optionTxt.map {$0 ?? ""}
            .bind(to: viewmodel.rx.txtChanged)
            .disposed(by: bag)
        
        // drive UI
        
        output.ids.subscribe(onNext: { val in
            let active = buttons.first(where: { $0.tag == val })
            var inactive = buttons
            inactive.remove(at: val) // jer znam da su indexed redom..
            _ = inactive.map {
                radioBtnViews[$0.tag].isOn = false
            }
            _ = active.map {
                if $0.tag < radioBtnViews.count-1 {
                    txtField.text = ""
                    txtField.resignFirstResponder()
                    
                } else {
                    txtField.becomeFirstResponder()
                }
                radioBtnViews[$0.tag].isOn = true
            }
        }).disposed(by: bag)
        
        output.optionTxt.subscribe(onNext: { val in
            if val != "" {
                if let answer = viewmodel.answer, answer.optionId.last == radioBtnViews.last?.radioBtn.tag {
                    _ = radioBtnViews.map {$0.isOn = false}
                }
                _ = radioBtnViews.map {$0.isOn = false}
                radioBtnViews.last?.isOn = true // we want other option to be selected
            }
        }).disposed(by: bag)
        
    }
    
}

class StackViewToSwitchBtnsViewModelBinder: StackViewToViewModelBinder {
    func hookUp(view: ViewStacker, btnViews: [LabelBtnSwitchView], viewmodel: SwitchBtnsViewModel, bag: DisposeBag) {
        
        let inputCreator = SwitchBtnsViewmodelInputCreator(viewmodel: viewmodel)
        
        _ = inputCreator.createTxtDrivers().enumerated().map { (offset, textDriver) in
            textDriver.drive(btnViews[offset].rx.optionTxt)
        }
        
        let initial = viewmodel.answer?.optionId ?? [ ]
        
        let checkedArr = BehaviorRelay<[Int]>.init(value: initial) // mozda treba sa answer !!?
        
        let values = inputCreator.createSwitchBtnsInput(btnViews: btnViews)
        
        values
            .skip(btnViews.count) // what a hack....
            .subscribe(onNext: { tag in
            var arr = checkedArr.value
            if let i = checkedArr.value.firstIndex(of: tag) { // vec je u nizu...
                arr.remove(at: i)
                checkedArr.accept(arr)
            } else {
                arr.append(tag)
                checkedArr.accept(arr)
            }
        }).disposed(by: bag)
        
        let input = SwitchBtnsViewModel.Input.init(ids: checkedArr.asObservable(), answer: viewmodel.answer)
        
        let output = viewmodel.transform(input: input) // vratio sam identican input na output
        
        output.ids
            .bind(to: viewmodel.rx.optionSelected)
            .disposed(by: bag)
        
        // ovo radi... ali nije PRAVI Reactive !
        output.ids.subscribe(onNext: { array in
            
            print("StackViewToSwitchBtnsViewModelBinder.subscribe.array = \(array)")
            
            let active = btnViews.filter { view -> Bool in
                array.contains(view.switcher.tag)
            }
            
            _ = btnViews.map({ btn in
                let checked = active.contains(btn)
                btn.switcher.isOn = checked
            })
            
        }).disposed(by: bag)
        
    }
}

// regular textField...
class TextFieldViewModelBinder {
    
    func hookUp(view: ViewStacker, labelAndTextView: LabelAndTextField, viewmodel: LabelWithTextFieldViewModel, bag: DisposeBag) {
        
        let inputCreator = LabelAndTextFieldFromModelInputCreator(viewmodel: viewmodel)
        let driver = inputCreator.createTxtDriver()
        
        driver
            .bind(to: labelAndTextView.rx.titles)
            .disposed(by: bag)

        labelAndTextView.textField.rx.text.asObservable()
            .bind(to: viewmodel.rx.answer)
            .disposed(by: bag)
        
    }
    
}

// your inputs are "options" and txtField content: [String]
class TextFieldWithOptionsViewModelBinder { // rename -LabelWithTextFieldViewModel- u -LabelWithTextViewModel-
    
    
    func hookUp(view: ViewStacker, labelAndTextView: LabelAndTextView, viewmodel: SelectOptionTextFieldViewModel, bag: DisposeBag) {
        
        let inputCreator = SelectOptionTextViewModelInputCreator(viewmodel: viewmodel)
        let driver = inputCreator.createTxtDriver()
        
        driver
            .bind(to: labelAndTextView.rx.texts)
            .disposed(by: bag)
    }
}
