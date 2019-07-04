//
//  UserInfoInputView.swift
//  Dot
//
//  Created by Andrei Hogea on 27/12/2018.
//  Copyright © 2018 Nodes. All rights reserved.
//

import UIKit

public class ValidateTextField: UIView {
    
    public typealias ContentType = UITextContentType
    public typealias Validate = ((_ text: String?, _ validationResult: @escaping (ValidationResult) -> Void) -> Void)
    
    // MARK: - Views -
    
    private var horizontalContainerStackView: UIStackView!
    private var verticalFieldsContainerStackView: UIStackView!
    private var headerLabel: UILabel!
    private var textField: UITextField!
    private var assistiveLabelContainer: UIView!
    private var assistiveLabel: UILabel!
    
    // MARK: - Properties -
    
    // MARK: Header
    
    private var headerOffFocusTextColor: UIColor!
    private var headerInFocusTextColor: UIColor!
    private var headerTextFont: UIFont!
    private var headerText: String!
    
    // MARK: TextField
    
    private var textFieldContentType: ContentType!
    private var textFieldRightView: UIView?
    private var textFieldLeftView: UIView?
    private var textFieldTintColor: UIColor!
    private var textColor: UIColor!
    private var textFont: UIFont!
    
    // MARK: Placeholder
    
    private var placeholderTextColor: UIColor!
    private var placeholderTextFont: UIFont!
    private var placeholderText: String!
    
    // MARK: Assistive
    
    private var assistiveTextColor: UIColor!
    private var assistiveTextFont: UIFont!
    private var assistiveText: String?
    
    // MARK: Error
    
    private var errorTextColor: UIColor!
    private var errorTextFont: UIFont!
    private var errorText: String?
    
    // MARK: View and layout properties
    
    private var spacing: CGFloat!
    private var contentMargins: UIEdgeInsets!
    private var cornerRadius: CGFloat!
    private var borderWidth: CGFloat!
    private var borderOffFocusColor: UIColor!
    private var borderInFocusColor: UIColor!
    
    // MARK: Internal Functionality Related Properties
    
    private var state: State = .normal {
        didSet {
            adjustUI()
        }
    }
    
    // MARK: - Public exposed variables
    
    // TextField
    public var rightView: UIView? {
        get {
            return textFieldRightView
        }
        
        set {
            if textFieldRightView != nil {
                horizontalContainerStackView.removeArrangedSubview(textFieldRightView!)
                textFieldRightView!.removeFromSuperview()
                textFieldRightView = nil
            } else if newValue != nil {
                textFieldRightView = newValue
                horizontalContainerStackView.addArrangedSubview(newValue!)
            }
        }
    }
    
    public var leftView: UIView? {
        get {
            return textFieldLeftView
        }
        
        set {
            if textFieldLeftView != nil {
                horizontalContainerStackView.removeArrangedSubview(textFieldLeftView!)
                textFieldLeftView!.removeFromSuperview()
                textFieldLeftView = nil
            } else if newValue != nil {
                textFieldLeftView = newValue
                horizontalContainerStackView.insertArrangedSubview(textFieldLeftView!, at: 0)
            }
        }
    }
    
    public var text: String? {
        set {
            guard textField != nil else {
                return
            }
            textField.text = newValue
            headerLabel.isHidden = (newValue ?? "").isEmpty
        }
        
        get {
            guard textField != nil else {
                return nil
            }
            return textField.text
        }
    }
    
    public var textContentType: ContentType {
        get {
            return textFieldContentType
        }
    }
    
    // MARK: - Callbacks Vars
    
    public var didBeginEditing: ((ValidateTextField, String?) -> Void)?
    public var didChange: ((ValidateTextField, String?) -> Void)?
    public var didEndEditing: ((ValidateTextField, String?) -> Void)?
    public var validate: Validate?
    
    // MARK: - Initializers -
    
    public init(contentType: ContentType, rightView: UIView? = nil, leftView: UIView? = nil, options: ValidateConfiguration = [:]) {
        super.init(frame: .zero)
        
        self.leftView = leftView
        self.rightView = rightView
        
        configure(with: options)
        configure(with: contentType)

        buildViewHierarchy()
    }
    
    public init(contentType: ContentType, options: ValidateConfiguration = [:]) {
        super.init(frame: .zero)
        
        configure(with: options)
        configure(with: contentType)

        buildViewHierarchy()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        buildViewHierarchy()
    }
    
    // MARK: - Configuration Options
    
