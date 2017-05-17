//
//  CompletedOrdersViewCell.swift
//  Velik
//
//  Created by Pavel Borisevich on 21.04.17.
//  Copyright © 2017 Pavel Borisevich. All rights reserved.
//

import UIKit

class CompletedOrdersViewCell: UITableViewCell {

    @IBOutlet weak var cycleLabel: UILabel!
    @IBOutlet weak var timePeriodLabel: UILabel!
    @IBOutlet weak var cycleImage: UIImageView!
    @IBOutlet weak var pricePerOrder: UILabel!
    @IBOutlet weak var showPlaceButton: UIButton!
    @IBOutlet weak var hudView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        showPlaceButton.layer.cornerRadius = 5.0
    }
}
