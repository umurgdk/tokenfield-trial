//
//  TokenFieldDelegate.swift
//  TokenField
//
//  Created by Umur Gedik on 29.05.2021.
//

import AppKit

public protocol TokenFieldDelegate: AnyObject {
    func tokenFieldTextDidChange(_ tokenField: TokenField)
    func tokenField(_ tokenField: TokenField, didAddTokenWithItemIndex itemIndex: Int)
    func tokenField(_ tokenField: TokenField, didRemoveTokenWithItemIndex itemIndex: Int)
    func tokenField(_ tokenField: TokenField, didHighlightTokenWithItemIndex itemIndex: Int)
    func tokenField(_ tokenField: TokenField, didUnhighlightTokenWithItemIndex itemIndex: Int)
}

public extension TokenFieldDelegate {
    func tokenFieldTextDidChange(_ tokenField: TokenField) { }
    func tokenField(_ tokenField: TokenField, didAddTokenWithItemIndex itemIndex: Int) { }
    func tokenField(_ tokenField: TokenField, didRemoveTokenWithItemIndex itemIndex: Int) { }
    func tokenField(_ tokenField: TokenField, didHighlightTokenWithItemIndex itemIndex: Int) { }
    func tokenField(_ tokenField: TokenField, didUnhighlightTokenWithItemIndex itemIndex: Int) { }
}
