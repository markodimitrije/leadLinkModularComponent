//
//  ViewFactory.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 24/12/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewFactory {
    
    var bounds: CGRect
    
    init(bounds: CGRect) { // treba da je sa Questions...
        self.bounds = bounds
    }
    
    func getSingleLblWithTxtField(question: Question, answer: Answer?, frame: CGRect) -> LabelAndTextView {
        return LabelAndTextView.init(frame: frame, headlineText: question.headlineText, inputTxt: answer?.content.first ?? question.inputTxt)
    }
    
    func getStackedRadioBtns(question: Question, answer: Answer?, frame: CGRect) -> ViewStacker {
        
        //return produceStackWithSameComponents(ofType: RadioBtnView.self, count: question.options.count, inOneRow: 3)!
        return produceStackWithSameComponents(ofType: RadioBtnView.self, count: question.options.count, inOneRow: 1)!
        
    }
    
    func getStackedCheckboxBtns(question: Question, answer: Answer?, frame: CGRect) -> ViewStacker {
        
        //return produceStackWithSameComponents(ofType: CheckboxView.self, count: question.options.count, inOneRow: 3)!
        return produceStackWithSameComponents(ofType: CheckboxView.self, count: question.options.count, inOneRow: 1)!
        
    }
    
    func getStackedRadioBtnsWithInput(question: Question, answer: Answer?, frame: CGRect) -> ViewStacker {
        
        //let stacker = produceStackWithSameComponents(ofType: RadioBtnView.self, count: question.options.count, inOneRow: 3)!
        let stacker = produceStackWithSameComponents(ofType: RadioBtnView.self, count: question.options.count, inOneRow: 1)!
        
        guard let lastRow = stacker.components.last as? OneRowStacker,
            let lastElement = lastRow.components.last else {  return stacker }
        
        let txtBox = UITextField.init(frame: lastElement.bounds)
        txtBox.backgroundColor = .gray
        
        if lastRow.components.count == 3 { // max per row !
            guard let newRow = OneRowStacker.init(frame: lastRow.bounds, components: [txtBox]) else {return stacker}
            stacker.addAsLast(view: newRow)
        } else {
            lastRow.insertAsLast(view: txtBox) // dodaj ga na view
        }
        
        return stacker
        
    }
    
    func getStackedCheckboxBtnsWithInput(question: Question, answer: Answer?, frame: CGRect) -> ViewStacker {
        
        //let stacker = produceStackWithSameComponents(ofType: RadioBtnView.self, count: question.options.count, inOneRow: 3)!
        let stacker = produceStackWithSameComponents(ofType: CheckboxView.self, count: question.options.count, inOneRow: 1)!
        
        guard let lastRow = stacker.components.last as? OneRowStacker,
            let lastElement = lastRow.components.last else {  return stacker }
        
        let txtBox = UITextField.init(frame: lastElement.bounds)
        txtBox.backgroundColor = .gray
        
        if lastRow.components.count == 3 { // max per row !
            guard let newRow = OneRowStacker.init(frame: lastRow.bounds, components: [txtBox]) else {return stacker}
            stacker.addAsLast(view: newRow)
        } else {
            lastRow.insertAsLast(view: txtBox) // dodaj ga na view
        }
        
        return stacker
        
    }
    
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
        print("stack.bounds = \(stack.bounds)")
        return stack
        
    }
    
    
    
    
    
    // calculate... sigurno nije na VC-u ....
    
    func getRect(forComponents components: [UIView]) -> CGRect {
        
        let height = getHeight(forComponents: components)
        
        return CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: bounds.width, height: height))
    }
    
    
    
    
    private func getHeight(forComponents components: [UIView]) -> CGFloat {
        var height = CGFloat.init(0)
        for c in components {
            height += c.bounds.height + CGFloat.init(8)
        }
        return height
    }
    
    
    
    private func getHeight(forComponents components: [UIView], inOneRow: Int) -> CGFloat {
        var height = CGFloat.init(0)
        guard let first = components.first else {return 0.0}
        for _ in 1...getNumberOfRows(components: components, inOneRow: inOneRow) {
            height += first.bounds.height + CGFloat.init(8)
        }
        return height
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
            compType = "checkbox"
        }
        
        let rowHeight = getOneRowHeightFor(componentType: compType)
        
        var componenets = [UIView]()
        for _ in 1...inOneRow {
            let v = type.init()
            componenets.append(v)
        }
        let row = stackElementsInOneRow(components: componenets, rowHeight: rowHeight)
        return row
        
    }
    
    
    func getRect(forComponents components: [UIView], inOneRow: Int) -> CGRect {
        
        let height = getHeight(forComponents: components, inOneRow: inOneRow)
        
        return CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: bounds.width, height: height))
    }
    
    
    
    
    
    
    
    func stackElementsInOneRow(components: [UIView], rowHeight: CGFloat) -> OneRowStacker {
        
        let rect = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: bounds.width, height: rowHeight))
        return OneRowStacker.init(frame: rect, components: components)!
        
    }
    
    private func createLabelAndTextView() -> UIView {
        
        let or = CGPoint.zero
        let size = CGSize.init(width: bounds.width, height: CGFloat.init(100))
        let rect = CGRect.init(origin: or, size: size)
        let v = LabelAndTextView.init(frame: rect, headlineText: "initial field", inputTxt: "just chacking...")
        return v
    }
    
    private func createBtnView(option: RadioBtnOption) -> UIView {
        
        let or = CGPoint.zero
        let size = CGSize.init(width: bounds.width, height: CGFloat.init(40))
        let rect = CGRect.init(origin: or, size: size)
        let v = RadioBtnView.init(frame: rect, option: option)
        return v
    }
    
    func createLabelAndTextView(count: Int) -> [UIView] {
        var result = [UIView]()
        for _ in 0...count-1 {
            result.append(createLabelAndTextView())
        }
        return result
    }
    
}
