//
//  DayCell.swift
//  Velik
//
//  Created by Pavel Borisevich on 03.04.17.
//  Copyright © 2017 Pavel Borisevich. All rights reserved.
//

import UIKit

class DayCell: UICollectionViewCell {
    private var isWorking = true
    @IBOutlet weak var dayName: UILabel!
    var isWorkingDay: Bool {
        get {
            return isWorking
        }
        set {
            if newValue {
                backgroundColor = UIColor.green
            }
            else {
                backgroundColor = UIColor.red
            }
            isWorking = newValue
        }
    }
}
