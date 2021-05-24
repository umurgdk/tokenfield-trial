//
//  AutocompleteTokenFieldCandidateView.swift
//  AutocompleteTokenField
//
//  Created by Umur Gedik on 24.05.2021.
//

import AppKit

open class AutocompleteTokenFieldCandidateView: NSTableCellView {
    public let titleLabel = NSTextField(labelWithString: "")
    public let subtitleLabel = NSTextField(labelWithString: "")
    public let avatarView = NSImageView()
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        titleLabel.font = NSFont.systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = .labelColor
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        subtitleLabel.font = NSFont.systemFont(ofSize: 13)
        subtitleLabel.textColor = .secondaryLabelColor
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subtitleLabel)
        
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(avatarView)
        
        NSLayoutConstraint.activate([
            avatarView.widthAnchor.constraint(equalTo: avatarView.heightAnchor),
            avatarView.heightAnchor.constraint(equalToConstant: 44),
            avatarView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            avatarView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),

            titleLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.trailingAnchor),
            
            subtitleLabel.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 1),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.trailingAnchor),
            subtitleLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        ])
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
