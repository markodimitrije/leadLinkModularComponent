//
//  Extensions.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 10/04/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

// MARK:- Always extensions // ok to be in Pods

extension UIView {
    static func closestParentObject<T: UIView, U: UIView>(for object: T, ofType type: U.Type) -> U? {
        guard let parent = object.superview else {
            return nil
        }
        if let parent = parent as? U {
            return parent
        } else {
            return closestParentObject(for: parent, ofType: type)
        }
    }
}

extension UIView {
    func removeAllSubviews() {
        _ = subviews.map {$0.removeFromSuperview()}
    }
}

class OptionsTextView: UITextView {
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: nil)
        formatLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func formatLayout() {
        self.contentInset = UIEdgeInsets.init(top: 20, left: 0, bottom: 0, right: 0)
    }
}
