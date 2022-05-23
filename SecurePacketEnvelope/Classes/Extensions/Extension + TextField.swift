//
//  Extension + TextField.swift
//  SecurePacketEnvelope
//
//  Created by Mehran Kamalifard on 5/23/22.
//

import Foundation
import UIKit

extension UITextField {
    func addRightView(txtField: UITextField, str: String) {
        let rightStr = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.size.height, height: self.frame.size.height))
        rightStr.text = str + " "
        txtField.rightView = rightStr
        txtField.rightViewMode = .always
    }
}
