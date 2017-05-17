//
//  LoginViewController.swift
//  Velik
//
//  Created by Pavel Borisevich on 08.05.17.
//  Copyright © 2017 Pavel Borisevich. All rights reserved.
//

import Foundation

class LoginViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false
        loginButton.layer.cornerRadius = 12.0
    }
    
    @IBAction func donePressed(_ sender: Any) {
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        if let fault = BackendlessAPI.shared.syncLoginUser(email: email.text ?? "", password: password.text ?? "") {
            runAlert(title: "Login error", informativeText: fault.message ?? "Please check your internet connection")
        }
        else {
            saveLoginAndPassword()
            openTabBarController()
        }
    }
    
    private func runAlert(title: String, informativeText: String) {
        let alert = UIAlertController(title: "\(title)\n", message: informativeText, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func saveLoginAndPassword() {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "isLoggedIn")
        defaults.set(email.text ?? "", forKey: "email")
        defaults.set(password.text ?? "", forKey: "password")
        defaults.synchronize()
    }
    
    private func openTabBarController() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
        let snapshot : UIView = (UIApplication.shared.keyWindow?.snapshotView(afterScreenUpdates: true))!
        viewController.view.addSubview(snapshot)
        UIApplication.shared.keyWindow?.rootViewController = viewController
        
        UIView.animate(withDuration: 0.8, delay: 0.1, options: .transitionCrossDissolve, animations: {
            snapshot.alpha = 0
        }) { (value: Bool) in
            snapshot.removeFromSuperview()
        }
    }
}