    private func configure(with contentType: ContentType) {
        textFieldContentType = contentType
        
        if headerText != nil && placeholderText == nil {
            placeholderText = headerText
            // if no text for header or placeholder is provided, we default to default English text
        } else if headerText == nil && placeholderText == nil {
            switch contentType {
            case .URL:
                headerText = "URL"
            case .addressCity:
                headerText = "City"
            case .addressCityAndState:
                headerText = "City"
            case .addressState:
                headerText = "State"
            case .countryName:
                headerText = "Country"
            case .creditCardNumber:
                headerText = "Card Number"
            case .emailAddress:
                headerText = "Email Address"
            case .familyName:
                headerText = "Family Name"
            case .fullStreetAddress:
                headerText = "Street"
            case .givenName:
                headerText = "Given Name"
            case .jobTitle:
                headerText = "Job Title"
            case .location:
                headerText = "Location"
            case .middleName:
                headerText = "Middle Name"
            case .name:
                headerText = "Name"
            case .namePrefix:
                headerText = "Name Prefix"
            case .nameSuffix:
                headerText = "Name Suffix"
            case .nickname:
                headerText = "Nickname"
            case .organizationName:
                headerText = "Organization Name"
            case .postalCode:
                headerText = "Postal Code"
            case .streetAddressLine1:
                headerText = "Street Address Line 1"
            case .streetAddressLine2:
                headerText = "Street Address Line 2"
            case .sublocality:
                headerText = "Sublocality"
            case .telephoneNumber:
                headerText = "Telephone Number"
            case .username:
                headerText = "Username"
            case .password:
                headerText = "Password"
            default:
                guard #available (iOS 12, *) else { return }
                if contentType == .newPassword {
                    headerText = "New Password"
                }
                
                if contentType == .oneTimeCode {
                    headerText = "One Time Code"
                }
            }
            
            placeholderText = headerText
        }
    }
    
    private func configure(with options: ValidateConfiguration) {
        
        // View
        backgroundColor = options[.backgroundColor] as? UIColor ?? .backgroundColor
        spacing = options[.spacing] as? CGFloat ?? 8
        
        // Header
        headerOffFocusTextColor = options[.headerOffFocusTextColor] as? UIColor ?? .headerOffFocusColor
        headerInFocusTextColor = options[.headerInFocusTextColor] as? UIColor ?? .headerInFocusColor
        headerTextFont = options[.headerTextFont] as? UIFont ?? UIFont.systemFont(ofSize: 12, weight: .medium)
        headerText = options[.headerText] as? String
        
        // TextField
        textColor = options[.textColor] as? UIColor ?? .textColor
        textFont = options[.textFont] as? UIFont ?? UIFont.systemFont(ofSize: 15)
        textFieldTintColor = options[.tintColor] as? UIColor ?? .textColor
        text = options[.text] as? String ?? ""
        
        // Placeholder
        placeholderTextColor = options[.placeholderTextColor] as? UIColor ?? .placeholderColor
        placeholderTextFont = options[.placeholderTextFont] as? UIFont ?? UIFont.systemFont(ofSize: 16)
        placeholderText = options[.placeholderText] as? String
        
        // Assistive
        assistiveTextColor = options[.assistiveTextColor] as? UIColor ?? .placeholderColor
        assistiveTextFont = options[.assistiveTextFont] as? UIFont ?? UIFont.systemFont(ofSize: 14)
        assistiveText = options[.assistiveText] as? String

        // Error
        errorTextColor = options[.errorTextColor] as? UIColor ?? .errorColor
        errorTextFont = options[.errorTextFont] as? UIFont ?? UIFont.systemFont(ofSize: 14)
        
        // Layer
        contentMargins = options[.contentMargins] as? UIEdgeInsets ?? UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        cornerRadius = options[.contentMargins] as? CGFloat ?? 4
        borderWidth = options[.contentMargins] as? CGFloat ?? 1
        borderOffFocusColor = options[.contentMargins] as? UIColor ?? .borderOffFocusColor
        borderInFocusColor = options[.contentMargins] as? UIColor ?? .borderInFocusColor
        
    }
    
    // MARK: - Responders
    
    @discardableResult
    override public func becomeFirstResponder() -> Bool {
        textField.becomeFirstResponder()
        return true
    }
    
    public var isActiveResponder: Bool {
        get {
            return state == .active
        }
    }
    
    override public var canBecomeFirstResponder: Bool {
        return textField.canBecomeFirstResponder
    }
    
    // MARK: - Factory Methods
    
    private func buildViewHierarchy() {
        adjustParent()
        makeHorizontalContainerStackView()
        makeContainerStackView()
        makeHeaderLabel()
        makeTextField()
    }
    
