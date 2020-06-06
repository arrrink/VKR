//
//  LocationInputActivationView.swift
//  VKR
//
//  Created by Арина Нефёдова on 08.05.2020.
//  Copyright © 2020 Арина Нефёдова. All rights reserved.
//

import UIKit

protocol LocationInputActivationViewDelegate {
    func presentLocationInputView()
}

class LocationInputActivationView: UIView {
    
    // MARK: - Blur
    
    public var blurAnimator: UIViewPropertyAnimator!
    public let blurEffectView = UIVisualEffectView()
    public let blurBackgroundColorWhite = UIColor(white: 1, alpha: 0.1)
    public let blurEffect : CGFloat = 0.25
    
    // MARK: - Properties
    
    var delegate: LocationInputActivationViewDelegate?
    
    let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainOrangeTint
        return view
    }()
    
    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Куда доставить груз?"
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureGestureRecognizer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleViewTapped() {
        delegate?.presentLocationInputView()
    }
    
    // MARK: - Helper Functions
    
    func configureUI() {
        backgroundColor = blurBackgroundColorWhite
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        layer.masksToBounds = false

        blurEffectView.backgroundColor = .clear
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        insertSubview(blurEffectView, at: 0)
        
        blurAnimator = UIViewPropertyAnimator(duration: 1, curve: .linear) { [blurEffectView] in
            blurEffectView.effect = UIBlurEffect(style: .regular)
        }

        blurAnimator.fractionComplete = blurEffect
        
        
        
        addSubview(indicatorView)
        indicatorView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 16)
        indicatorView.setDimensions(height: 6, width: 6)
        indicatorView.layer.cornerRadius = 3
        
        addSubview(placeholderLabel)
        placeholderLabel.centerY(inView: self, leftAnchor: indicatorView.rightAnchor, paddingLeft: 20)
    }
    
    func configureGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleViewTapped))
        addGestureRecognizer(tap)
    }
}
