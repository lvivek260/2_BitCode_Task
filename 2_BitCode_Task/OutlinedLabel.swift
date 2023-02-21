//
//  UIOutlinedLabel.swift
//  2_BitCode_Task
//
//  Created by Admin on 19/02/23.
//

import UIKit

class OutlinedLabel: UILabel {

    var outlineWidth: CGFloat = 4
    var outlineColor: UIColor = .white

    override public func drawText(in rect: CGRect) {
        let shadowOffset = self.shadowOffset
        let textColor = self.textColor
        
        let c = UIGraphicsGetCurrentContext()
        c?.setLineWidth(outlineWidth)
        c?.setLineJoin(.round)
        c?.setTextDrawingMode(.stroke)
        self.textAlignment = .center
        self.textColor = outlineColor
        super.drawText(in:rect)
        
        c?.setTextDrawingMode(.fill)
        self.textColor = textColor
        self.shadowOffset = CGSize(width: 0, height: 0)
        super.drawText(in:rect)
        
        self.shadowOffset = shadowOffset
    }
}
