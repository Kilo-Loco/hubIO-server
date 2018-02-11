//
//  UserController.swift
//  hubIO-serverPackageDescription
//
//  Created by Kyle Lee on 1/21/18.
//

import Vapor

internal struct UserController {
    
    private var drop: Droplet
    
    internal init(drop: Droplet) {
        self.drop = drop
    }
    
    internal func addRoutes() {

        let group = drop.grouped("api", "users")
        group.get(handler: getAllUsers)
        group.post(handler: createUser)
        
    }
    
    private func getAllUsers(_ request: Request) throws -> ResponseRepresentable {
        let users = try User.all()
        return try users.makeJSON()
    }
    
    private func createUser(_ request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else { throw Abort.badRequest }
        
        let user = try User(json: json, drop: drop)
        try user.save()
        
        return try user.makeJSON()
    }
    
    
}
