//
//  InitialViewController.swift
//  Velik
//
//  Created by Pavel Borisevich on 08.05.17.
//  Copyright © 2017 Pavel Borisevich. All rights reserved.
//

import Foundation

class InitialViewController: UIViewController {

    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        if let isLoggedIn = defaults.value(forKey: "isLoggedIn") as? Bool, isLoggedIn {
            guard let email = defaults.value(forKey: "email") as? String,
                let password = defaults.value(forKey: "password") as? String else { return }
            if let fault = BackendlessAPI.shared.syncLoginUser(email: email, password: password) {
                runAlert(title: "Login error", informativeText: fault.message ?? "Please check your internet connection")
            }
            else {
                openTabBarController()
            }
        }
        else {
            loginButton.isHidden = false
            loginButton.layer.cornerRadius = 12.0
            signupButton.isHidden = false
            signupButton.layer.cornerRadius = 12.0
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
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
    
    private func runAlert(title: String, informativeText: String) {
        let alert = UIAlertController(title: "\(title)\n", message: informativeText, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
