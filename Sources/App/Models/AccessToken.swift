//
//  AccessToken.swift
//  hubIO-serverPackageDescription
//
//  Created by Kyle Lee on 2/18/18.
//

import Vapor
import FluentProvider
import Crypto

final class AccessToken: Model {
    let storage = Storage()
    let token: String
    let userId: Identifier
    
    struct Keys {
        static let token = "token"
        static let userId = "userId"
    }
    
    init(token: String, userId: Identifier) {
        self.token = token
        self.userId = userId
    }
    
    init(row: Row) throws {
        token = try row.get(Keys.token)
        userId = try row.get(Keys.userId)
        
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Keys.token, token)
        try row.set(Keys.userId, userId)
        return row
    }
}

extension AccessToken {
    var user: Parent<AccessToken, User> {
        return parent(id: userId)
    }
    
    static func generate(for user: User) throws -> AccessToken {
        guard let userId = user.id else { throw Abort.badRequest }
        let random = try Crypto.Random.bytes(count: 16)
        return AccessToken(token: random.base64Encoded.makeString(), userId: userId)
        
    }
}

extension AccessToken: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Keys.token, optional: false, unique: true)
            builder.parent(User.self)
            
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension AccessToken: JSONRepresentable {
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Keys.token, token)
        return json
    }
}

extension AccessToken: Timestampable {}
extension AccessToken: ResponseRepresentable {}














