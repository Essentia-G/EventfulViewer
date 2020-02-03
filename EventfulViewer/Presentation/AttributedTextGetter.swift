//
//  ShowEventDetails.swift
//  EventfulViewer
//
//  Created by Станислава on 15/11/2019.
//  Copyright © 2019 Stminchuk. All rights reserved.
//

import Foundation
import UIKit

class AttributedTextGetter {
    func attributedTextRecieve(title: String, description: String) -> (NSMutableAttributedString, NSMutableAttributedString) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.justified
        let attributedMessageText = NSMutableAttributedString(
            string: description,
            attributes: [
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13.0)
            ]
        )
        let titleFont = [NSAttributedString.Key.font: UIFont(name: "ArialHebrew-Bold", size: 18.0)!]
        let attributedTitleText = NSMutableAttributedString(string: title, attributes: titleFont)
        return(attributedTitleText, attributedMessageText)
    }
}
