//
//  StoreViewController.swift
//  Velik
//
//  Created by Pavel Borisevich on 03.04.17.
//  Copyright © 2017 Pavel Borisevich. All rights reserved.
//

import UIKit
import SVProgressHUD

class StoreViewController: UIViewController {
    
    var store: Store?
    var selectedCycle: Cycle?
    
    @IBOutlet weak var infoAboutStore: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoAboutStore.text = store?.information as String?
    }

    override func viewDidAppear(_ animated: Bool) {
        SVProgressHUD.dismiss()
        if store == nil {
            _ = navigationController?.popViewController(animated: true)
            runAlert(title: "Sorry", informativeText: "You need to update map")
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func runAlert(title: String, informativeText: String) {
        let alert = UIAlertController(title: "\(title)\n", message: informativeText, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier, let store = store else { return }
    
        if identifier == "Cycles" {

            let destination = (segue.destination as? CyclesTableViewController)
            destination?.store = store
            destination?.delegate = self
            
            var fault : Fault? = nil
            let storeWithCycles = BackendlessAPI.shared.backendless?.persistenceService.load(store, relations: (["cycles", "geopoint"]), error: &fault) as? Store
            if let cycles = storeWithCycles?.cycles as NSArray? {
                destination?.cycles = (cycles as? [Cycle])?.filter({ (cycle) -> Bool in
                    return cycle.state == 1
                }) ?? [Cycle]()
            }
        }
        
        if identifier == "CycleDetail" {
            let destination = (segue.destination as? CycleViewController)
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
            destination?.navigationItem.title = (selectedCycle?.name as String?)
    
            destination?.cycle = selectedCycle
            destination?.store = store
        }
    }
}

extension StoreViewController: CyclesTableViewControllerDelegate {
    func performToCycleDetail(cycle: Cycle) {
        selectedCycle = cycle
        performSegue(withIdentifier: "CycleDetail", sender: self)
    }
}
