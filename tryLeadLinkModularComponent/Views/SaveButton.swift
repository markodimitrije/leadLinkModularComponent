//
//  SaveButton.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 24/03/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class SaveButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setColorAndText()
    }
    
    convenience init() {
        self.init(frame: CGRect.init(origin: .zero, size: CGSize.init(width: 240, height: 44)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setColorAndText()
    }
    
    private func setColorAndText() {
        self.backgroundColor = UIColor.init(red: 108/255, green: 49/255, blue: 195/255, alpha: 1.0)
        self.setTitle("Save", for: .normal)
    }
}

