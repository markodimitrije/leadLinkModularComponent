//
//  RadioBtnsView.swift
//  LeadLink
//
//  Created by Marko Dimitrijevic on 21/12/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class RadioBtnView: UIView {
    
    @IBOutlet weak var headlineLbl: UILabel!
    
    @IBOutlet weak var radioBtn: UIButton!
    
    @IBAction func radioBtnTapped(_ sender: UIButton) {
    }
    
    var headlineText: String? {
        get {
            return headlineLbl.text
        }
        set {
            headlineLbl.text = newValue
        }
    }
    
    private var id = 0
    private var _isOn: Bool = false
    
    var isOn: Bool {
        get {
            return _isOn
        }
        set {
            _isOn = newValue
            let img = _isOn ? UIImage.init(named: "radioBtn_ON") : UIImage.init(named: "radioBtn_OFF")
            radioBtn.setBackgroundImage(img, for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    convenience init(frame: CGRect, option: RadioBtnOption) {
        self.init(frame: frame)
        update(option: option)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "RadioBtnView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(view)
        
    }
    
    func update(option: RadioBtnOption) {
        self.id = option.id
        self.headlineText = option.text
        self.isOn = option.isOn
    }
    
}

struct RadioBtnOption {
    var id = 0
    var isOn = false
    var text = ""
}

// var options: [RadioBtnOption]
