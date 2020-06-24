//
//  SPLinkTextView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2020/6/23.
//  Copyright © 2020 Chunlang. All rights reserved.
//

import UIKit

class SPLinkTextView: UITextView {
     
    override var canBecomeFirstResponder: Bool{
        return false
    }
    override var selectedTextRange: UITextRange?{
        get {
            return nil
        }
        set {
            super.selectedTextRange = newValue
        }
    }
}
