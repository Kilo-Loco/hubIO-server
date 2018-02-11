//
//  NameValidation.swift
//  hubIO-serverPackageDescription
//
//  Created by Kyle Lee on 1/21/18.
//

import Foundation
import Validation

internal final class NameValidation: FieldLengthValidation {
    
    private let validCharacters = "abcdefghijklmnopqrstuvwxyz0123456789 "
    
    internal override func isValid(_ value: String) -> Bool {
        guard super.isValid(value) else { return false }
        
        var charactersAreValid = true
        
        value.lowercased().forEach { [weak self] character in
            guard
                let strongSelf = self,
                !strongSelf.validCharacters.contains(character)
                else { return }
            charactersAreValid = false
        }
        
        let noDoubleSpacing = !value.contains("  ")
        
        return charactersAreValid && noDoubleSpacing
    }
    
}




