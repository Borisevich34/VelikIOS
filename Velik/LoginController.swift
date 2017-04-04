//
//  ViewController.swift
//  Velik
//
//  Created by Pavel Borisevich on 13.02.17.
//  Copyright © 2017 Pavel Borisevich. All rights reserved.
//

//borisevich_pavel@bk.ru
//Borisevich34

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
    
    override func viewWillAppear(_ animated: Bool) {
        if isLoggedIn {
            performSegue(withIdentifier: "tabController", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func donePressed(_ sender: Any) {
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        if isRegestred {
            
            if let fault = BackendlessAPI.shared.syncLoginUser(email: userName.text ?? "", password: email.text ?? "") {
                runAlert(title: "Login error", informativeText: fault.message ?? "Can't login, please try again")
            }
            else {
                performSegue(withIdentifier: "tabController", sender: self)
            }
        }
        else {
            //MARK - add properties
            var properties = [String : Any]()
            properties["name"] = userName.text ?? ""
            properties["password"] = password.text ?? ""
            properties["email"] = email.text ?? ""
            if let fault = BackendlessAPI.shared.syncRegisterUserWithProperties(properties) {
                runAlert(title: "Registration error", informativeText: fault.message ?? "Can't register, please try again")
            }
            else {
                let defaults = UserDefaults.standard
                defaults.set(true, forKey: "isRegestred")
                defaults.synchronize()
                isRegestred = true
                moveToLogin()
            }
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
    
    private func runAlert(title: String, informativeText: String) {
        let alert = UIAlertController(title: "\(title)\n", message: informativeText, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    deinit {
        print("Goodbye ViewController")
    }
}

