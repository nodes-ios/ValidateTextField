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
    
    private var containerView: UIView!
    private var horizontalContainerStackView: UIStackView!
    private var verticalFieldsContainerStackView: UIStackView!
    private var headerLabel: UILabel!
    private var textField: UITextField!
    private var assistiveContainer: UIView?
    private var assistiveLabel: UILabel?
    
    // MARK: - Properties -
    
    private var containerBackgroundColor: UIColor!
    
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
    
    private var assistiveOffFocusTextColor: UIColor!
    private var assistiveInFocusTextColor: UIColor!
    private var assistiveBackgroundColor: UIColor!
    private var assistiveTextFont: UIFont!
    private var assistiveText: String?
    private var assistivePossition: AssistiveViewPosition!
    private var assistiveCornerRadius: CGFloat!
    
    // MARK: Error
    
    private var errorTextColor: UIColor!
    private var errorBackgroundColor: UIColor!
    private var errorTextFont: UIFont!
    private var errorText: String?
    
    // MARK: View and layout properties
    
    private var spacing: CGFloat!
    private var contentMargins: UIEdgeInsets!
    private var cornerRadius: CGFloat!
    private var borderWidth: CGFloat!
    private var borderOffFocusColor: UIColor!
    private var borderInFocusColor: UIColor!
    private var errorBorderColor: UIColor!
    
    // MARK: Internal Functionality Related Properties
    
    private var state: State = .normal {
        didSet {
            adjustUIAppearance()
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
                
                // insert the right view to be the second to last view in the hierarch if there is an assistiveContainer
                if assistiveContainer != nil {
                    horizontalContainerStackView.insertArrangedSubview(newValue!,
                                                                       at: horizontalContainerStackView.arrangedSubviews.count - 1)
                } else {
                    horizontalContainerStackView.addArrangedSubview(newValue!)
                }
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
    
    public var clearsOnInsertion: Bool {
        get {
            return textField.clearsOnInsertion
        }
        
        set {
            textField.clearsOnInsertion = newValue
        }
    }
    
    public var clearsOnBeginEditing: Bool {
        get {
            return textField.clearsOnBeginEditing
        }
        
        set {
            textField.clearsOnBeginEditing = newValue
        }
    }
    
    public var autocapitalizationType: UITextAutocapitalizationType {
        get {
            return textField.autocapitalizationType
        }
        
        set {
            textField.autocapitalizationType = newValue
        }
    }
    
    public var adjustsFontSizeToFitWidth: Bool {
        get {
            return textField.adjustsFontSizeToFitWidth
        }
        
        set {
            textField.adjustsFontSizeToFitWidth = newValue
        }
    }
    
    public var adjustsFontForContentSizeCategory: Bool {
        get {
            return textField.adjustsFontForContentSizeCategory
        }
        
        set {
            textField.adjustsFontForContentSizeCategory = newValue
        }
    }
    
    public var keyboardType: UIKeyboardType  {
        get {
            return textField.keyboardType
        }
        
        set {
            textField.keyboardType = newValue
        }
    }
    
    public var keyboardAppearance: UIKeyboardAppearance  {
        get {
            return textField.keyboardAppearance
        }
        
        set {
            textField.keyboardAppearance = newValue
        }
    }
    
    public var returnKeyType: UIReturnKeyType  {
        get {
            return textField.returnKeyType
        }
        
        set {
            textField.returnKeyType = newValue
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
    
    public init(contentType: ContentType, rightView: UIView? = nil, leftView: UIView? = nil, options: ValidateConfiguration = [:], validate: Validate? = nil) {
        super.init(frame: .zero)
        
        self.leftView = leftView
        self.rightView = rightView
        
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
        containerBackgroundColor = options[.backgroundColor] as? UIColor ?? .backgroundColor
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
        assistiveInFocusTextColor = options[.assistiveInFocusTextColor] as? UIColor ?? .headerInFocusColor
        assistiveOffFocusTextColor = options[.assistiveOffFocusTextColor] as? UIColor ?? .placeholderColor
        assistiveTextFont = options[.assistiveTextFont] as? UIFont ?? UIFont.systemFont(ofSize: 14)
        assistiveText = options[.assistiveText] as? String
        assistivePossition = options[.assistivePossition] as? AssistiveViewPosition ?? AssistiveViewPosition.none
        assistiveCornerRadius = options[.assistiveCornerRadius] as? CGFloat ?? 0
        assistiveBackgroundColor = options[.assistiveBackgroundColor] as? UIColor ?? .clear
        
        // Error
        errorTextColor = options[.errorTextColor] as? UIColor ?? .errorColor
        errorTextFont = options[.errorTextFont] as? UIFont ?? UIFont.systemFont(ofSize: 14)
        errorBackgroundColor = options[.errorTextColor] as? UIColor ?? .clear
        
        // Layer
        contentMargins = options[.contentMargins] as? UIEdgeInsets ?? UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        cornerRadius = options[.contentMargins] as? CGFloat ?? 4
        borderWidth = options[.contentMargins] as? CGFloat ?? 1
        borderOffFocusColor = options[.contentMargins] as? UIColor ?? .borderOffFocusColor
        borderInFocusColor = options[.contentMargins] as? UIColor ?? .borderInFocusColor
        errorBorderColor = options[.errorBorderColor] as? UIColor ?? .borderOffFocusColor
        
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
        // will allow for autolayout
        translatesAutoresizingMaskIntoConstraints = false
        
        makeContainerView()
        makeHorizontalContainerStackView()
        makeContainerStackView()
        makeHeaderLabel()
        makeTextField()
        
        switch assistivePossition {
        case .none:
            break
        default:
            makeAssistiveContainer()
        }
        
        adjustUIAppearance()
    }
    
    
    // Containers
    
    private func makeContainerView() {
        containerView = UIView()
        
        containerView.backgroundColor = containerBackgroundColor
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = cornerRadius
        containerView.layer.borderWidth = borderWidth
        
        adjustContainerLayerColor()
        
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // if we have an outsideField possition AssistiveView, then we don't set either top or bottom anchors, based on vertical alligment of the enum value
        switch assistivePossition {
        case .outsideField(let vertical):
            switch vertical {
            case .above:
                containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            case .below:
                containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            }
        default:
            containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        }
        
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        
        containerView.setContentHuggingPriority(.init(1000), for: .vertical)
        containerView.setContentCompressionResistancePriority(.init(1000), for: .vertical)
    }
    
    private func makeHorizontalContainerStackView() {
        horizontalContainerStackView = UIStackView()
        
        //configure view aspect
        horizontalContainerStackView.axis = .horizontal
        horizontalContainerStackView.alignment = .fill
        horizontalContainerStackView.distribution = .fill
        
        // add view to hierarchy
        containerView.addSubview(horizontalContainerStackView)
        
        // add constraints
        horizontalContainerStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalContainerStackView.topAnchor.constraint(equalTo: containerView.topAnchor,
                                                          constant: contentMargins.top).isActive = true
        horizontalContainerStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,
                                                              constant: contentMargins.left).isActive = true
        horizontalContainerStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,
                                                             constant: -contentMargins.bottom).isActive = true
        horizontalContainerStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,
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
    
    // Header
    
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
    
    // TextField
    
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
        
        if #available(iOS 12.0, *) {
            switch textField.textContentType {
            case .password?, .newPassword?:
                textField.isSecureTextEntry = true
            default:
                textField.isSecureTextEntry = false
            }
        } else {
            switch textField.textContentType {
            case .password?:
                textField.isSecureTextEntry = true
            default:
                textField.isSecureTextEntry = false
            }
        }
        
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
    
    // Assistive/Error
    
    private func makeAssistiveContainer() {
        assistiveContainer = UIView()
        assistiveContainer?.backgroundColor = .clear
        assistiveContainer?.clipsToBounds = true
        assistiveContainer?.layer.cornerRadius = assistiveCornerRadius
        
        switch assistivePossition {
        case .outsideField(let vertical):
            
            addSubview(assistiveContainer!)
            assistiveContainer!.translatesAutoresizingMaskIntoConstraints = false
            
            switch vertical {
            case .above:
                assistiveContainer!.topAnchor.constraint(equalTo: topAnchor).isActive = true
                assistiveContainer!.bottomAnchor.constraint(equalTo: horizontalContainerStackView.topAnchor,
                                                            constant: -4).isActive = true
            case .below:
                assistiveContainer!.topAnchor.constraint(equalTo: horizontalContainerStackView.bottomAnchor,
                                                         constant: 4).isActive = true
                assistiveContainer!.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            }
            
            assistiveContainer!.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                         constant: contentMargins.left).isActive = true
            assistiveContainer!.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                          constant: -contentMargins.right).isActive = true
            
            makeAssistiveLabel(insets: UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0))
        case .insideField:
            // insert the assistive container as the last view in the stackview
            if rightView != nil {
                horizontalContainerStackView.insertArrangedSubview(assistiveContainer!,
                                                                   at: horizontalContainerStackView.arrangedSubviews.count - 1)
            } else {
                horizontalContainerStackView.addArrangedSubview(assistiveContainer!)
            }
            makeAssistiveLabel(insets: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
        default:
            break
        }
    }
    
    private func makeAssistiveLabel(insets: UIEdgeInsets) {
        assistiveLabel = UILabel()
        
        assistiveLabel!.numberOfLines = 0
        
        assistiveContainer!.addSubview(assistiveLabel!)
        
        assistiveLabel!.translatesAutoresizingMaskIntoConstraints = false
        assistiveLabel!.leadingAnchor.constraint(equalTo: assistiveContainer!.leadingAnchor, constant: insets.left).isActive = true
        assistiveLabel!.trailingAnchor.constraint(equalTo: assistiveContainer!.trailingAnchor, constant: -insets.right).isActive = true
        
        switch assistivePossition {
        case .insideField(let vertical):
            
            assistiveLabel!.textAlignment = .center

            switch vertical {
            case .top:
                assistiveLabel!.topAnchor.constraint(equalTo: assistiveContainer!.topAnchor).isActive = true
            case .center:
                assistiveLabel!.centerYAnchor.constraint(equalTo: assistiveContainer!.centerYAnchor).isActive = true
            case .bottom:
                assistiveLabel!.topAnchor.constraint(equalTo: assistiveContainer!.bottomAnchor).isActive = true
            }
        default:
            assistiveLabel!.topAnchor.constraint(equalTo: assistiveContainer!.topAnchor, constant: insets.top).isActive = true
            assistiveLabel!.bottomAnchor.constraint(equalTo: assistiveContainer!.bottomAnchor, constant: -insets.bottom).isActive = true
        }
        
    }
    
    // MARK: - Adjust UI
    
    private func adjustUIAppearance() {
        adjustContainerLayerColor()
        adjustHeaderColors()
        adjustAssitiveAppearance()
    }
    
    private func adjustHeaderColors() {
        switch state {
        case .active:
            headerLabel.textColor = headerInFocusTextColor
        case .normal:
            headerLabel.textColor = headerOffFocusTextColor
        case .error:
            headerLabel.textColor = .errorColor
        }
    }
    
    private func adjustAssitiveAppearance() {
        guard assistiveLabel != nil,
            assistiveContainer != nil else { return }
        
        switch state {
        case .active:
            assistiveLabel!.textColor = assistiveInFocusTextColor
            assistiveLabel!.font = assistiveTextFont
            assistiveLabel!.text = assistiveText
            assistiveContainer!.backgroundColor = assistiveBackgroundColor
        case .normal:
            assistiveLabel!.textColor = assistiveOffFocusTextColor
            assistiveLabel!.font = assistiveTextFont
            assistiveLabel!.text = assistiveText
            assistiveContainer!.backgroundColor = assistiveBackgroundColor
        case .error:
            assistiveLabel!.textColor = errorTextColor
            assistiveLabel!.font = errorTextFont
            assistiveLabel!.text = errorText
            assistiveContainer!.backgroundColor = errorBackgroundColor
        }
        
        assistiveLabel!.sizeToFit()
    }
    
    private func adjustContainerLayerColor() {
        func setColor() {
            switch state {
            case .active:
                containerView.layer.borderColor = borderInFocusColor.cgColor
            case .normal:
                containerView.layer.borderColor = borderOffFocusColor.cgColor
            case .error:
                containerView.layer.borderColor = errorBorderColor.cgColor
            }
        }
        
        if #available(iOS 13.0, *) {
            traitCollection.performAsCurrent {
                setColor()
            }
        } else {
            setColor()
        }
        
    }
    
    // MARK: - Validate
    
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
        state = state != .error ? .normal : state
        
        headerLabel.isHidden = textField.text?.isEmpty ?? true
        
        validate(text: textField.text)
        didEndEditing?(self, textField.text)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        didEndEditing?(self, textField.text)
        return true
    }
    
}
