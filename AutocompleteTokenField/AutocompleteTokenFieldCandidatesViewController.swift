//
//  AutocompleteTokenFieldCandidatesViewController.swift
//  AutocompleteTokenField
//
//  Created by Umur Gedik on 24.05.2021.
//

import AppKit

class AutocompleteTokenFieldCandidatesViewController: NSViewController {
    weak var tokenField: AutocompleteTokenField?
    
    lazy var tableView = NSTableView()
    lazy var scrollView = NSScrollView()
    
    override func loadView() {
        view = NSView()
        
        let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("AutocompleteTokenFieldCandidateColumn"))
        column.isEditable = false
        tableView.addTableColumn(column)
        tableView.style = .inset
        tableView.allowsEmptySelection = false
        tableView.allowsTypeSelect = false
        tableView.allowsMultipleSelection = false
        tableView.refusesFirstResponder = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.headerView = nil
        tableView.usesAutomaticRowHeights = true
        tableView.target = self
        tableView.doubleAction = #selector(insertItem(_:))
        
        scrollView.drawsBackground = false
        scrollView.documentView = tableView
        scrollView.hasVerticalScroller = true
    }
    
    @objc func insertItem(_ sender: Any) {
        
    }
}

extension AutocompleteTokenFieldCandidatesViewController: NSTableViewDataSource, NSTableViewDelegate {
    func numberOfRows(in tableView: NSTableView) -> Int {
        guard let tokenField = tokenField else { return 0 }
        return tokenField.dataSource?.autocompleteTokenField(tokenField, numberOfCandidatesForInput: tokenField.text) ?? 0
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard
            let tokenField = tokenField,
            let dataSource = tokenField.dataSource
        else { return nil }
        
        let itemIndex = dataSource.autocompleteTokenFieldItemIndex(tokenField, forInput: tokenField.text, candidateIndex: row)
        let cellView = dataSource.autocompleteTokenField(tokenField, candidateViewForItemAtIndex: itemIndex)
        return cellView
    }
}
