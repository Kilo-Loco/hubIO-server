//
//  EmailValidationExtension.swift
//  hubIO-serverPackageDescription
//
//  Created by Kyle Lee on 1/21/18.
//

import Validation

extension EmailValidator {
    
    func isValid(_ value: String) -> Bool {
        
        do {
            try EmailValidator().validate(value)
            return true
        } catch {
            return false
        }
        
        
    }
    
}
