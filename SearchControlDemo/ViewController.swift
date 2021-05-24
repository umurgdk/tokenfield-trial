//
//  ViewController.swift
//  SearchControlDemo
//
//  Created by Umur Gedik on 22.05.2021.
//

import Cocoa
import AutocompleteTokenField

class ViewController: NSViewController {
    @IBOutlet weak var searchControl: AutocompleteTokenField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
}

