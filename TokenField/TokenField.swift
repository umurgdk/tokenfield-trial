//
//  TokenField.swift
//  TokenField
//
//  Created by Umur Gedik on 22.05.2021.
//

import Cocoa

fileprivate struct Token {
    let itemIndex: Int
    let cellView: TokenFieldTokenView
}

@IBDesignable
public class TokenField: NSView {
    public let textField: NSTextField = TokenTextField()
    
    public var text: String {
        textField.stringValue
    }
    
    public weak var dataSource: TokenFieldDataSource?
    public weak var delegate: TokenFieldDelegate?
    
    // MARK: - Appearance
    @IBInspectable
    public var backgroundColor: NSColor = NSColor.black.withAlphaComponent(0.1) {
        didSet { needsDisplay = true }
    }
    
    @IBInspectable
    public var borderColor: NSColor = NSColor.clear {
        didSet { needsDisplay = true }
    }
    
    @IBInspectable
    public var cornerRadius: CGFloat = 0 {
        didSet { needsDisplay = true }
    }
    
    public var font: NSFont = .preferredFont(forTextStyle: .body, options: [:]) {
        didSet {
            textField.font = font
            emptyCellView.font = font
            tokens.forEach { $0.cellView.font = font }
            needsLayout = true
        }
    }
    
    @IBInspectable
    public var minimumTextFieldWidth: CGFloat = 150 {
        didSet { needsLayout = true }
    }
    
    @IBInspectable
    public var afterTokenSpace: CGFloat = 4 {
        didSet { needsLayout = true }
    }
    
    @IBInspectable
    public var belowTokenSpace: CGFloat = 4 {
        didSet { needsLayout = true }
    }
    
    @IBInspectable
    public var horizontalPadding: CGFloat = 4 {
        didSet { needsLayout = true }
    }
    
    @IBInspectable
    public var verticalPadding: CGFloat = 4 {
        didSet { needsLayout = true }
    }
    
    @IBInspectable
    public var candidateListMaxHeight: CGFloat = 250 {
        didSet { candidatesWindowController?.maxHeight = candidateListMaxHeight }
    }
    
    // MARK: - NSView
    public override var isFlipped: Bool { true }
    public override var acceptsFirstResponder: Bool { true }

    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    public override var wantsUpdateLayer: Bool {
        return true
    }
    
    private func commonInit() {
        layerContentsRedrawPolicy = .onSetNeedsDisplay
        wantsLayer = true
        
        textField.delegate = self
        textField.drawsBackground = false
        textField.isBezeled = false
        textField.font = font
        textField.focusRingType = .none
        (textField as! TokenTextField).onActivated = { [weak self] in
            self?.showCandidates()
        }
        
        (textField as! TokenTextField).onCancelled = { [weak self] in
            self?.hideCandidates()
        }
        
        addSubview(textField)
        
        heightConstraint = heightAnchor.constraint(equalToConstant: textField.fittingSize.height)
        heightConstraint?.isActive = true
    }
    
    public override func updateLayer() {
        super.updateLayer()
        guard let layer = self.layer else { return }
        
        layer.backgroundColor = backgroundColor.cgColor
        layer.cornerRadius = cornerRadius
        if borderColor != .clear {
            layer.borderColor = borderColor.cgColor
            layer.borderWidth = 1
        }
    }
    
    // MARK: - Tokens
    public var tokenIndexSet: IndexSet {
        IndexSet(tokens.map(\.itemIndex))
    }
    
    private var tokens: [Token] = []
    private var highlightedItemIndex: Int? {
        didSet {
            if let index = oldValue, highlightedItemIndex != index {
                delegate?.tokenField(self, didUnhighlightTokenWithItemIndex: index)
                tokenByIndex(index)?.cellView.isSelected = false
            }
            
            if let index = highlightedItemIndex, index != oldValue {
                delegate?.tokenField(self, didHighlightTokenWithItemIndex: index)
                guard let newToken = tokenByIndex(index) else { return }
                window?.makeFirstResponder(self)
                newToken.cellView.isSelected = true
            }
        }
    }

    public func highlightToken(byItemIndex tokenIndex: Int) {
        highlightedItemIndex = tokenIndex
    }
    
    private func tokenByIndex(_ index: Int) -> Token? {
        tokens.first { $0.itemIndex == index }
    }
    
