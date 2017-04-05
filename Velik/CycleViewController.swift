//
//  CycleViewController.swift
//  Velik
//
//  Created by Pavel Borisevich on 04.04.17.
//  Copyright © 2017 Pavel Borisevich. All rights reserved.
//

import UIKit

class CycleViewController: UIViewController {

    weak var cycle: Cycle?
    @IBOutlet weak var makeOrderButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeOrderButton.layer.cornerRadius = 12.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
