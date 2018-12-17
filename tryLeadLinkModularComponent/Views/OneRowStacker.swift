//
//  File.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 17/12/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class OneRowStacker: UIView {
    
    @IBOutlet weak var stackView: UIStackView!
    
    var components = [UIView]() {
        didSet {
            layoutComponents()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    // ovo je konstruktor koji radi posao..
    convenience init?(frame: CGRect,
                     components: [UIView]) {
        guard components.count <= 3 else {return nil}
        self.init(frame: frame)
        self.components = components
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "OneRowStacker", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(view)
        
    }
    
    // imas case sa 1,2,3 components.
    private func layoutComponents() {
        
        for view in components {
            
            stackView.addArrangedSubview(view)
        
        }
        
    }
    
}


/*
 
 for view in components {
 
 stackView.addArrangedSubview(view)
 
 }
 
 */
