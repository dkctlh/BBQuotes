//
//  StringExt.swift
//  BBQuotes
//
//  Created by Talha Dikici on 20.09.2024.
//

import Foundation

extension String {
    func removeSpaces() -> String {
        self.replacingOccurrences(of: " ", with: "")
    }
    
    func removeCaseAndSpace() -> String {
        self.removeSpaces().lowercased()
    }
}
