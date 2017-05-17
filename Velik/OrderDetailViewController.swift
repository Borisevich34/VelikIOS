//
//  OrderDetailViewController.swift
//  Velik
//
//  Created by Pavel Borisevich on 29.04.17.
//  Copyright © 2017 Pavel Borisevich. All rights reserved.
//

import UIKit
import MBProgressHUD

class OrderDetailViewController: UIViewController {
    
    weak var cycle: Cycle?
    
    var countOfSuccessfulResponses = 0
    var countOfFailedResponses = 0
    
    var callback: ((UIImage?) -> (Void))?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pagesControl: UIPageControl!
    @IBOutlet weak var pricePerHour: UILabel!
    @IBOutlet weak var cycleInfoTextView: UITextView!
    
    @IBOutlet var collectionOfimages: [UIImageView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        callback = { [weak self] (image) in
            if let image = image {
                if let countOfSuccessfulResponses = self?.countOfSuccessfulResponses, let view = self?.collectionOfimages[countOfSuccessfulResponses] {
                    MBProgressHUD.hide(for: view, animated: true)
                    self?.collectionOfimages[countOfSuccessfulResponses].image = image
                    self?.countOfSuccessfulResponses += 1
                }
            }
            else {
                if let countOfFailedResponses = self?.countOfFailedResponses, let view = self?.collectionOfimages[2 - countOfFailedResponses] {
                    MBProgressHUD.hide(for: view, animated: true)
                    self?.collectionOfimages[2 - countOfFailedResponses].image = UIImage(named: "NoImageAvailible")
                    self?.countOfFailedResponses += 1
                }
            }
        }
        
        collectionOfimages.forEach { (view) in
            MBProgressHUD.showAdded(to: view, animated: true)
        }
        
        var isImagesMissing = true
        if let cycle = cycle {
            isImagesMissing = !ImagesHelper.shared.downloadImagesOfCycle(cycle, callback: callback)
        }
        if isImagesMissing {
            collectionOfimages.forEach { (view) in
                MBProgressHUD.hide(for: view, animated: true)
            }
        }
        
        cycleInfoTextView.text = (cycle?.information as String?)
        pricePerHour.text = "Price per hour = \(cycle?.pricePerHour?.intValue ?? 0)$"
        
        scrollView.delegate = self
    }
}

extension OrderDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pagesControl.currentPage = Int(scrollView.contentOffset.x/scrollView.frame.width + 0.5)
    }
}

