//
//  AbortExtension.swift
//  hubIO-serverPackageDescription
//
//  Created by Kyle Lee on 1/14/18.
//

import HTTP

extension Abort {
    
    static func invalid(_ invalidField: String) -> Abort {
        let reason = "This is an invalid \(invalidField). Please enter a valid \(invalidField) to continue."
        return Abort(.badRequest, reason: reason)
        
    }
    
}
