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
        group.post(handler: signUp)
        group.post("signIn", handler: signIn)
        
        let secureGroup = drop.tokenMiddleware.grouped("api", "users")
        secureGroup.get(handler: getAllUsers)
    }
    
    private func getAllUsers(_ request: Request) throws -> ResponseRepresentable {
        let users = try User.all()
        return try users.makeJSON()
    }
    
    private func signUp(_ request: Request) throws -> ResponseRepresentable {
        guard
            let json = request.json
            
            else { throw Abort.badRequest }
        
        let user = try User(json: json, drop: drop)
        try user.save()
        
        let token = try AccessToken.generate(for: user)
        try token.save()
        
        var responseJson = JSON()
        try responseJson.set("user", user.makeJSON())
        try responseJson.set("token", token.token)
        
        return responseJson
    }
    
    private func signIn(_ request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else { throw Abort.badRequest }
        
        let username: String = try json.get(User.Keys.username)
        let password: String = try json.get(User.Keys.password)
        
        let users = try User.makeQuery().filter(User.Keys.username, username)
        
        guard
            let user = try users.first(),
            user.password == password
            else { throw Abort(.badRequest, reason: "Hey dumbass, try again!") }
        
        let token = try AccessToken.generate(for: user)
        try token.save()
        
        var responseJson = JSON()
        try responseJson.set("user", user.makeJSON())
        try responseJson.set("token", token.token)
        
        return responseJson
    }
    
    
}











