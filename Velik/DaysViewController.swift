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

    let green = UIColor.init(red: 128.0/255.0, green: 1.0, blue: 0.0, alpha: 0.62)
    let red = UIColor.init(red: 1.0, green: 50.0/255.0, blue: 50.0/255.0, alpha: 0.62)
    var days: [(dayName: String, isWorking: Bool)]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        days = [("Mon", true), ("Tue", true), ("Wed", true), ("Thu", true), ("Fri", true), ("Sat", false), ("Sun", false)]

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return days.count
    }

    //MARK - Last Edit (Colors)
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Day", for: indexPath) as? DayCell
        cell?.layer.cornerRadius = 5.0
        cell?.dayName.text = days[indexPath.row].dayName
        days[indexPath.row].isWorking ? (cell?.backgroundColor = green) : (cell?.backgroundColor = red)
        return cell ?? UICollectionViewCell()
    }
}