    public func removeSelectedToken() {
        guard
            let selectedIndex = highlightedItemIndex,
            let selectedToken = tokenByIndex(selectedIndex)
        else { return }
        
        tokens = tokens.filter { $0.itemIndex != selectedIndex }
        selectedToken.cellView.removeFromSuperview()
        needsLayout = true
        
        delegate?.tokenField(self, didRemoveTokenWithItemIndex: selectedIndex)
    }
    
    private func removeLastToken() {
        guard let token = tokens.last else { return }
        tokens.removeLast()
        token.cellView.removeFromSuperview()
        needsLayout = true
        
        delegate?.tokenField(self, didRemoveTokenWithItemIndex: token.itemIndex)
    }
    
    private func addToken() {
        guard
            let dataSource = dataSource,
            let candidatesWindowController = candidatesWindowController
        else { return }
        
        
        let itemIndex = dataSource.tokenFieldItemIndex(self, forInput: text, candidateIndex: candidatesWindowController.selectedRowIndex)
        let tokenText = dataSource.tokenFieldTokenText(self, forItemAtIndex: itemIndex)
        
        let cellView = TokenFieldTokenView(tokenIndex: itemIndex)
        cellView.text = tokenText
        cellView.font = font
        cellView.translatesAutoresizingMaskIntoConstraints = false
        cellView.tokenField = self
        addSubview(cellView)
        needsLayout = true
        
        let token = Token(itemIndex: itemIndex, cellView: cellView)
        tokens.append(token)
        
        candidatesWindowController.cancel()
        textField.stringValue = ""
        
        delegate?.tokenField(self, didAddTokenWithItemIndex: itemIndex)
        delegate?.tokenFieldTextDidChange(self)
    }
    
