//
//  SourceEditorCommand.swift
//  Embedder
//
//  Created by Eric Kunz on 7/9/19.
//  Copyright © 2019 Eric Kunz. All rights reserved.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
	
	func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
		guard let selections = invocation.buffer.selections as? [XCSourceTextRange],
			let start = selections.first?.start,
			let endLine = selections.last?.end.line,
			let firstLineContents = invocation.buffer.lines[start.line] as? String else {
				completionHandler(nil)
				return
		}
		
		var startColumn = 0
		
		// Determine start column
		// Start column is based on first column of text.
		if let firstCharIndex = firstLineContents.firstIndex(where: { character -> Bool in
			guard let unicodeScalar = character.unicodeScalars.first else { return false }
			return !CharacterSet.whitespacesAndNewlines.contains(unicodeScalar)
		}) {
			startColumn = firstCharIndex.utf16Offset(in: firstLineContents)
		} else {
			startColumn = start.column
		}
		
		// Determine indentation
		// The start column does not include indentation.
		let indentation: String
		if invocation.buffer.usesTabsForIndentation {
			indentation = Array(repeating: "\t", count: startColumn).joined()
		} else {
			indentation = Array(repeating: " ", count: startColumn).joined()
		}
		
		// Insert the embedding closure
		invocation.buffer.lines.insert(indentation + "}", at: endLine + 1)
		let singleIndentation = invocation.buffer.usesTabsForIndentation ? "\t" : Array(repeating: " ", count: invocation.buffer.tabWidth).joined()
		for line in start.line...endLine {
			guard let lineContents = invocation.buffer.lines[line] as? String else { return }
			let indentedLine = singleIndentation + lineContents
			invocation.buffer.lines[line] = indentedLine
		}
		invocation.buffer.lines.insert(indentation + "<#closure#> {", at: start.line)
		
		completionHandler(nil)
	}
	
}
