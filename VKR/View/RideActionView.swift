//
//  RideActionView.swift
//  VKR
//
//  Created by Арина Нефёдова on 08.05.2020.
//  Copyright © 2020 Арина Нефёдова. All rights reserved.
//

import UIKit
import MapKit

protocol RideActionViewDelegate: class {
    func uploadTrip(_ view: RideActionView)
    func cancelTrip()
    func pickupOrder()
    func dropOffOrder()
}

enum RideActionViewConfiguration {
    case requestRide
    case tripAccepted
    case driverArrived
    case pickupOrder
    case tripInProgress
    case endTrip
    
    init() {
        self = .requestRide
    }
}

enum ButtonAction: CustomStringConvertible {
    case requestRide
    case cancel
    case getDirections
    case pickup
    case dropOff
    
    var description: String {
        switch self {
        case .requestRide: return "ПОДТВЕРДИТЬ ЗАЯВКУ"
        case .cancel: return "ОТМЕНИТЬ ЗАЯВКУ"
        case .getDirections: return "ПОСТРОИТЬ МАРШРУТ"
        case .pickup: return "НАЧАТЬ ПОЕЗДКУ"
        case .dropOff: return "ЗАВЕРШИТЬ ПОЕЗДКУ"
        }
    }
    
    init() {
        self = .requestRide
    }
}

class RideActionView: UIView {

    // MARK: - Properties
    
    var destination: MKPlacemark? {
        didSet {
            titleLabel.text = destination?.name
            addressLabel.text = destination?.address
        }
    }
    
    var buttonAction = ButtonAction()
    weak var delegate: RideActionViewDelegate?
    var user: User?
    
    var config = RideActionViewConfiguration() {
        didSet { configureUI(withConfig: config) }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.textAlignment = .center
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
       // label.text = "Адрес"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    private let phoneInfoView: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var bgNumberOfTonInfoView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainOrangeTint
        
        view.addSubview(numberOfTonInfoView)
        numberOfTonInfoView.centerX(inView: view)
        numberOfTonInfoView.centerY(inView: view)
        
        return view
    }()
    
    private let numberOfTonInfoView: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        label.text = "до 1,5"
        return label
    }()
    
    private let tonInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
         label.text = "тонн"
        label.textAlignment = .center
        label.textColor = .lightGray
        return label
    }()
    
    // MARK: - Blur
    
    public var blurAnimator: UIViewPropertyAnimator!
    public let blurEffectView = UIVisualEffectView()
    public let blurBackgroundColorWhite = UIColor(white: 1, alpha: 0.1)
    public let blurEffect : CGFloat = 0.25
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .mainOrangeTint
        // button.setTitle("ПОДТВЕРДИТЬ ЗАЯВКУ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 25
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(actionButtonPressed), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        addShadow()
 
        addSubview(actionButton)
        actionButton.anchor(left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor,
                            right: rightAnchor, paddingLeft: 12, paddingBottom: 15,
                            paddingRight: 12, height: 50)
        
        
        let separatorView = UIView()
        separatorView.backgroundColor = .lightGray
        addSubview(separatorView)
        separatorView.anchor(left: leftAnchor, bottom: actionButton.topAnchor,
        right: rightAnchor, paddingBottom: 15, height: 0.4)
        
        addSubview(tonInfoLabel)
        tonInfoLabel.anchor(bottom: separatorView.topAnchor, paddingBottom: 5)
        tonInfoLabel.centerX(inView: self)
        
        addSubview(bgNumberOfTonInfoView)
               bgNumberOfTonInfoView.centerX(inView: self)
               bgNumberOfTonInfoView.anchor(bottom: tonInfoLabel.topAnchor, paddingBottom: 5)
               bgNumberOfTonInfoView.setDimensions(height: 65, width: 65)
               bgNumberOfTonInfoView.layer.cornerRadius = 65 / 2
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, addressLabel, phoneInfoView])
        stack.axis = .vertical
        stack.spacing = 5
        stack.distribution = .fillEqually
        
        addSubview(stack)
        stack.centerX(inView: self)
        stack.anchor(bottom: bgNumberOfTonInfoView.topAnchor, paddingBottom: 15)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func actionButtonPressed() {
        switch buttonAction {
        case .requestRide:
            delegate?.uploadTrip(self)
        case .cancel:
            delegate?.cancelTrip()
        case .getDirections:
            print("DEBUG: Построить маршрут..")
        case .pickup:
            delegate?.pickupOrder()
        case .dropOff:
            delegate?.dropOffOrder()
        }
    }
    
    // MARK: - Helper Functions
    
    private func configureUI(withConfig config: RideActionViewConfiguration) {
        switch config {
        case .requestRide:
            buttonAction = .requestRide
            actionButton.setTitle(buttonAction.description, for: .normal)
        case .tripAccepted:
            guard let user = user else { return }
            
            if user.accountType == .client {
                titleLabel.text = "В пути на погрузку"
                buttonAction = .getDirections
                actionButton.setTitle(buttonAction.description, for: .normal)
            } else {
                buttonAction = .cancel
                actionButton.setTitle(buttonAction.description, for: .normal)
                titleLabel.text = "Водитель в пути"
                
            }
           
            numberOfTonInfoView.text = String(user.fullname.first ?? "X")
            tonInfoLabel.text = user.fullname
            phoneInfoView.text = user.phone
            
        case .driverArrived:
            guard let user = user else { return }
            
            if user.accountType == .driver {
                titleLabel.text = "Водитель прибыл"
                addressLabel.text = "Подойдите к месту встречи"
            }
            
        case .pickupOrder:
            titleLabel.text = "Прибытие на погрузку"
            buttonAction = .pickup
            actionButton.setTitle(buttonAction.description, for: .normal)
            
        case .tripInProgress:
            guard let user = user else { return }
            
            if user.accountType == .driver {
                actionButton.setTitle("В ПУТИ", for: .normal)
                actionButton.isEnabled = false
            } else {
                buttonAction = .getDirections
                actionButton.setTitle(buttonAction.description, for: .normal)
            }
            
            titleLabel.text = "В пути"
            addressLabel.text = ""
            
        case .endTrip:
            guard let user = user else { return }
            
            if user.accountType == .driver {
                actionButton.setTitle("РАЗГРУЗКА", for: .normal)
                actionButton.isEnabled = false
            } else {
                buttonAction = .dropOff
                actionButton.setTitle(buttonAction.description, for: .normal)
            }
            
            titleLabel.text = "Прибытие на разгрузку"
        }
    }
}
