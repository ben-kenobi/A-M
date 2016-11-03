//
//  InEditableTF.swift
//  am
//
//  Created by apple on 16/11/3.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class InEditableTF: UITextField,UITextFieldDelegate {

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate=self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}
