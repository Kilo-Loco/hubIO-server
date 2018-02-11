//
//  FieldLengthValidation.swift
//  hubIO-serverPackageDescription
//
//  Created by Kyle Lee on 1/14/18.
//

import Foundation
import Validation

class FieldLengthValidation: Validatable {
    
    private let minimumLength: Int
    private let maximumLength: Int
    
    init(min: Int = 3, max: Int = 30) {
        minimumLength = min
        maximumLength = max
    }
    
    func isValid(_ value: String) -> Bool {
        do {
            try value.validated(by: Count.min(minimumLength) && Count.max(maximumLength))
            return true
        } catch {
            return false
        }
    }
    
}
