//
//  ValidationError.swift
//  ValidateTextField
//
//  Created by Andrei Hogea on 04/07/2019.
//  Copyright © 2019 Nodes. All rights reserved.
//

import Foundation

public enum ValidationResult {
    case success
    /// Provide an error message or nil if you want no error message to be displayed and just apply error styling
    case failure(String?)
}
