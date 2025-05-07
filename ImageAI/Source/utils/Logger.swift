//
//  Logger.swift
//  ImageAI
//
//  Created by DoanhMac on 7/3/25.
//

import Foundation
import SwiftUI

struct Logger {
    static let tag = "TAG_DOANH_TV"

    private static func log(_ level: String, _ message: String, function: String = #function, file: String = #file, line: Int = #line) {
        let fileName = (file as NSString).lastPathComponent
        print("\(level) [\(tag)] \(fileName) -> \(function) [Line \(line)]: \(message)")
    }

    static func info(_ message: String, function: String = #function, file: String = #file, line: Int = #line) {
        log("ℹ️ℹ️ℹ️", message, function: function, file: file, line: line)
    }

    static func success(_ message: String, function: String = #function, file: String = #file, line: Int = #line) {
        log("✅✅✅", message, function: function, file: file, line: line)
    }

    static func warning(_ message: String, function: String = #function, file: String = #file, line: Int = #line) {
        log("⚠️⚠️⚠️", message, function: function, file: file, line: line)
    }

    static func error(_ message: String, function: String = #function, file: String = #file, line: Int = #line) {
        log("❌❌❌", message, function: function, file: file, line: line)
    }
}
