//
//  RadiusViewController.swift
//  Velik
//
//  Created by Pavel Borisevich on 03.04.17.
//  Copyright © 2017 Pavel Borisevich. All rights reserved.
//

import UIKit
import MMNumberKeyboard

class RadiusViewController: UIViewController, MMNumberKeyboardDelegate {
    
    weak var previousController: MapController?

    @IBOutlet weak var radiusView: UIView!
    @IBOutlet weak var radiusField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        radiusView.layer.cornerRadius = 10.0
        cancelButton.layer.cornerRadius = 8.0
        let keyboard = MMNumberKeyboard(frame: CGRect.zero)
        keyboard.allowsDecimalPoint = true
        keyboard.delegate = self
        
        radiusField.inputView = keyboard
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func radiusChanged(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func numberKeyboardShouldReturn(_ numberKeyboard: MMNumberKeyboard!) -> Bool {
        if let text = self.radiusField?.text, let radius: Double = Double(text) {
            self.previousController?.radius = Int(radius)
        }
        dismiss(animated: true, completion: nil)
        return true
    }
}
