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

class RegistrationViewController: UIViewController {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var repeatPassword: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false
        registerButton.layer.cornerRadius = 12.0
    }
    
    @IBAction func donePressed(_ sender: Any) {
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        var properties = [String : Any]()
        properties["name"] = userName.text ?? ""
        properties["password"] = password.text ?? ""
        properties["email"] = email.text ?? ""
        if let fault = BackendlessAPI.shared.syncRegisterUserWithProperties(properties) {
            runAlert(title: "Registration error", informativeText: fault.message ?? "Can't register, please try again")
        }
        else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func runAlert(title: String, informativeText: String) {
        let alert = UIAlertController(title: "\(title)\n", message: informativeText, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    deinit {
        print("Goodbye RegistrationViewController")
    }
}

