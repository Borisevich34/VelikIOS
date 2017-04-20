//
//  CycleViewController.swift
//  Velik
//
//  Created by Pavel Borisevich on 04.04.17.
//  Copyright © 2017 Pavel Borisevich. All rights reserved.
//

import UIKit
import MBProgressHUD

class CycleViewController: UIViewController {

    weak var cycle: Cycle?
    weak var store: Store?

    var countOfSuccessfulResponses = 0
    var countOfFailedfulResponses = 0
    
    @IBOutlet weak var makeOrderButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pagesControl: UIPageControl!
    @IBOutlet weak var pricePerHour: UILabel!
    @IBOutlet weak var cycleInfoTextView: UITextView!
    
    @IBOutlet var collectionOfimages: [UIImageView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionOfimages.forEach { (view) in
            MBProgressHUD.showAdded(to: view, animated: true)
        }
        
        var isImagesMissing = true
        if let store = store, let cycle = cycle {
            ImagesHelper.shared.delegate = self
            isImagesMissing = !ImagesHelper.shared.downloadImagesOfCycle(cycle, fromStore: store)
        }
        if isImagesMissing {
            collectionOfimages.forEach { (view) in
                MBProgressHUD.hide(for: view, animated: true)
            }
        }
        
        cycleInfoTextView.text = (cycle?.information as String?)
        pricePerHour.text = "Price per hour = \(cycle?.pricePerHour?.intValue ?? 0)$"
        
        makeOrderButton.layer.cornerRadius = 12.0
        scrollView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        if identifier == "Order" {
            let destination = (segue.destination as? OrderViewController)
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
            destination?.cycle = cycle
            destination?.store = store
        }
    }
}

extension CycleViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pagesControl.currentPage = Int(scrollView.contentOffset.x/scrollView.frame.width + 0.5)
    }
}

extension CycleViewController: ImageHelperDelegate {
    func addImage(_ image: UIImage?) {
        if let image = image {
            MBProgressHUD.hide(for: collectionOfimages[countOfSuccessfulResponses], animated: true)
            collectionOfimages[countOfSuccessfulResponses].image = image
            countOfSuccessfulResponses += 1
        }
        else {
            MBProgressHUD.hide(for: collectionOfimages[2 - countOfFailedfulResponses], animated: true)
            collectionOfimages[2 - countOfFailedfulResponses].image = UIImage(named: "NoImageAvailible")
            countOfFailedfulResponses += 1
        }
    }
}
