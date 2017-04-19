//
//  CyclesTableViewController.swift
//  Velik
//
//  Created by Pavel Borisevich on 04.04.17.
//  Copyright © 2017 Pavel Borisevich. All rights reserved.
//

import UIKit

protocol CyclesTableViewControllerDelegate: class {
    func performToCycleDetail(cycle: Cycle)
}

class CyclesTableViewController: UITableViewController {

    weak var store: Store?
    var cycles = [Cycle]()
    weak var delegate: CyclesTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: UIControlEvents.valueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    public func handleRefresh() {
        DispatchQueue.global().async { [weak self] in
            if let store = self?.store {
                var fault : Fault? = nil
                let storeWithCycles = BackendlessAPI.shared.backendless?.persistenceService.load(store, relations: (["cycles"]), error: &fault) as? Store
                if let cyclesFromRequest = storeWithCycles?.cycles as NSArray? {
                    self?.cycles = (cyclesFromRequest as? [Cycle])?.filter({ (cycle) -> Bool in
                        return cycle.state == 1
                    }) ?? [Cycle]()
                }
            }
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
                self?.refreshControl?.endRefreshing()
            }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cycle", for: indexPath) as? CycleCell

        cell?.nameOfCycle.text = cycles[indexPath.row].name as String?
        return cell ?? UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath)
        selectedCell?.isSelected = false
        do {
            let cycle = try cycles[indexPath.row]
            delegate?.performToCycleDetail(cycle: cycle)
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
