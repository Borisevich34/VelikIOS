//
//  CompletedOrders.swift
//  Velik
//
//  Created by Pavel Borisevich on 21.04.17.
//  Copyright © 2017 Pavel Borisevich. All rights reserved.
//

import UIKit
import SVProgressHUD

class CompletedOrdersViewController: UITableViewController {
    
    var cycles = [Cycle]()
    var indexOfSelectedCell = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.allowsMultipleSelection = false
        self.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: UIControlEvents.valueChanged)
    }

    func handleRefresh() {
        updateTable(withHud: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateTable(withHud: true)
    }
    
    @IBAction func updatePressed(_ sender: UIBarButtonItem) {
        updateTable(withHud: true)
    }
    
    private func updateTable(withHud: Bool) {
        var isNeedToHideHUD = false
        if withHud {
            SVProgressHUD.show()
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [weak self] _ in
                if isNeedToHideHUD {
                    SVProgressHUD.dismiss()
                    self?.tableView.reloadData()
                }
                else {
                    isNeedToHideHUD = true
                }
            }
        }
        DispatchQueue.global().async { [weak self] in
            var fault: Fault? = nil
            let currentUser = BackendlessAPI.shared.backendless?.userService.currentUser
            let userWithLoadedCycles = BackendlessAPI.shared.backendless?.persistenceService.load(currentUser, relations: ["cycles"], error: &fault) as? BackendlessUser
            
            DispatchQueue.main.sync {
                if let loadedCycles = userWithLoadedCycles?.getProperty("cycles") as? [Cycle] {
                    self?.cycles = loadedCycles
                }
                if withHud {
                    if isNeedToHideHUD {
                        SVProgressHUD.dismiss()
                        self?.tableView.reloadData()
                    }
                    else {
                        isNeedToHideHUD = true
                    }
                }
                else {
                    self?.tableView.reloadData()
                    self?.refreshControl?.endRefreshing()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        if identifier == "Place" {
            (segue.destination as? PlaceController)?.location = (cycles[indexOfSelectedCell].location as String?)
        }
        else if identifier == "Bicycle" {
            (segue.destination as? OrderDetailViewController)?.cycle = cycles[indexOfSelectedCell]
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cycles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Order", for: indexPath) as? CompletedOrdersViewCell
        cell?.cycleLabel.text = cycles[indexPath.row].name as String?
        if let timePeriod = cycles[indexPath.row].timePeriod?.intValue {
            cell?.pricePerOrder.text = String(format: "Price of order %.2f$", (Float(timePeriod) / 60.0) * (cycles[indexPath.row].pricePerHour?.floatValue ?? 0.0))
            let orderTimeComponents = (cycles[indexPath.row].orderTime as String?)?.components(separatedBy: " : ")
            let firstTimeComponent = Int(orderTimeComponents!.first!)!
            let secondTimeComponent = Int(orderTimeComponents!.last!)!
            
            cell?.timePeriodLabel.text = "Time period \(firstTimeComponent):\(secondTimeComponent < 10 ? "0\(secondTimeComponent)" : "\(secondTimeComponent)") - \(firstTimeComponent + (secondTimeComponent + timePeriod) / 60) : \(((secondTimeComponent + timePeriod) % 60) < 10 ? "0\((secondTimeComponent + timePeriod) % 60)" : "\((secondTimeComponent + timePeriod) % 60)")"
            
        }
        if let cell = cell {
            ImagesHelper.shared.loadImageToCell(cell, fromCycle: cycles[indexPath.row])
            return cell
        }
        else {
            return UITableViewCell()
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexOfSelectedCell = indexPath.row
        tableView.cellForRow(at: indexPath)?.isSelected = false
        performSegue(withIdentifier: "Bicycle", sender: self)
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == .delete) {
            let cycle = cycles[indexPath.row]
            cycle.location = nil
            cycle.state = NSNumber(value: 0)
            cycle.orderTime = nil
            cycle.timePeriod = nil
            
            var fault: Fault? = nil
            if BackendlessAPI.shared.backendless?.persistenceService.update(cycle, error: &fault) != nil, let channel = (cycle.storeId as String?) {
                print(fault?.message ?? "Success")
                _ = BackendlessAPI.shared.backendless?.messagingService.publish(channel, message: "Cancel Order", error: &fault)
            }
            
            cycles.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
