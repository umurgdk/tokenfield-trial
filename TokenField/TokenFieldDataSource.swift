//
//  TokenFieldDataSource.swift
//  TokenField
//
//  Created by Umur Gedik on 24.05.2021.
//

import AppKit

public protocol TokenFieldDataSource: AnyObject {
    func tokenField(_ tokenField: TokenField, numberOfCandidatesForInput input: String) -> Int
    func tokenFieldItemIndex(_ tokenField: TokenField, forInput input: String, candidateIndex index: Int) -> Int
    func tokenFieldTokenText(_ tokenField: TokenField, forItemAtIndex itemIndex: Int) -> String
    func tokenFieldCandidateView(_ tokenField: TokenField, forItemAtIndex itemIndex: Int) -> NSTableCellView
}
