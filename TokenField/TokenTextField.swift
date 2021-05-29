//
//  TokenTextField.swift
//  TokenField
//
//  Created by Umur Gedik on 29.05.2021.
//

import AppKit

class TokenTextField: NSTextField, NSTextViewDelegate {
    var onActivated: (() -> Void)?
    var onCancelled: (() -> Void)?
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        onActivated?()
    }
    
    func textViewDidChangeSelection(_ notification: Notification) {
        onActivated?()
    }
    
    override func doCommand(by selector: Selector) {
        if selector == #selector(NSResponder.cancelOperation(_:)) {
            onCancelled?()
        }
    }
}
