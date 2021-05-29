//
//  TokenFieldCandidatesViewController.swift
//  TokenField
//
//  Created by Umur Gedik on 24.05.2021.
//

import AppKit

class TokenFieldCandidatesViewController: NSViewController {
    lazy var tableView = NSTableView()
    lazy var scrollView = NSScrollView()
    var onDoubleClick: (() -> Void)?
    
    weak var tokenField: TokenField?
    weak var dataSource: TokenFieldDataSource?
    
    var heightConstraint: NSLayoutConstraint?
    var maxHeight: CGFloat = 250 {
        didSet { resizeSelf() }
    }
    
    override func loadView() {
        view = NSView()
        view.wantsLayer = true
        view.layer?.cornerRadius = 4
        view.layer?.backgroundColor = NSColor.windowBackgroundColor.cgColor

        let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("AutocompleteTokenFieldCandidateColumn"))
        column.isEditable = false
        tableView.addTableColumn(column)
        tableView.style = .plain
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
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        heightConstraint = scrollView.heightAnchor.constraint(equalToConstant: 100)

        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            heightConstraint!
        ])
    }
    
    @objc func insertItem(_ sender: Any) {
        onDoubleClick?()
    }
    
    func reloadCandidates(with dataSource: TokenFieldDataSource) {
        self.dataSource = dataSource
        tableView.reloadData()
        resizeSelf()
    }
    
    private func resizeSelf() {
        guard tableView.numberOfRows > 0 else { return }
        let rowHeight = tableView.rowView(atRow: 0, makeIfNecessary: true)?.bounds.height ?? 20
        heightConstraint?.constant = min(rowHeight * CGFloat(tableView.numberOfRows), maxHeight)
    }
    
    // MARK: - Selection
    var selectedRowIndex: Int {
        tableView.selectedRow
    }
    
    func selectPrevious() {
        let selectedRow = max(tableView.selectedRow - 1, 0)
        tableView.selectRowIndexes([selectedRow], byExtendingSelection: false)
        tableView.scrollRowToVisible(tableView.selectedRow)
    }
    
    func selectNext() {
        let selectedRow = min(tableView.selectedRow + 1, tableView.numberOfRows)
        tableView.selectRowIndexes([selectedRow], byExtendingSelection: false)
        tableView.scrollRowToVisible(tableView.selectedRow)
    }
}

extension TokenFieldCandidatesViewController: NSTableViewDataSource, NSTableViewDelegate {
    func numberOfRows(in tableView: NSTableView) -> Int {
        guard
            let tokenField = tokenField,
            let dataSource = dataSource
        else { return 0 }
        
        return dataSource.tokenField(tokenField, numberOfCandidatesForInput: tokenField.text)
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard
            let tokenField = tokenField,
            let dataSource = dataSource
        else { return nil }
        
        let itemIndex = dataSource.tokenFieldItemIndex(tokenField, forInput: tokenField.text, candidateIndex: row)
        let cellView = dataSource.tokenFieldCandidateView(tokenField, forItemAtIndex: itemIndex)
        return cellView
    }
    
    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        if let rowView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("row"), owner: nil) as? NSTableRowView {
            return rowView
        }
        
        let rowView = TokenFieldCandidatesRowView()
        rowView.identifier = NSUserInterfaceItemIdentifier("row")
        return rowView
    }
}