    // MARK: - Keyboard Events
    public override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        highlightedItemIndex = nil
        return true
    }
    
    public override func keyDown(with event: NSEvent) {
        interpretKeyEvents([event])
    }
    
    public override func doCommand(by selector: Selector) {
        let deleteSelectors = [
            #selector(NSResponder.deleteForward(_:)),
            #selector(NSResponder.deleteBackward(_:))
        ]
        
        if deleteSelectors.contains(selector) {
            removeSelectedToken()
            window?.makeFirstResponder(textField)
            return
        }
        
        switch selector {
        case #selector(NSResponder.moveLeft(_:)):
            guard let highlightedTokenIndex = tokens.firstIndex(where: { $0.itemIndex == highlightedItemIndex }) else {
                return
            }
            
            if highlightedTokenIndex > 0 {
                highlightToken(byItemIndex: tokens[highlightedTokenIndex - 1].itemIndex)
            }
            
        case #selector(NSResponder.moveRight(_:)):
            guard
                let highlightedTokenIndex = tokens.firstIndex(where: { $0.itemIndex == highlightedItemIndex }),
                let lastToken = tokens.last
            else {
                return
            }
            
            if highlightedItemIndex == lastToken.itemIndex {
                textField.becomeFirstResponder()
            } else if highlightedTokenIndex < tokens.count - 1 {
                highlightToken(byItemIndex: tokens[highlightedTokenIndex + 1].itemIndex)
            }
            
        default:
            break
        }
    }
    
    // MARK: - Layout
    private struct LayoutPass {
        let contentRect: CGRect
        var availableWidth: CGFloat
        var nextOrigin: CGPoint
        let lineHeight: CGFloat
    }
    
    private var lineHeight: CGFloat {
        max(emptyCellView.fittingSize.height, textField.fittingSize.height)
    }
    
    private var heightConstraint: NSLayoutConstraint?
    private let emptyCellView: TokenFieldTokenView = {
        let cellView = TokenFieldTokenView(tokenIndex: -1)
        cellView.text = " "
        return cellView
    }()
    
    public override func layout() {
        super.layout()
        
        let contentRect = bounds.insetBy(dx: horizontalPadding, dy: verticalPadding)
        var layoutPass = LayoutPass(
            contentRect: contentRect,
            availableWidth: bounds.width,
            nextOrigin: contentRect.origin,
            lineHeight: lineHeight
        )
        
        layoutTokenViews(pass: &layoutPass)
        layoutTextField(pass: layoutPass)
        
        let emptyTokenRect = CGRect(origin: contentRect.origin, size: emptyCellView.fittingSize)
        var boundingRect = (tokens.first?.cellView.frame ?? emptyTokenRect)
            .union(tokens.last?.cellView.frame ?? emptyTokenRect)
            .union(textField.frame)
        
        boundingRect = boundingRect.insetBy(dx: -horizontalPadding, dy: -verticalPadding)
        if heightConstraint?.constant != boundingRect.height {
            heightConstraint?.constant = boundingRect.height
        }
    }
    
    private func layoutTokenViews(pass: inout LayoutPass) {
        for token in tokens {
            let tokenSize = token.cellView.fittingSize
            if tokenSize.width > pass.availableWidth {
                pass.nextOrigin.x = pass.contentRect.minX
                pass.nextOrigin.y += pass.lineHeight + belowTokenSpace
                pass.availableWidth = pass.contentRect.width
            }
            
            token.cellView.frame = NSRect(origin: pass.nextOrigin, size: tokenSize)
            pass.nextOrigin.x += tokenSize.width + afterTokenSpace
            pass.availableWidth -= tokenSize.width + afterTokenSpace
        }
    }
    
    private func layoutTextField(pass: LayoutPass) {
        var textFieldOrigin = pass.nextOrigin
        var textFieldWidth = pass.availableWidth
        if textFieldWidth < minimumTextFieldWidth {
            textFieldOrigin.y += pass.lineHeight + belowTokenSpace
            textFieldOrigin.x = pass.contentRect.origin.x
            textFieldWidth = bounds.width
        }
        
        let textFieldSize = NSSize(width: textFieldWidth, height: textField.fittingSize.height)
        
        let verticalOffset = (pass.lineHeight - textField.fittingSize.height) / 2
        textFieldOrigin.y += verticalOffset
        if let lastTokenCellView = tokens.last?.cellView {
            let baselineOffset = (textField.firstBaselineOffsetFromTop + verticalOffset) - lastTokenCellView.firstBaselineOffsetFromTop
            textFieldOrigin.y += baselineOffset
        }
        
        textField.frame = NSRect(origin: textFieldOrigin, size: textFieldSize)
    }
    
    // MARK: - Candidates
    var candidatesWindowController: TokenFieldCandidatesWindowController?
    private func hideCandidates() {
        if let windowController = candidatesWindowController {
            windowController.cancel()
            candidatesWindowController = nil
        }
    }
    
    private func showCandidates() {
        guard
            let dataSource = dataSource,
            dataSource.tokenField(self, numberOfCandidatesForInput: textField.stringValue) > 0
        else {
            hideCandidates()
            return
        }
        
        let windowController = candidatesWindowController ?? {
            let wc = TokenFieldCandidatesWindowController()
            wc.onDoubleClick = { [weak self] in self?.addToken() }
            wc.maxHeight = candidateListMaxHeight
            return wc
        }()
        
        self.candidatesWindowController = windowController
        
        if windowController.window?.parent != window {
            windowController.begin(for: self)
        }
        
        windowController.reloadCandidates(with: dataSource)
    }
}

extension TokenField: NSTextFieldDelegate {
    public func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if commandSelector == #selector(NSResponder.insertNewline(_:)) {
            addToken()
            return true
        }
        
        if commandSelector == #selector(NSResponder.deleteBackward(_:)) {
            let selectedRange = textField.currentEditor()?.selectedRange
            let isCursorAtBeginning = selectedRange?.location == 0 && selectedRange?.length == 0
            if textField.stringValue == "" || isCursorAtBeginning {
                removeLastToken()
                return true
            }
        }
        
        if commandSelector == #selector(NSResponder.moveLeft(_:)) {
            let selectedRange = textField.currentEditor()?.selectedRange
            let isCursorAtBeginning = selectedRange?.location == 0 && selectedRange?.length == 0
            if let lastToken = tokens.last, textField.stringValue == "" || isCursorAtBeginning {
                highlightToken(byItemIndex: lastToken.itemIndex)
                return true
            }
        }
        
        if commandSelector == #selector(NSResponder.moveUp(_:)) {
            candidatesWindowController?.selectPrevious()
            return true
        }
        
        if commandSelector == #selector(NSResponder.moveDown(_:)) {
            candidatesWindowController?.selectNext()
            return true
        }
        
        return false
    }
    
    public func controlTextDidChange(_ obj: Notification) {
        showCandidates()
        delegate?.tokenFieldTextDidChange(self)
    }
}
