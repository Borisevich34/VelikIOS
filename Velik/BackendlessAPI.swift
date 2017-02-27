//
//  BackendlessAPI.swift
//  Velik
//
//  Created by Pavel Borisevich on 13.02.17.
//  Copyright © 2017 Pavel Borisevich. All rights reserved.
//

import Foundation
class BackendlessAPI {
    //Managers
    let APP_ID = "204914E5-38EB-6319-FF36-0C1EE7666C00"
    let SECRET_KEY = "A70D8623-F44E-D1B6-FF27-4132A62F6900"
    let VERSION_NUM = "v1"
    
    var backendless = Backendless.sharedInstance()
    var shared = BackendlessAPI()
    
    init() {
        backendless?.initApp(APP_ID, secret: SECRET_KEY, version: VERSION_NUM)
        
        
        //backendless?.userService.registering(user)
        
        // If you plan to use Backendless Media Service, uncomment the following line (iOS ONLY!)
        // backendless.mediaService = MediaService()
    }
    
    func registerUserWithEmail(email: String, password: String) -> Bool {
        let user: BackendlessUser = BackendlessUser()
        user.email = email as NSString
        user.password = password as NSString
        
        return true
    }
    

    
}
