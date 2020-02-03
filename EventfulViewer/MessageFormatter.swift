//
//  MessageFormatter.swift
//  EventfulViewer
//
//  Created by Станислава on 15/11/2019.
//  Copyright © 2019 Stminchuk. All rights reserved.
//

import Foundation

class MessageFormatter {
    func messageTextFormatter(line: String) -> String {
        if line.contains("<p>") || line.contains("&#39;") {
            var newLine = line.replacingOccurrences(of: "<p>", with: "")
            newLine = line.replacingOccurrences(of: "&#39;", with: "'")
            newLine = newLine.trimmingCharacters(in: .whitespacesAndNewlines)
            return newLine
        } else {
            let newLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
            return newLine
        }
    }
}
