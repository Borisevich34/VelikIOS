//
//  CycleViewController.swift
//  Velik
//
//  Created by Pavel Borisevich on 04.04.17.
//  Copyright © 2017 Pavel Borisevich. All rights reserved.
//

import UIKit

class CycleViewController: UIViewController {

    weak var cycle: Cycle?
    @IBOutlet weak var makeOrderButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pagesControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK - number of pages depends from Backendless side
        //pagesControl.numberOfPages = 3
        //pagesControl.currentPage = 0
        makeOrderButton.layer.cornerRadius = 12.0
        scrollView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension CycleViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pagesControl.currentPage = Int(scrollView.contentOffset.x/scrollView.frame.width + 0.5)
    }
}
