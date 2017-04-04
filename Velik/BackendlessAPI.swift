//
//  BackendlessAPI.swift
//  Velik
//
//  Created by Pavel Borisevich on 13.02.17.
//  Copyright © 2017 Pavel Borisevich. All rights reserved.
//

import Foundation
class BackendlessAPI {
    
    let APP_ID = "204914E5-38EB-6319-FF36-0C1EE7666C00"
    let SECRET_KEY = "A70D8623-F44E-D1B6-FF27-4132A62F6900"
    let VERSION_NUM = "v1"
    
    var backendless = Backendless.sharedInstance()
    static var shared = BackendlessAPI()
    
    init() {
        backendless?.initApp(APP_ID, secret: SECRET_KEY, version: VERSION_NUM)
    }
    
    func syncRegisterUserWithProperties(_ properties: [String : Any]) -> Fault? {
        
        var fault : Fault? = nil
        let user = BackendlessUser(properties: properties)
        _ = backendless?.userService.registering(user, error: &fault)
    
        return fault
    }
    
    func syncLoginUser(email: String, password: String) -> Fault? {
        var fault : Fault? = nil
        guard (backendless?.userService.login(email, password: password, error: &fault)) != nil else {
            return fault
        }
        backendless?.userService.setStayLoggedIn(true)
        return fault
    }
    
    func setNeedToStayLogged(_ needToStayLogged: Bool) {
        backendless?.userService.setStayLoggedIn(true)
    }
    func isNeedToStayLogged() -> Bool? {
        return backendless?.userService.isStayLoggedIn
    }
    
    func userLogout() {
        var logoutFault : Fault? = nil
        _ = backendless?.userService.logoutError(&logoutFault)
    }
}
