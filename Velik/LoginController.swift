//
//  ViewController.swift
//  Velik
//
//  Created by Pavel Borisevich on 13.02.17.
//  Copyright © 2017 Pavel Borisevich. All rights reserved.
//

import UIKit

class LoginController: UIViewController {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var repeatPassword: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var registrationTitle: UINavigationItem!
    
    var isRegestred: Bool = false
    var isLoggedIn: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let defaults : UserDefaults = UserDefaults.standard
        if let regestred = defaults.value(forKey: "isRegestred") as? Bool {
            isRegestred = regestred
            if let loggedIn = defaults.value(forKey: "isLoggedIn") as? Bool {
                isLoggedIn = loggedIn
                
                //MARK - Backendless login if needed
                
            }
            else {
                moveToLogin()
            }
        }
        else {
            userName.isHidden = false
            email.isHidden = false
            password.isHidden = false
            repeatPassword.isHidden = false
            registerButton.isHidden = false
            userName.isEnabled = true
            email.isEnabled = true
            password.isEnabled = true
            repeatPassword.isEnabled = true
            registrationTitle.title = "Registration"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isLoggedIn {
            performSegue(withIdentifier: "tabController", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func registerPressed(_ sender: UIButton) {
        if isRegestred {
            
            //MARK - Backendless login
            
            performSegue(withIdentifier: "tabController", sender: self)
        }
        else {
            
            //MARK - Backendless registration
            
            isRegestred = true
            moveToLogin()
        }
    }
    
    private func moveToLogin() {
        userName.isHidden = false
        email.isHidden = false
        password.isHidden = true
        repeatPassword.isHidden = true
        registerButton.isHidden = false
        userName.isEnabled = true
        email.isEnabled = true
        password.isEnabled = false
        repeatPassword.isEnabled = false
        userName.placeholder = "Login"
        email.placeholder = "Password"
        registrationTitle.title = "Login"
        registerButton.setTitle("Login", for: .normal)
        var buttonFrame = registerButton.frame
        buttonFrame.origin.y -= 76
        registerButton.frame = buttonFrame
    }
    
    deinit {
        print("Goodbye ViewController")
    }
}

