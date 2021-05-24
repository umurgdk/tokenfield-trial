//
//  AutocompleteTokenDataSource.swift
//  AutocompleteTokenField
//
//  Created by Umur Gedik on 24.05.2021.
//

import AppKit

public protocol AutocompleteTokenFieldDataSource: AnyObject {
    func autocompleteTokenField(_ autocompleteTokenField: AutocompleteTokenField, numberOfCandidatesForInput input: String) -> Int
    func autocompleteTokenFieldItemIndex(_ autocompleteTokenField: AutocompleteTokenField, forInput input: String, candidateIndex index: Int) -> Int
    func autocompleteTokenFieldTokenText(_ autocompleteTokenField: AutocompleteTokenField, forItemAtIndex itemIndex: Int) -> String
    func autocompleteTokenField(_ autocompleteTokenField: AutocompleteTokenField, candidateViewForItemAtIndex itemIndex: Int) -> NSTableCellView
}
