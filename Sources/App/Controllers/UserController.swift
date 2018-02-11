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
        group.post(handler: signUp)
        group.post("signIn", handler: signIn)
        
    }
    
    private func getAllUsers(_ request: Request) throws -> ResponseRepresentable {
        let users = try User.all()
        return try users.makeJSON()
    }
    
    private func signUp(_ request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else { throw Abort.badRequest }
        
        let user = try User(json: json, drop: drop)
        try user.save()
        
        return try user.makeJSON()
    }
    
    private func signIn(_ request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else { throw Abort.badRequest }
        
        let username: String = try json.get(User.Keys.username)
        let password: String = try json.get(User.Keys.password)
        
        let users = try User.makeQuery().filter(User.Keys.username, username)
        
        // FIND WAY TO MAKE SEARCH CASE INSENSITIVE
        
//        let users = try User.database?.raw("SELECT * FROM `users` WHERE username LIKE '\(username)'")
        
        guard
            let user = try users.first(),
            user.password == password
            else { throw Abort(.badRequest, reason: "Hey dumbass, try again!") }
        //invalid username or password
        
        return try user.makeJSON()
    }
    
    
}











