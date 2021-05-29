//
//  TokenFieldCandidatesWindowController.swift
//  TokenField
//
//  Created by Umur Gedik on 27.05.2021.
//

import AppKit
import Accessibility

class TokenFieldCandidatesWindowController: NSWindowController {
    var onDoubleClick: (() -> Void)? {
        get { candidatesViewController.onDoubleClick }
        set { candidatesViewController.onDoubleClick = newValue }
    }
    
    var maxHeight: CGFloat {
        get { candidatesViewController.maxHeight }
        set { candidatesViewController.maxHeight = newValue }
    }

    private var mouseEventToken: Any?
    private var lostFocusEventToken: Any?
    
    private var candidatesViewController: TokenFieldCandidatesViewController {
        contentViewController as! TokenFieldCandidatesViewController
    }
    
    init() {
        let viewController = TokenFieldCandidatesViewController()
        let window = NSWindow(contentViewController: viewController)
        window.styleMask = .borderless
        window.hasShadow = true
        window.backgroundColor = .clear
        window.isOpaque = false
        super.init(window: window)
        
        contentViewController = viewController
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        if let token = lostFocusEventToken {
            NotificationCenter.default.removeObserver(token)
        }
        
        if let token = mouseEventToken {
            NSEvent.removeMonitor(token)
        }
    }
    
    func reloadCandidates(with dataSource: TokenFieldDataSource) {
        candidatesViewController.reloadCandidates(with: dataSource)
    }
    
    func begin(for field: TokenField) {
        guard
            let window = self.window,
            let parentWindow = field.window,
            let superview = field.superview
        else { return }
        
        var frame = window.frame
        frame.size.width = field.frame.width
        
        candidatesViewController.tokenField = field

        var windowLocation = superview.convert(field.frame.origin, to: nil)
        windowLocation = parentWindow.convertPoint(toScreen: windowLocation)
        windowLocation.y -= 2
        
        window.setFrame(frame, display: false)
        window.setFrameTopLeftPoint(windowLocation)
        
        parentWindow.addChildWindow(window, ordered: .above)
        
        // The window must know its accessibility parent, the control must know the window one of its accessibility children
        // Note that views (controls especially) are often ignored, so we want the unignored descendant - usually a cell
        // Finally, post that we have created the unignored decendant of the suggestions window
        // PS: Taken from Apple sample code
        let unignoredDescendant = NSAccessibility.unignoredDescendant(of: field)
        window.setAccessibilityParent(unignoredDescendant)
        NSAccessibility.post(element: NSAccessibility.unignoredDescendant(of: window), notification: .created)
        
        mouseEventToken = NSEvent.addLocalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown, .otherMouseDown]) { [weak self, weak field] event in
            guard
                let self = self,
                let field = field
            else { return event }
            
            if event.window != window {
                if event.window == parentWindow {
                    guard let parentContentView = parentWindow.contentView else {
                        self.cancel()
                        return event
                    }
                    
                    let hitPoint = parentContentView.convert(event.locationInWindow, from: nil)
                    let fieldEditor = field.textField.currentEditor()
                    if let hitView = parentContentView.hitTest(hitPoint), hitView != fieldEditor {
                        self.cancel()
                    }
                } else {
                    self.cancel()
                }
            }
            
            return event
        }
        
        lostFocusEventToken = NotificationCenter.default.addObserver(forName: NSWindow.didResignKeyNotification, object: parentWindow, queue: nil) { [weak self] _ in
            self?.cancel()
        }
    }
    
    func cancel() {
        guard let window = window else { return }
        if window.isVisible {
            window.parent?.removeChildWindow(window)
            window.orderOut(nil)
            window.setAccessibilityParent(nil)
        }
        
        if let token = lostFocusEventToken {
            NotificationCenter.default.removeObserver(token)
            lostFocusEventToken = nil
        }
        
        if let token = mouseEventToken {
            NSEvent.removeMonitor(token)
            mouseEventToken = nil
        }
    }
    
    // MARK: - Selection
    var selectedRowIndex: Int {
        candidatesViewController.selectedRowIndex
    }
    
    func selectPrevious() {
        candidatesViewController.selectPrevious()
    }
    
    func selectNext() {
        candidatesViewController.selectNext()
    }
}
