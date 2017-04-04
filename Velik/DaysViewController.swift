//
//  DaysViewController.swift
//  Velik
//
//  Created by Pavel Borisevich on 03.04.17.
//  Copyright © 2017 Pavel Borisevich. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class DaysViewController: UICollectionViewController {

    let green = UIColor.green
    let red = UIColor.red
    var workingDays : [String]!//: UIColor]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //workingDays = ["Mon": green, "Tue": green, "Wed": green, "Thu": green, "Fri": green, "Sat": red, "Sun": red]
        workingDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return workingDays.count
    }

    //MARK - Last Edit (Colors)
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Day", for: indexPath) as? DayCell
        cell?.dayName.text = workingDays[indexPath.row]
        if (workingDays[indexPath.row] == "Sat" || workingDays[indexPath.row] == "Sun") {
            cell?.backgroundColor = red
        }
        else {
            cell?.backgroundColor = green
        }
        return cell ?? UICollectionViewCell()
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
