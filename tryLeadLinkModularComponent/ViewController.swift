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
            case 0: buildScenario_1() // 3-1-2
            case 1: buildScenario_2() // 3-1-7
            case 2: buildScenario_3() // 3-6-3-1-2
        default: break
        }
        
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
    // 3-1-2
    private func buildScenario_1() {
        
        let components_1 = createLabelAndTextView(count: 3)
        let a = stackElementsInOneRow(components: components_1)
        
        let components_2 = createLabelAndTextView(count: 1)
        let b = oneElementInRowView(components: components_2)
        
        let components_3 = createLabelAndTextView(count: 2)
        let c = stackElementsInOneRow(components: components_3)
        
        let components = [a,b,c]
        
        let frame = getRect(forComponents: components)
        let stackerView = ViewStacker.init(frame: frame , components: components)
        self.view.addSubview(stackerView)
        
    }
    
    
    
    
    // 3-1-7
    private func buildScenario_2() {
        
        let components_1 = createLabelAndTextView(count: 3)
        let a = stackElementsInOneRow(components: components_1)
        
        let components_2 = createLabelAndTextView(count: 1)
        let b = oneElementInRowView(components: components_2)
        
        let components_3_1 = createLabelAndTextView(count: 2)
        let c_1 = stackElementsInOneRow(components: components_3_1)
        
        let components_3_2 = createLabelAndTextView(count: 2)
        let c_2 = stackElementsInOneRow(components: components_3_2)
        
        let components_3_3 = createLabelAndTextView(count: 2)
        let c_3 = stackElementsInOneRow(components: components_3_3)
        
        let components_3_4 = createLabelAndTextView(count: 1)
        let c_4 = stackElementsInOneRow(components: components_3_4)
        
        let components = [a,b,c_1,c_2,c_3,c_4]
        
        let frame = getRect(forComponents: components)
        let stackerView = ViewStacker.init(frame: frame , components: components)
        self.view.addSubview(stackerView)
        
    }
    
    
    
    private func buildScenario_3() {
        
        // 3
        
        let components_1 = createLabelAndTextView(count: 3)
        let a = stackElementsInOneRow(components: components_1)
    
        // 6
        
        let components_2_1 = createLabelAndTextView(count: 2)
        let c_1 = stackElementsInOneRow(components: components_2_1)
        
        let components_2_2 = createLabelAndTextView(count: 2)
        let c_2 = stackElementsInOneRow(components: components_2_2)
        
        let components_2_3 = createLabelAndTextView(count: 2)
        let c_3 = stackElementsInOneRow(components: components_2_3)
        
        // 3
        
        let components_3 = createLabelAndTextView(count: 3)
        let d = stackElementsInOneRow(components: components_3)
        
        // 4
        
        let components_4 = createLabelAndTextView(count: 1)
        let e = stackElementsInOneRow(components: components_4)
        
        // 5
        
        let components_5 = createLabelAndTextView(count: 2)
        let f = stackElementsInOneRow(components: components_5)
        
        
        let components = [a,c_1,c_2,c_3,d, e,f]
        
        let frame = getRect(forComponents: components)
        let stackerView = ViewStacker.init(frame: frame , components: components)
        self.view.addSubview(stackerView)
        
    }
    
    
    
    
    
    private func oneElementInRowView(components: [UIView]) -> OneRowStacker {
        
        let rect = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: self.view.bounds.width, height: CGFloat.init(80)))
        return OneRowStacker.init(frame: rect, components: components)!
    }
    
    private func twoElementInRowView(components: [UIView]) -> OneRowStacker {
        
        let rect = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: self.view.bounds.width, height: CGFloat.init(80)))
        return OneRowStacker.init(frame: rect, components: components)!
    }
    
    private func stackElementsInOneRow(components: [UIView]) -> OneRowStacker {
        
        let rect = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: self.view.bounds.width, height: CGFloat.init(80)))
        return OneRowStacker.init(frame: rect, components: components)!
    }
    
    
    
    
    
    
    private func getStackForSingleElement() -> OneRowStacker {
        
        let components = createLabelAndTextView(count: 1)
        let frame = getRect(forComponents: components)
        let row = OneRowStacker.init(frame: frame, components: components)
        return row!
    }
    
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
