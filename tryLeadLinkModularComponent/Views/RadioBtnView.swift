//
//  RadioBtnsView.swift
//  LeadLink
//
//  Created by Marko Dimitrijevic on 21/12/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class RadioBtnView: UIView, RowsStackedEqually { // RowsStackedEqually hocu da su redovi uvek jednakih height..
    
    @IBOutlet weak var headlineLbl: UILabel!
    
    @IBOutlet weak var radioBtn: UIButton!
    
    @IBAction func radioBtnTapped(_ sender: UIButton) {
        delegate?.radioBtnTapped(index: sender.tag)
    }
    
    var counter: Int = 0
    
    // ovde moze da se zakaci listener // mnogo je bolje sa observables...
    
    weak var delegate: RadioBtnListener?
    
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
    
    private var radioBtnOnImg = UIImage.init(named: "radioBtn_ON")
    private var radioBtnOffImg = UIImage.init(named: "radioBtn_OFF")
    
    var isOn: Bool {
        get {
            return _isOn
        }
        set {
            _isOn = newValue
            let img = _isOn ? radioBtnOnImg : radioBtnOffImg
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
    
    func set(logic: Bool) {
        self.isOn = logic
    }
    
}

struct RadioBtnOption {
    var id = 0
    var isOn = false
    var text = ""
}

protocol RadioBtnListener: class {
    func radioBtnTapped(index: Int)
}
