//
//  User.swift
//  hubIO-serverPackageDescription
//
//  Created by Kyle Lee on 1/7/18.
//

import Vapor
import FluentProvider
import Validation
import AuthProvider

final class User: Model {
    let storage = Storage()
    
    var username: String
    var password: String
    let fullName: String
    let email: String
    var avatarName: String
    
    struct Keys {
        static let id           = "id"
        static let username     = "username"
        static let password     = "password"
        static let fullName     = "fullName"
        static let avatarName   = "avatarName"
        static let email        = "email"
    }
    
    
    init(username: String, password: String, fullName: String, avatarName: String, email: String) {
        
        self.username = username
        self.password = password
        self.fullName = fullName
        self.avatarName = avatarName
        self.email = email
    }
    
    init(json: JSON, drop: Droplet) throws {
        let fieldValidation = FieldLengthValidation()
        let nameValidation = NameValidation()
        
        guard
            let username: String = try json.get(Keys.username),
            nameValidation.isValid(username)
            else { throw Abort.invalid("username") }
        
        guard
            try User.makeQuery().filter(Keys.username, username).first() == nil
            else { throw Abort(.badRequest, reason: "That username is taken. Please try another.") }
        
        guard
            let password: String = try json.get(Keys.password),
            fieldValidation.isValid(password)
            else { throw Abort.invalid("password") }
        
        guard
            let fullName: String = try json.get(Keys.fullName),
            nameValidation.isValid(fullName)
            else { throw Abort.invalid("full name") }
        
        guard
            let avatarName: String = try json.get(Keys.avatarName),
            fieldValidation.isValid(avatarName)
            else { throw Abort(.badRequest, reason: "There was a problem with the image. Please try again.") }
        
        guard
            let email: String = try json.get(Keys.email),
            EmailValidator().isValid(email)
            else { throw Abort.invalid("email address") }
        
        self.username = username
        self.password = password
        self.fullName = fullName
        self.avatarName = avatarName
        self.email = email
    }
    
    
    
    init(row: Row) throws {
        self.username = try row.get(Keys.username)
        self.password = try row.get(Keys.password)
        self.fullName = try row.get(Keys.fullName)
        self.avatarName = try row.get(Keys.avatarName)
        self.email = try row.get(Keys.email)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Keys.username, self.username)
        try row.set(Keys.password, self.password)
        try row.set(Keys.fullName, self.fullName)
        try row.set(Keys.avatarName, self.avatarName)
        try row.set(Keys.email, self.email)
        return row
    }
}

extension User: JSONRepresentable {
    
    internal func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Keys.id, id?.wrapped)
        try json.set(Keys.username, username)
        try json.set(Keys.fullName, fullName)
        try json.set(Keys.avatarName, avatarName)
        try json.set(Keys.email, email)
        return json
    }
    
}

extension User: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Keys.username)
            builder.string(Keys.password)
            builder.string(Keys.fullName)
            builder.string(Keys.avatarName)
            builder.string(Keys.email)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
    
}

extension User: TokenAuthenticatable {
    public typealias TokenType = AccessToken
}

extension Request {
    func user() throws -> User {
        return try auth.assertAuthenticated()
    }
}




