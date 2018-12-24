//
//  ViewController.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 17/12/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class ViewController: UIViewController, RadioBtnListener {
    
    
    
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
            case 0: buildScenario_7()
            case 1: placeTwoElements()
            case 2: placeThreeElements()
        default: break
        }
        
    }
    
    private func scenarioIsTapped(sender: UIButton) {
        
        switch sender.tag {
            case 0: buildScenario_1() // 3-1-2
            case 1: buildScenario_2() // 3-1-7
            case 2: buildScenario_3() // 3-6-3-1-2
        default: break
        }
        
    }
    
    private func radioScenarioIsTapped(sender: UIButton) {
        
        switch sender.tag {
        case 0: buildScenario_4() // 3-1-2
        case 1: buildScenario_5() // 3-1-7
        case 2: buildScenario_6() // 3-6-3-1-2
        default: break
        }
        
    }
    
    
    
    //buildScenario_4
    
    // ovo je samo za testiranje, inace ces uzimati info iz jSON-a koji si dobio od APIController (web service layer) :
    
    private func placeOneElement() {
        
        let components = createLabelAndTextView(count: 1)
        let frame = getRect(forComponents: components)
        let stackerView = ViewStacker.init(frame: frame, components: components)
        self.view.addSubview(stackerView)
    }
    
    private func placeTwoElements() {
        let components = createLabelAndTextView(count: 2)
        let frame = getRect(forComponents: components)
        let stackerView = ViewStacker.init(frame: frame, components: components)
        self.view.addSubview(stackerView)
    }
    
    private func placeThreeElements() {
        let components = createLabelAndTextView(count: 3)
        let frame = getRect(forComponents: components)
        let stackerView = ViewStacker.init(frame: frame , components: components)
        self.view.addSubview(stackerView)
    }
    
    // testiraj multiple in rows (2)
    // 3-1-2
    private func buildScenario_1() {
        
        let rowHeight = getOneRowHeightFor(componentType: "textField")
        
        let components_1 = createLabelAndTextView(count: 3)
        let a = stackElementsInOneRow(components: components_1, rowHeight: rowHeight)
        
        let components_2 = createLabelAndTextView(count: 1)
        let b = stackElementsInOneRow(components: components_2, rowHeight: rowHeight)
        
        let components_3 = createLabelAndTextView(count: 2)
        let c = stackElementsInOneRow(components: components_3, rowHeight: rowHeight)
        
        let components = [a,b,c]
        
        let frame = getRect(forComponents: components)
        let stackerView = ViewStacker.init(frame: frame , components: components)
        self.view.addSubview(stackerView)
        
    }
    
    
    
    
    // 3-1-7
    private func buildScenario_2() {
        
        let rowHeight = getOneRowHeightFor(componentType: "textField")
        
        let components_1 = createLabelAndTextView(count: 3)
        let a = stackElementsInOneRow(components: components_1, rowHeight: rowHeight)
        
        let components_2 = createLabelAndTextView(count: 1)
        let b = stackElementsInOneRow(components: components_2, rowHeight: rowHeight)
        
        let myStack = produceStackWithSameComponents(ofType: LabelAndTextView.self, count: 7, inOneRow: 2)!
        
        let components = [a, b, myStack]
        
        let frame = getRect(forComponents: components)
        let stackerView = ViewStacker.init(frame: frame , components: components)
        self.view.addSubview(stackerView)
        
    }
    
    
    
    private func buildScenario_3() {
        
        let rowHeight = getOneRowHeightFor(componentType: "textField")
        
        // 3
        
        let components_1 = createLabelAndTextView(count: 3)
        let a = stackElementsInOneRow(components: components_1, rowHeight: rowHeight)
    
        // 6
        
        //let myStack = produceStackWithSameComponents(ofType: LabelAndTextView.self, count: 7, inOneRow: 2)!
        //let myStack = produceStackWithSameComponents(ofType: LabelAndTextView.self, count: 6, inOneRow: 2)!
        let myStack = produceStackWithSameComponents(ofType: LabelAndTextView.self, count: 11, inOneRow: 3)!
        
        // 3
        
        let components_3 = createLabelAndTextView(count: 3)
        let d = stackElementsInOneRow(components: components_3, rowHeight: rowHeight)
        
        // 4
        
        let components_4 = createLabelAndTextView(count: 1)
        let e = stackElementsInOneRow(components: components_4, rowHeight: rowHeight)
        
        // 5
        
        let components_5 = createLabelAndTextView(count: 2)
        let f = stackElementsInOneRow(components: components_5, rowHeight: rowHeight)
        
        
        let components = [a,myStack, d, e, f]
        
        let frame = getRect(forComponents: components)
        let stackerView = ViewStacker.init(frame: frame , components: components)
        self.view.addSubview(stackerView)
        
    }
    
    
    // radio btns
    
    private func buildScenario_4() {
        
        let myStack = produceStackWithSameComponents(ofType: RadioBtnView.self, count: 7, inOneRow: 3)!
        
        let components = [myStack]
        
        let frame = getRect(forComponents: components)
        let stackerView = ViewStacker.init(frame: frame , components: components)
        self.view.addSubview(stackerView)
    }
    
    
    
    
    
    
    
    
    // 3-1-2 text fields + 7 btns
    private func buildScenario_5() {
        
        let rowHeight = getOneRowHeightFor(componentType: "textField")
        
        let components_1 = createLabelAndTextView(count: 3)
        let a = stackElementsInOneRow(components: components_1, rowHeight: rowHeight)
        
        let components_2 = createLabelAndTextView(count: 1)
        let b = stackElementsInOneRow(components: components_2, rowHeight: rowHeight)
        
        let components_3 = createLabelAndTextView(count: 2)
        let c = stackElementsInOneRow(components: components_3, rowHeight: rowHeight)
        
        let myBtnsStack = produceStackWithSameComponents(ofType: RadioBtnView.self, count: 6, inOneRow: 3)!
//        let myBtnsStack = produceStackWithSameComponents(ofType: RadioBtnView.self, count: 8, inOneRow: 3)!
        //let myBtnsStack = produceStackWithSameComponents(ofType: RadioBtnView.self, count: 7, inOneRow: 3)!
        
        let components = [a,b,c,myBtnsStack]
        
        let frame = getRect(forComponents: components)
        let stackerView = ViewStacker.init(frame: frame , components: components)
        self.view.addSubview(stackerView)
        
    }
    
    // 3-1-2 text fields + 4 btns with option + 7 btns RADIO BTNS
    
    private func buildScenario_6() {

        let rowHeight = getOneRowHeightFor(componentType: "textField")

        let components_1 = createLabelAndTextView(count: 3)
        let a = stackElementsInOneRow(components: components_1, rowHeight: rowHeight)

        let components_2 = createLabelAndTextView(count: 1)
        let b = stackElementsInOneRow(components: components_2, rowHeight: rowHeight)

        let components_3 = createLabelAndTextView(count: 2)
        let c = stackElementsInOneRow(components: components_3, rowHeight: rowHeight)

        //let myBtnsStack = produceStackWithSameComponents(ofType: RadioBtnView.self, count: 7, inOneRow: 3)!
        //let myBtnsStack = produceStackWithSameComponentsAndInputView(ofType: RadioBtnView.self, count: 6, inOneRow: 3)!
        let myBtnsStack = produceStackWithSameComponentsAndInputView(ofType: RadioBtnView.self, count: 9, inOneRow: 3)!
//        let myBtnsStack = produceStackWithSameComponentsAndInputView(ofType: RadioBtnView.self, count: 3, inOneRow: 3)!
        //        let myBtnsStack = produceStackWithSameComponentsAndInputView(ofType: RadioBtnView.self, count: 8, inOneRow: 3)!
        //let myBtnsStack = produceStackWithSameComponentsAndInputView(ofType: RadioBtnView.self, count: 7, inOneRow: 3)!
        
        

        let components = [a,b,c,myBtnsStack]

        let frame = getRect(forComponents: components)
        let stackerView = ViewStacker.init(frame: frame , components: components)
        self.view.addSubview(stackerView)

    }
    
    //
    
