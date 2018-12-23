//
//  ViewController.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 17/12/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    @IBAction func oneInRowTapped(_ sender: UIButton) {
        oneInRowIsTapped(sender: sender)
    }
    
    @IBAction func scenarioTapped(_ sender: UIButton) {
        scenarioIsTapped(sender: sender)
    }
    
    @IBAction func radioScenarioTapped(_ sender: UIButton) {
        radioScenarioIsTapped(sender: sender)
    }
    
    private func oneInRowIsTapped(sender: UIButton) {
        
        switch sender.tag {
            case 0: placeOneElement()
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
    
    
    
    
    
    
    
    
    // 3-1-2 text fields + 6 btns
    private func buildScenario_5() {
        
        let rowHeight = getOneRowHeightFor(componentType: "textField")
        
        let components_1 = createLabelAndTextView(count: 3)
        let a = stackElementsInOneRow(components: components_1, rowHeight: rowHeight)
        
        let components_2 = createLabelAndTextView(count: 1)
        let b = stackElementsInOneRow(components: components_2, rowHeight: rowHeight)
        
        let components_3 = createLabelAndTextView(count: 2)
        let c = stackElementsInOneRow(components: components_3, rowHeight: rowHeight)
        
        let myBtnsStack = produceStackWithSameComponents(ofType: RadioBtnView.self, count: 7, inOneRow: 3)!
        
        let components = [a,b,c,myBtnsStack]
        
        let frame = getRect(forComponents: components)
        let stackerView = ViewStacker.init(frame: frame , components: components)
        self.view.addSubview(stackerView)
        
        
        
        
        
        
        
        
        
        
    }
    
    
    
    private func buildScenario_6() {
        
        let rowHeight = getOneRowHeightFor(componentType: "radioBtn")
        
        // 3
        
        let components_1 = createBtnsView(count: 3)
        let a = stackElementsInOneRow(components: components_1, rowHeight: rowHeight)
        
        // 6
        
        let myStack = produceStackWithSameComponents(ofType: RadioBtnView.self, count: 11, inOneRow: 3)!
        
        // 3
        
        let components_3 = createBtnsView(count: 3)
        let d = stackElementsInOneRow(components: components_3, rowHeight: rowHeight)
        
        // 4
        
        let components_4 = createBtnsView(count: 1)
        let e = stackElementsInOneRow(components: components_4, rowHeight: rowHeight)
        
        // 5
        
        let components_5 = createBtnsView(count: 2)
        let f = stackElementsInOneRow(components: components_5, rowHeight: rowHeight)
        
        
        let components = [a,myStack, d, e, f]
        
        let frame = getRect(forComponents: components)
        let stackerView = ViewStacker.init(frame: frame , components: components)
        self.view.addSubview(stackerView)
        
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
                //components.append(produceOneRowInVerticalStack(ofType: LabelAndTextView.self, inOneRow: residue))
                components.append(produceOneRowInVerticalStack(ofType: type, inOneRow: residue))
            } else {
                //components.append(produceOneRowInVerticalStack(ofType: LabelAndTextView.self, inOneRow: inOneRow))
                components.append(produceOneRowInVerticalStack(ofType: type, inOneRow: inOneRow))
            }
            
        }
        
        let frame = getRect(forComponents: components)
        let stack = ViewStacker.init(frame: frame, components: components)
        
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
