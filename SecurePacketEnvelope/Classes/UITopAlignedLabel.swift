//
//  UITopAlignedLabel.swift
//  SecurePacketEnvelope
//
//  Created by Mehran Kamalifard on 5/28/22.
//

import UIKit

class UITopAlignedLabel: UILabel {
    override func drawText(in rect: CGRect) {
        guard let string = text else {
            super.drawText(in: rect)
            return
        }

        let size = (string as NSString).boundingRect(
            with: CGSize(width: rect.width, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin],
            attributes: [.font: font],
            context: nil).size

        var rect = rect
        rect.size.height = size.height.rounded()
        super.drawText(in: rect)
    }
}
