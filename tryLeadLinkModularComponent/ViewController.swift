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
            case 0: buildScenario_1() // 3-1-7
            case 1: buildScenario_2() // 3-6-3-1-2
        default: break
        }
        
        placeByTwoInRow(count: Int(sender.titleLabel!.text!) ?? 1)
        
    }
    
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
    // 3-1-7
    private func buildScenario_1() {
        
        let components_1 = createLabelAndTextView(count: 3)
        let a = threeElementInRowView(components: components_1)
        
        let components_2 = createLabelAndTextView(count: 1)
        let b = oneElementInRowView(components: components_2)
        
        let components_3 = createLabelAndTextView(count: 2)
        let c = threeElementInRowView(components: components_3)
        
        let components = [a,b,c]
        
        let frame = getRect(forComponents: components)
        let stackerView = ViewStacker.init(frame: frame , components: components)
        self.view.addSubview(stackerView)
        
    }
    
    
    
    private func buildScenario_2() {
        
    }
    
    
    
    
    private func oneElementInRowView(components: [UIView]) -> OneRowStacker {
        
        let rect = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: self.view.bounds.width, height: CGFloat.init(80)))
        return OneRowStacker.init(frame: rect, components: components)!
    }
    
    private func twoElementInRowView(components: [UIView]) -> OneRowStacker {
        
        let rect = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: self.view.bounds.width, height: CGFloat.init(80)))
        return OneRowStacker.init(frame: rect, components: components)!
    }
    
    private func threeElementInRowView(components: [UIView]) -> OneRowStacker {
        
        let rect = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: self.view.bounds.width, height: CGFloat.init(80)))
        return OneRowStacker.init(frame: rect, components: components)!
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // treba ti logika za 2 items/row i 1 item/row (odd ili even):
    
    private func placeByTwoInRow(count: Int) {
        // ako je odd -> treba ti da u poslednji stack ubacis 1 element
        // u suprotnom -> ubacujes 2 elementa
        
        let numberOfStacks = 1 + (count - 1) / 2
        
        var stacks = [UIView]()
        
        if numberOfStacks == 1 {
            switch count {
                case 1:
                    let s = getStackForSingleElement()
                    stacks.append(s)
                
            case 2:
                let s = getStackForSingleElement()
                stacks.append(s)
                
//                case 2:
//                    let s = getStackForTwoElements()
//                    stacks.append(s)
//                case 3:
//                    let s = getStackForThreeElements()
//                    stacks.append(s)
            default: break
            }
        }
        
       //self.view.addSubview(<#T##view: UIView##UIView#>)
        
    }
    
    private func getStackForSingleElement() -> OneRowStacker {
        
        let components = createLabelAndTextView(count: 1)
        let frame = getRect(forComponents: components)
        let row = OneRowStacker.init(frame: frame, components: components)
        return row!
    }
//
//    private func getStackForTwoElements() -> UIStackView {
//
//    }
//
//    private func getStackForThreeElements() -> UIStackView {
//
////        let components = createLabelAndTextView(count: 3)
////        let frame = getRect(forComponents: components)
////        let stackerView = ViewStacker.init(frame: frame, components: components)
////        return stackerView
//    }
 
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    private func createLabelAndTextView() -> UIView {
        
        let or = CGPoint.zero
        let size = CGSize.init(width: self.view.bounds.width, height: CGFloat.init(100))
        let rect = CGRect.init(origin: or, size: size)
        let v = LabelAndTextView.init(frame: rect, headlineText: "initial field", inputTxt: "just chacking...")
        return v
    }
    
    
    
    private func createLabelAndTextView(count: Int) -> [UIView] {
        var result = [UIView]()
        for _ in 0...count-1 {
            result.append(createLabelAndTextView())
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
    
    
    
}
