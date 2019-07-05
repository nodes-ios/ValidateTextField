//
//  ViewController.swift
//  ExampleProject
//
//  Created by Andrei Hogea on 03/07/2019.
//  Copyright © 2019 Nodes. All rights reserved.
//

import UIKit
import ValidateTextField

class ViewController: UIViewController {

    private var contentStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeContentStackView()
        makeUsernameInputField()
        makePasswordInputField()
    }

    private func makeContentStackView() {
        contentStackView = UIStackView()

        contentStackView.alignment = .fill
        contentStackView.distribution = .fill
        contentStackView.axis = .vertical
        
        view.addSubview(contentStackView)
        
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32).isActive = true
        contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32).isActive = true
    }
    
    private func makeUsernameInputField() {
        let inputUsername = ValidateTextField(contentType: .username,
                                              options: [:])
        
        inputUsername.text = "blabla"
        
        inputUsername.didEndEditing = { textField, text in
            textField.endEditing(true)
        }
        
        contentStackView.addArrangedSubview(inputUsername)
    }
    
    private func makePasswordInputField() {
        let inputPassword = ValidateTextField(contentType: .password,
                                              options: [.assistivePossition: ValidateTextField.AssistiveViewPosition.insideField(verticalAllignment: .center)])
        
        inputPassword.didEndEditing = { textField, text in
            textField.endEditing(true)
        }
        
        let button = UIButton()
        button.setTitle("Bla", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        inputPassword.rightView = button
        
        contentStackView.addArrangedSubview(inputPassword)
        
        inputPassword.validate = { text, resultCallback in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                if text == "1234" {
                    resultCallback(.success)
                } else {
                    resultCallback(.failure("Some password error"))
                }
            }

        }
    }
    
    func validatePassword(_ text: String) -> String? {
            return "Some password error"
    }
}

