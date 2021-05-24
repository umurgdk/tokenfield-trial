//
//  AutocompleteTokenCellView.swift
//  SearchControlDemo
//
//  Created by Umur Gedik on 22.05.2021.
//

import AppKit

public class AutocompleteTokenFieldTokenView: NSView {
    let textField = NSTextField(labelWithString: "")
    public var text: String {
        get { textField.stringValue }
        set { textField.stringValue = newValue }
    }
    
    public var backgroundColor = NSColor.systemBlue {
        didSet { needsDisplay = true }
    }
    
    public var selectedBackgroundColor = NSColor.systemBlue.highlight(withLevel: 0.3) ?? .systemBlue {
        didSet { needsDisplay = true }
    }
    
    public var cornerRadius = CGFloat(4) {
        didSet { needsDisplay = true }
    }
    
    public var isSelected = false {
        didSet {
            updateTextField()
            needsDisplay = true
        }
    }
    
    public var font: NSFont?  {
        get { textField.font }
        set { textField.font = newValue }
    }
    
    public var textColor = NSColor.white {
        didSet { updateTextField() }
    }
    
    public var selectedTextColor = NSColor.white {
        didSet { updateTextField() }
    }
    
    public weak var tokenField: AutocompleteTokenField?
    
    public var paddings = NSDirectionalEdgeInsets(top: 2, leading: 4, bottom: 2, trailing: 4) {
        didSet {
            textFieldConstraints[0].constant = paddings.top
            textFieldConstraints[1].constant = paddings.leading
            textFieldConstraints[2].constant = paddings.bottom
            textFieldConstraints[3].constant = paddings.trailing
        }
    }
    
    private var textFieldConstraints: [NSLayoutConstraint] = []
    
    public override var firstBaselineOffsetFromTop: CGFloat {
        paddings.top + textField.firstBaselineOffsetFromTop
    }
    
    public override var wantsUpdateLayer: Bool { true }
    
    private let tokenIndex: Int
    
    init(tokenIndex: Int, paddings: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(top: 2, leading: 4, bottom: 2, trailing: 4)) {
        self.paddings = paddings
        self.tokenIndex = tokenIndex
        super.init(frame: .zero)
        
        wantsLayer = true
        layerContentsRedrawPolicy = .onSetNeedsDisplay
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(textField)
        textFieldConstraints = [
            textField.topAnchor.constraint(equalTo: topAnchor, constant: paddings.top),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: paddings.leading),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -paddings.bottom),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -paddings.trailing)
        ]
        
        NSLayoutConstraint.activate(textFieldConstraints)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func mouseDown(with event: NSEvent) {
        tokenField?.selectToken(byIndex: tokenIndex)
    }
    
    public override func updateLayer() {
        super.updateLayer()
        guard let layer = self.layer else { return }
        
        layer.backgroundColor = isSelected ? selectedBackgroundColor.cgColor : backgroundColor.cgColor
        layer.cornerRadius = cornerRadius
        textField.textColor = isSelected ? selectedTextColor : textColor
    }
    
    private func updateTextField() {
        textField.textColor = isSelected ? textColor : selectedTextColor
    }
}
