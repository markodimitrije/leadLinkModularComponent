//
//  InputCreators.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 23/03/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

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
    var textDrivers: [Driver<String>]
    var radioBtnsInput: Observable<Int>
    
    init(viewmodel: RadioWithInputViewModel, radioBtnViews: [RadioBtnView]) {
        
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
        
        self.viewmodel = viewmodel
        self.textDrivers = createTxtDrivers()
        self.radioBtnsInput = createRadioBtnsInput(btnViews: radioBtnViews)
        
    }
    
}


class CheckboxWithInputViewmodelCreator {
    
    var viewmodel: CheckboxWithInputViewModel
    var textDrivers: [Driver<String>]
    var checkboxBtnsInput: Observable<Int>
    
    init(viewmodel: CheckboxWithInputViewModel, checkboxBtnViews: [CheckboxView]) {
        
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
        
        self.viewmodel = viewmodel
        self.textDrivers = createTxtDrivers()
        self.checkboxBtnsInput = createChecboxBtnsInput(btnViews: checkboxBtnViews)
    }
    
}

class SwitchBtnsViewmodelInputCreator {
    
    var viewmodel: SwitchBtnsViewModel
    
    init(viewmodel: SwitchBtnsViewModel) {
        self.viewmodel = viewmodel
    }
    
    func createTxtDrivers() -> [Driver<String>] {
        let textDrivers = viewmodel.question.options.map { (text) -> Driver<String> in
            return Observable.from([text]).asDriver(onErrorJustReturn: "")
        }
        return textDrivers
    }
    
    // sa svakim tap na switch, posalji snapshot svih switcheva - uradio sam da emituje samo onaj koji je fire (single data)
    //func createSwitchBtnsInput(btnViews: [LabelBtnSwitchView] ) -> Observable<Bool> {
    func createSwitchBtnsInput(btnViews: [LabelBtnSwitchView] ) -> Observable<Int> {
        
        let allEvents = btnViews.map {($0.switcher.rx.switchTag.asObservable())}
        
        return Observable.merge(allEvents)
        
    }
    
}

//class TextFieldViewmodelInputCreator {
class LabelAndTextFieldFromModelInputCreator {
    
    var viewmodel: LabelWithTextFieldViewModel
    
    init(viewmodel: LabelWithTextFieldViewModel) {
        self.viewmodel = viewmodel
    }
    
    //func createTxtDriver() -> Driver<(String, String)> {
    func createTxtDriver() -> Observable<(String, String)> {

        let headline = viewmodel.question.headlineText
        let text = (viewmodel.answer?.content ?? [ ]).reduce("", {$0 + "\n" + $1}).trimmingCharacters(in: CharacterSet.init(charactersIn: "\n")) // remove enter on start end end
        return Observable.from([(headline, text)])//.asDriver(onErrorJustReturn: ("",""))

    }
    
}

class SelectOptionTextViewModelInputCreator { // duplicated....
    
    var viewmodel: SelectOptionTextFieldViewModel
    
    init(viewmodel: SelectOptionTextFieldViewModel) {
        self.viewmodel = viewmodel
    }
    
    //func createTxtDriver() -> Driver<(String, String)> {
    func createTxtDriver() -> Observable<(String, String)> {
        
        let headline = viewmodel.question.headlineText
        let text = (viewmodel.answer?.content ?? [ ]).reduce("", {$0 + "\n" + $1})
        return Observable.from([(headline, text)])//.asDriver(onErrorJustReturn: ("",""))
        
    }
    
}
