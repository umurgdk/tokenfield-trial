//
//  ViewController.swift
//  SearchControlDemo
//
//  Created by Umur Gedik on 22.05.2021.
//

import Cocoa
import TokenField

struct Contact {
    let name: String
    let email: String
    let image: NSImage?
}

let demoContacts: [Contact] = [
    Contact(name: "Alice Hood", email: "AliceBHood@dayrep.com", image: NSImage(named: "person1")),
    Contact(name: "Sharon N. Pratt", email: "SharonNPratt@armyspy.com", image: NSImage(named: "person2")),
    Contact(name: "James E. Fleck", email: "JamesEFleck@jourrapide.com", image: NSImage(named: "person3")),
    Contact(name: "Keith Rancourt", email: "KeithRRancourt@dayrep.com", image: NSImage(named: "person4")),
    Contact(name: "John Doe", email: "johndoe@video.io", image: NSImage(named: "john")),
    Contact(name: "Jane Doe", email: "janedoe@video.io", image: NSImage(named: "jane")),
]



class ViewController: NSViewController {
    @IBOutlet weak var searchControl: TokenField!
    @IBOutlet weak var logView: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchControl.dataSource = self
        searchControl.delegate = self
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        searchControl.textField.becomeFirstResponder()
    }
    
    private func log(_ string: String) {
        logView.moveToEndOfDocument(nil)
        logView.insertText(string, replacementRange: logView.selectedRange())
        logView.insertNewline(nil)
    }
}


extension ViewController: TokenFieldDataSource {
    func candidates(for input: String, field: TokenField) -> [(itemIndex: Int, contact: Contact)] {
        demoContacts.enumerated().filter { index, contact in
            let contains = contact.email.localizedCaseInsensitiveContains(input) || contact.name.localizedCaseInsensitiveContains(input)
            let alreadyAdded = field.tokenIndexSet.contains(index)
            
            return contains && !alreadyAdded
        }.map { (itemIndex: $0, contact: $1) }
    }
    
    func tokenField(_ tokenField: TokenField, numberOfCandidatesForInput input: String) -> Int {
        return candidates(for: input, field: tokenField).count
    }
    
    func tokenFieldItemIndex(_ tokenField: TokenField, forInput input: String, candidateIndex index: Int) -> Int {
        return candidates(for: input, field: tokenField)[index].itemIndex
    }
    
    func tokenFieldTokenText(_ tokenField: TokenField, forItemAtIndex itemIndex: Int) -> String {
        demoContacts[itemIndex].name
    }
    
    func tokenFieldCandidateView(_ tokenField: TokenField, forItemAtIndex itemIndex: Int) -> NSTableCellView {
        let candidate = demoContacts[itemIndex]
        let cell = TokenFieldContactCandidateView()
        cell.titleLabel.stringValue = candidate.name
        cell.subtitleLabel.stringValue = candidate.email
        cell.avatarView.image = candidate.image
        return cell
    }
}

extension ViewController: TokenFieldDelegate {
    func tokenFieldTextDidChange(_ tokenField: TokenField) {
        log("Text changed to: \(tokenField.text)")
    }
    
    func tokenField(_ tokenField: TokenField, didAddTokenWithItemIndex itemIndex: Int) {
        log("Token added: \(demoContacts[itemIndex].name)")
    }
    
    func tokenField(_ tokenField: TokenField, didRemoveTokenWithItemIndex itemIndex: Int) {
        log("Token removed: \(demoContacts[itemIndex].name)")
    }
    
    func tokenField(_ tokenField: TokenField, didHighlightTokenWithItemIndex itemIndex: Int) {
        log("Token highlighted: \(demoContacts[itemIndex].name)")
    }
    
    func tokenField(_ tokenField: TokenField, didUnhighlightTokenWithItemIndex itemIndex: Int) {
        log("Token unhighlighted: \(demoContacts[itemIndex].name)")
    }
}
