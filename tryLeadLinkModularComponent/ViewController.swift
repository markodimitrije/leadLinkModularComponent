//
//  ViewController.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 17/12/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction func btnTapped(_ sender: UIButton) {
        btnIsTapped(sender: sender)
    }
    
    override func viewDidLoad() {    super.viewDidLoad()
        
    }

    
    private func btnIsTapped(sender: UIButton) {
        
        switch sender.tag {
            case 0: placeOneElement()
            case 1: placeTwoElements()
            case 2: placeThreeElements()
        default: break
        }
        
    }
    //createLabelAndTextView(count
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
