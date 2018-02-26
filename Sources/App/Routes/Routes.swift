import Vapor
import AuthProvider

extension Droplet {
    
    var tokenMiddleware: RouteBuilder { return grouped(TokenAuthenticationMiddleware(User.self)) }
    
    func setupRoutes() throws {
        let userController = UserController(drop: self)
        userController.addRoutes()
        
        
        
    }
}