    private func adjustParent() {
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        
        adjustContainerLayerColor()
        
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(greaterThanOrEqualToConstant: 55).isActive = true
        
        setContentHuggingPriority(.init(1000), for: .vertical)
        setContentCompressionResistancePriority(.init(1000), for: .vertical)
    }
    
    private func makeHorizontalContainerStackView() {
        horizontalContainerStackView = UIStackView()
        
        //configure view aspect
        horizontalContainerStackView.axis = .horizontal
        horizontalContainerStackView.alignment = .fill
        horizontalContainerStackView.distribution = .fill
        
        // add view to hierarchy
        addSubview(horizontalContainerStackView)
        
        // add constraints
        horizontalContainerStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalContainerStackView.topAnchor.constraint(equalTo: topAnchor,
                                                          constant: contentMargins.top).isActive = true
        horizontalContainerStackView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                              constant: contentMargins.left).isActive = true
        horizontalContainerStackView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                             constant: -contentMargins.bottom).isActive = true
        horizontalContainerStackView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                               constant: -contentMargins.right).isActive = true
    }
    
    private func makeContainerStackView() {
        verticalFieldsContainerStackView = UIStackView()
        
        //configure view aspect
        verticalFieldsContainerStackView.axis = .vertical
        verticalFieldsContainerStackView.alignment = .fill
        verticalFieldsContainerStackView.distribution = .fill
        
        // add view to hierarchy
        horizontalContainerStackView.addArrangedSubview(verticalFieldsContainerStackView)
        
        
        verticalFieldsContainerStackView.setContentHuggingPriority(.init(1000), for: .vertical)
        verticalFieldsContainerStackView.setContentCompressionResistancePriority(.init(1000), for: .vertical)
    }
    
    private func makeHeaderLabel() {
        headerLabel = UILabel()
        headerLabel.isHidden = (text ?? "").isEmpty
        
        //configure view aspect
        headerLabel.text = headerText
        headerLabel.font = headerTextFont
        
        // add view to hierarchy
        verticalFieldsContainerStackView.addArrangedSubview(headerLabel)
        
        // add constraints
        headerLabel.setContentHuggingPriority(.init(1000), for: .vertical)
        headerLabel.setContentCompressionResistancePriority(.init(1000), for: .vertical)
    }
    
    private func configureHeaderColors() {
        headerLabel.textColor = state == .active ? headerInFocusTextColor : headerOffFocusTextColor
    }
    
    private func makeTextField() {
        textField = UITextField()
        textField.delegate = self
        textField.addTarget( self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField.textContentType = textFieldContentType
        
        //configure view aspect
        textField.font = textFont
        textField.textColor = textColor
        textField.tintColor = textFieldTintColor
        textField.text = text
        
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText,
                                                             attributes: [
                                                                NSAttributedString.Key.foregroundColor: placeholderTextColor as Any,
                                                                NSAttributedString.Key.font: placeholderTextFont as Any])
        
        // add view to hierarchy
        verticalFieldsContainerStackView.addArrangedSubview(textField)
        
        // add constraints
        textField.setContentHuggingPriority(.init(1000), for: .vertical)
        textField.setContentCompressionResistancePriority(.init(1000), for: .vertical)
    }
    
    private func makeAssistiveLabel() {
        
    }
    
    // MARK: - Adjust UI
    
    private func adjustUI() {
        adjustContainerLayerColor()
    }
    
    private func adjustContainerLayerColor() {
        if #available(iOS 13.0, *) {
            traitCollection.performAsCurrent {
                layer.borderColor = state == .active ? borderInFocusColor.cgColor : borderOffFocusColor.cgColor
            }
        } else {
            layer.borderColor = state == .active ? borderInFocusColor.cgColor : borderOffFocusColor.cgColor
        }
    }
    
}

// MARK: - UITextFieldDelegate

extension ValidateTextField: UITextFieldDelegate {
    @objc public func textFieldDidChange(_ textField: UITextField) {
        headerLabel.isHidden = textField.text?.count == 0
        textField.accessibilityLabel = textField.text
        
        didChange?(self, textField.text)
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        state = state != .error ? .active : state
        
        didBeginEditing?(self, textField.text)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        state = .normal
        
        headerLabel.isHidden = textField.text?.isEmpty ?? true
        
        validate(text: textField.text)
        didEndEditing?(self, textField.text)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        didEndEditing?(self, textField.text)
        return true
    }
    
    private func validate(text: String?) {
        validate?(textField.text, { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                self.errorText = error
                self.state = .error
            }
        })
    }
}
