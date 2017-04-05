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
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var finishTime: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let date = Date()
        let calendar = Calendar.current
        let hours = calendar.component(.hour, from: date)
        let minuts = calendar.component(.minute, from: date)
        
        startTime.text = finishTime.text   //MARK - end of working day
        let startTimeComponents = startTime.text?.components(separatedBy: " : ")
        if hours <= Int(startTimeComponents!.first!)! {
            if minuts <= Int(startTimeComponents!.last!)! {
                let timeInFormat = "\(hours) : "
                startTime.text = timeInFormat.appending(minuts < 10 ? "0\(minuts)" : "\(minuts)")
            }
        }

        workingHoursView.layer.cornerRadius = 12.0
        confirmButton.layer.cornerRadius = 12.0
        startSet.layer.cornerRadius = 5.0
        finishSet.layer.cornerRadius = 5.0
    }

    override func viewDidAppear(_ animated: Bool) {
        if startTime.text == finishTime.text {
            
            //MARK - unwind to Map
            if let mapController = navigationController?.viewControllers.first(where: { (controller) -> Bool in
                controller.isKind(of: MapController.classForCoder())
            }){
                _ = navigationController?.popToViewController(mapController, animated: true)
                runAlert(title: "Sorry", informativeText: "Store is not working now")
            }
        }
    }
    
    private func runAlert(title: String, informativeText: String) {
        let alert = UIAlertController(title: "\(title)\n", message: informativeText, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func setPressed(_ sender: UIButton) {
        let date = Date()
        let datePickerViewController = AIDatePickerController.picker(with: date, selectedBlock: nil, cancel: nil) as? AIDatePickerController
        datePickerViewController?.datePicker.datePickerMode = .time
        datePickerViewController?.datePicker.locale = Locale(identifier: "Belarusian")
        datePickerViewController?.voidBlock = {
            datePickerViewController?.dismiss(animated: true, completion: nil)
        }
        if sender.tag == 1 {
            datePickerViewController?.dateBlock = createDateBlockForPicker(label: startTime, picker: datePickerViewController)
            let calendar = Calendar.current
            var components: DateComponents = DateComponents()
            components.calendar = calendar
            components.hour = calendar.component(.hour, from: date)
            components.minute = calendar.component(.minute, from: date)
            datePickerViewController?.datePicker.minimumDate = calendar.date(from: components)
            components.hour = 18
            components.minute = 0
            datePickerViewController?.datePicker.maximumDate = calendar.date(from: components)
            present(datePickerViewController!, animated: true, completion: nil)
        }
        else {
            datePickerViewController?.dateBlock = createDateBlockForPicker(label: finishTime, picker: datePickerViewController)
            
            let calendar = Calendar.current
            var components: DateComponents = DateComponents()
            components.calendar = calendar
            if let startTimeComponents = startTime.text?.components(separatedBy: " : ") {
                components.hour = Int(startTimeComponents.first!)!
                components.minute = Int(startTimeComponents.last!)!
                datePickerViewController?.datePicker.minimumDate = calendar.date(from: components)
            }
            components.hour = 18
            components.minute = 0
            datePickerViewController?.datePicker.maximumDate = calendar.date(from: components)
            present(datePickerViewController!, animated: true, completion: nil)
        }
    }
    
    private func createDateBlockForPicker(label: UILabel, picker: AIDatePickerController?) -> ((Date?) -> Void) {
        let block: ((Date?) -> Void) = { [weak label, picker] (date) in
            if let date = date {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "H : mm"
                label?.text = dateFormatter.string(from: date)
                picker?.dismiss(animated: true, completion: nil)
            }
        }
        return block
    }

    @IBAction func confirmPressed(_ sender: UIButton) {
        //MARK - Unwind segue
    }
}
