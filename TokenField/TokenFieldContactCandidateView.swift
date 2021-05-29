//
//  TokenFieldContactCandidateView.swift
//  TokenField
//
//  Created by Umur Gedik on 24.05.2021.
//

import AppKit

open class TokenFieldContactCandidateView: NSTableCellView {
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
        
        avatarView.wantsLayer = true
        avatarView.layer?.cornerRadius = 4
        avatarView.layer?.masksToBounds = true
        avatarView.layer?.backgroundColor = NSColor.separatorColor.cgColor
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(avatarView)
        
        NSLayoutConstraint.activate([
            avatarView.widthAnchor.constraint(equalTo: avatarView.heightAnchor),
            avatarView.heightAnchor.constraint(equalToConstant: 32),
            avatarView.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            avatarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            avatarView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),

            titleLabel.bottomAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            
            subtitleLabel.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 0),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
