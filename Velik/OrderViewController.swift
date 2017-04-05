//
//  MakeOrderViewController.swift
//  Velik
//
//  Created by Pavel Borisevich on 04.04.17.
//  Copyright © 2017 Pavel Borisevich. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController {

    @IBOutlet weak var workingHoursView: UIView!
    @IBOutlet weak var startSet: UIButton!
    @IBOutlet weak var finishSet: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        workingHoursView.layer.cornerRadius = 12.0
        confirmButton.layer.cornerRadius = 12.0
        startSet.layer.cornerRadius = 5.0
        finishSet.layer.cornerRadius = 5.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func setPressed(_ sender: UIButton) {
        if sender.tag == 1 {
            //start
        }
        else {
            //finish
        }
    }
    
    @IBAction func confirmPressed(_ sender: UIButton) {
        //Unwind segue
    }
}