//    private func buildScenario_6() { // OVE IZGRADI SA CHECKVIEW
//
//        let rowHeight = getOneRowHeightFor(componentType: "textField")
//
//        let components_1 = createLabelAndTextView(count: 3)
//        let a = stackElementsInOneRow(components: components_1, rowHeight: rowHeight)
//
//        let components_2 = createLabelAndTextView(count: 1)
//        let b = stackElementsInOneRow(components: components_2, rowHeight: rowHeight)
//
//        let components_3 = createLabelAndTextView(count: 2)
//        let c = stackElementsInOneRow(components: components_3, rowHeight: rowHeight)
//
//        //let myBtnsStack = produceStackWithSameComponents(ofType: RadioBtnView.self, count: 7, inOneRow: 3)!
//        //let myBtnsStack = produceStackWithSameComponentsAndInputView(ofType: RadioBtnView.self, count: 6, inOneRow: 3)!
//        //        let myBtnsStack = produceStackWithSameComponentsAndInputView(ofType: RadioBtnView.self, count: 9, inOneRow: 3)!
//        //let myBtnsStack = produceStackWithSameComponentsAndInputView(ofType: RadioBtnView.self, count: 3, inOneRow: 3)!
//        //        let myBtnsStack = produceStackWithSameComponentsAndInputView(ofType: RadioBtnView.self, count: 8, inOneRow: 3)!
//        //let myBtnsStack = produceStackWithSameComponentsAndInputView(ofType: RadioBtnView.self, count: 7, inOneRow: 3)!
//
//        //let myBtnsStack = produceStackWithSameComponentsAndInputView(ofType: CheckboxView.self, count: 3, inOneRow: 3)!
//        let myBtnsStack = produceStackWithSameComponentsAndInputView(ofType: CheckboxView.self, count: 8, inOneRow: 3)!
//
//        let components = [a,b,c,myBtnsStack]
//
//        let frame = getRect(forComponents: components)
//        let stackerView = ViewStacker.init(frame: frame , components: components)
//        self.view.addSubview(stackerView)
//
//    }
    
    
    
    
    private func buildScenario_7() { // OVE IZGRADI SA CHECKVIEW
        
        let rowHeight = getOneRowHeightFor(componentType: "textField")
        
        let components_1 = createLabelAndTextView(count: 3)
        let a = stackElementsInOneRow(components: components_1, rowHeight: rowHeight)
        
        let components_2 = createLabelAndTextView(count: 1)
        let b = stackElementsInOneRow(components: components_2, rowHeight: rowHeight)
        
        let components_3 = createLabelAndTextView(count: 2)
        let c = stackElementsInOneRow(components: components_3, rowHeight: rowHeight)
        
        //let myBtnsStack = produceStackWithSameComponents(ofType: RadioBtnView.self, count: 7, inOneRow: 3)!
        //let myBtnsStack = produceStackWithSameComponentsAndInputView(ofType: RadioBtnView.self, count: 6, inOneRow: 3)!
        //        let myBtnsStack = produceStackWithSameComponentsAndInputView(ofType: RadioBtnView.self, count: 9, inOneRow: 3)!
        //let myBtnsStack = produceStackWithSameComponentsAndInputView(ofType: RadioBtnView.self, count: 3, inOneRow: 3)!
        //        let myBtnsStack = produceStackWithSameComponentsAndInputView(ofType: RadioBtnView.self, count: 8, inOneRow: 3)!
        //let myBtnsStack = produceStackWithSameComponentsAndInputView(ofType: RadioBtnView.self, count: 7, inOneRow: 3)!
        
        //let myBtnsStack = produceStackWithSameComponentsAndInputView(ofType: CheckboxView.self, count: 3, inOneRow: 3)!
        
        let switchHeight = getOneRowHeightFor(componentType: "switch")
        let rect = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: self.view.bounds.width, height: switchHeight))
        
        let info_1 = SwitchInfo.init(text: "I have read and accept", btnText: "Terms & Conditions", desc: "Ovde ide neki text sa linkovima...", switchIsOn: false)
        let info_2 = SwitchInfo.init(text: "I want to be contacted by a local representative", btnText: nil, desc: nil, switchIsOn: true)
        
        let components_4 = LabelBtnSwitchView.init(frame: rect, switchInfo: info_1)
        let components_5 = LabelBtnSwitchView.init(frame: rect, switchInfo: info_2)
        let components_6 = LabelBtnSwitchView.init(frame: rect, switchInfo: info_1)
        let components_7 = LabelBtnSwitchView.init(frame: rect, switchInfo: info_2)
        let components_8 = LabelBtnSwitchView.init(frame: rect, switchInfo: info_1)
        let components_9 = LabelBtnSwitchView.init(frame: rect, switchInfo: info_2)
        
        let d = stackElementsInOneRow(components: [components_4], rowHeight: switchHeight)
        let e = stackElementsInOneRow(components: [components_5], rowHeight: switchHeight)
        let f = stackElementsInOneRow(components: [components_6], rowHeight: switchHeight)
        let g = stackElementsInOneRow(components: [components_7], rowHeight: switchHeight)
        let h = stackElementsInOneRow(components: [components_8], rowHeight: switchHeight)
        let i = stackElementsInOneRow(components: [components_9], rowHeight: switchHeight)
        
        let components = [a,b,c,d,e,f,g,h,i]
        
        let frame = getRect(forComponents: components)
        let stackerView = ViewStacker.init(frame: frame , components: components)
        self.view.addSubview(stackerView)
        
    }
    
    
    
    
    
    
    
    
    // saznao si da je user tap na radio btn sa tag == index
    func radioBtnTapped(index: Int) {
        print("radioBtnTapped za index = \(index)")
        // ako je radioBtn emitovao, pogasi sve preostale, sacuvaj na sebi vrednost itd...
        
    }
    
    
    
    
    
    
    
    private func stackElementsInOneRow(components: [UIView], rowHeight: CGFloat) -> OneRowStacker {
        
        let rect = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: self.view.bounds.width, height: rowHeight))
        return OneRowStacker.init(frame: rect, components: components)!
    
    }
    
    private func createLabelAndTextView() -> UIView {
        
        let or = CGPoint.zero
        let size = CGSize.init(width: self.view.bounds.width, height: CGFloat.init(100))
        let rect = CGRect.init(origin: or, size: size)
        let v = LabelAndTextView.init(frame: rect, headlineText: "initial field", inputTxt: "just chacking...")
        return v
    }
    
    private func createBtnView(option: RadioBtnOption) -> UIView {
        
        let or = CGPoint.zero
        let size = CGSize.init(width: self.view.bounds.width, height: CGFloat.init(40))
        let rect = CGRect.init(origin: or, size: size)
        let v = RadioBtnView.init(frame: rect, option: option)
        return v
    }
    
    private func createLabelAndTextView(count: Int) -> [UIView] {
        var result = [UIView]()
        for _ in 0...count-1 {
            result.append(createLabelAndTextView())
        }
        return result
    }
    
    private func createBtnsView(count: Int) -> [UIView] {
        var result = [UIView]()
        for _ in 0...count-1 {
            let option = RadioBtnOption.init(id: 1, isOn: false, text: "Miami")
            result.append(createBtnView(option: option))
        }
        return result
    }
    
    // calculate... sigurno nije na VC-u ....
    
    private func getRect(forComponents components: [UIView]) -> CGRect {
        
        let height = getHeight(forComponents: components)
        
        return CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: self.view.bounds.width, height: height))
    }
    
    private func getHeight(forComponents components: [UIView]) -> CGFloat {
        var height = CGFloat.init(0)
        for c in components {
            height += c.bounds.height + CGFloat.init(8)
        }
        return height
    }
    
    
    
    
    
    
    
    
    
    private func getRect(forComponents components: [UIView], inOneRow: Int) -> CGRect {
        
        let height = getHeight(forComponents: components, inOneRow: inOneRow)
        
        return CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: self.view.bounds.width, height: height))
    }
    
    
    private func getHeight(forComponents components: [UIView], inOneRow: Int) -> CGFloat {
        var height = CGFloat.init(0)
        guard let first = components.first else {return 0.0}
        for _ in 1...getNumberOfRows(components: components, inOneRow: inOneRow) {
            height += first.bounds.height + CGFloat.init(8)
        }
        return height
    }
    
    
    
    
    
    // vrati nil ako hoce vise od 3 elementa u row -> ovo je verovatno pogresno u slucaju da imas radio btns !!
    // treba da dobacis i factory da bi ovaj mogao da napravi objekte tipa koji si mu prosledio:
    
    private func produceStackWithSameComponents(ofType type: UIView.Type, count: Int, inOneRow: Int) -> ViewStacker? {
       
        guard inOneRow <= 3 else {return nil}
        
        var numOfRows = count / inOneRow
        var isOdd = false
        let residue = count % inOneRow
        
        if residue != 0 {
            numOfRows += 1
            isOdd = true
        }
        
        var components = [OneRowStacker]()
        
        for index in 1...numOfRows {
            if index == numOfRows && isOdd {
                components.append(produceOneRowInVerticalStack(ofType: type, inOneRow: residue))
            } else {
                components.append(produceOneRowInVerticalStack(ofType: type, inOneRow: inOneRow))
            }
            
        }
        
        let frame = getRect(forComponents: components)
        let stack = ViewStacker.init(frame: frame, components: components)
        
        return stack
        
    }
    
    
    
    private func produceStackWithSameComponentsAndInputView(ofType type: UIView.Type, count: Int, inOneRow: Int) -> ViewStacker? {
        
        guard let stack = produceStackWithSameComponents(ofType: type, count: count, inOneRow: inOneRow) else {return nil}
        
        var heightRatio: CGFloat = 1
        
        let needsNewRow = (count % inOneRow == 0)
        
        if needsNewRow {
            heightRatio += CGFloat(1) / CGFloat((count / inOneRow))
        }
        
        guard let lastRow = stack.components.last as? OneRowStacker else {return nil}
        
        let input = LabelAndTextView.init(frame: lastRow.bounds, headlineText: "Option", inputTxt: "Type option")
        
        input.stackView.axis = .horizontal
        input.stackView.distribution = .fill
        
        if needsNewRow {
            stack.frame.offsetBy(dx: 0, dy: stack.bounds.height * heightRatio)
            stack.frame = CGRect.init(origin: stack.frame.origin,
                                      size: CGSize.init(width: stack.bounds.width,
                                                        height: stack.bounds.height * heightRatio))
            stack.addAsLast(view: input) // povecava se frame
        } else {
            lastRow.insertAsLast(view: input) // ne menja se frame
        }
        
        let allElements = stack.components.flatMap { oneRowStacker -> [UIView] in
            guard let oneRowStacker = oneRowStacker as? OneRowStacker else { return [ ] }
            return oneRowStacker.components
        }
        
        // hookUP tags and delegate (radio btn) - ovo treba da ti je u nekom viewmodel-u koji upravlja set-om radioBtn-a
        
        _ = allElements.enumerated().map { (offset, view) in
            (view as? RadioBtnView)?.radioBtn.tag = offset
            (view as? RadioBtnView)?.delegate = self
        }
        
        return stack
        
    }
    
    
    
    
    
    
    private func produceRadioBtnsWithInput(ofType type: UIView.Type, count: Int, inOneRow: Int) -> ViewStacker? {
        
        guard inOneRow <= 3 else {return nil}
        
        guard let stack = produceStackWithSameComponents(ofType: type, count: count, inOneRow: inOneRow) else {return nil}
        
        let component = stack.components.first!
        
        let inputView = LabelAndTextView.init(frame: component.bounds, headlineText: "Option", inputTxt: "Type option")
        
        stack.addAsLast(view: inputView)
        
        return stack
        
    }
    
    
    
    
    
    
    
    
    
    
    
    private func getNumberOfRows(components: [UIView], inOneRow: Int) -> Int {
        
        var numOfRows = components.count / inOneRow
        
        if components.count % inOneRow != 0 {
            numOfRows += 1
        }
        
        return numOfRows
    }
    
    
    private func produceOneRowInVerticalStack(ofType type: UIView.Type, inOneRow: Int) -> OneRowStacker {
        
        var compType = "textField"
        if type is RadioBtnView.Type {
            compType = "radioBtn"
        }
        if type is CheckboxView.Type {
            compType = "checkboxBtn"
        }
        
        let rowHeight = getOneRowHeightFor(componentType: compType)
        
        var componenets = [UIView]()
        for _ in 1...inOneRow {
            //let v = createLabelAndTextView()
            let v = type.init()
            componenets.append(v)
        }
        //let frame = getRect(forComponents: componenets, inOneRow: inOneRow)
        //let row = OneRowStacker.init(frame: frame, components: componenets)
        let row = stackElementsInOneRow(components: componenets, rowHeight: rowHeight)
        return row
        
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

//func getTypeFromClassType(type: UIView) -> String {
//    switch type {
//    case is LabelAndTextView: return "textField"
//    //case RadioBtnView.self: return "radioBtn"
//    default: return ""
//    }
//}
