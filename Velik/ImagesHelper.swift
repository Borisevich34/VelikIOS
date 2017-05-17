//
//  ImagesHelper.swift
//  Velik
//
//  Created by Pavel Borisevich on 20.04.17.
//  Copyright © 2017 Pavel Borisevich. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

class ImagesHelper {

    static var shared = ImagesHelper()
    
    private let imageNames = ["firstImage.png", "secondImage.png", "thirdImage.png"]
    
    func downloadImagesOfCycle(_ cycle: Cycle, fromStore store: Store, callback: ((UIImage?) -> (Void))?) -> Bool {
        guard let storeId = (store.objectId as String?), let cycleId = (cycle.objectId as String?) else { return false }
        let pathToDirectory = createPathToDirectory(storeId: storeId, cycleId: cycleId)
        imageNames.forEach { (name) in
            loadImageWithDirectoryPath(pathToDirectory, andImageName: name, callback: callback)
        }
        return true
    }
    
    func downloadImagesOfCycle(_ cycle: Cycle, callback: ((UIImage?) -> (Void))?) -> Bool {
        guard let cycleId = (cycle.objectId as String?), let storeId = (cycle.storeId as String?) else { return false }
        let pathToDirectory = createPathToDirectory(storeId: storeId, cycleId: cycleId)
        imageNames.forEach { (name) in
            loadImageWithDirectoryPath(pathToDirectory, andImageName: name, callback: callback)
        }
        return true
    }
    
    func loadImageToCell( _ cell: CompletedOrdersViewCell, fromCycle cycle: Cycle) {
        guard let cycleId = (cycle.objectId as String?), let storeId = (cycle.storeId as String?) else { return }
        let pathToDirectory = createPathToDirectory(storeId: storeId, cycleId: cycleId)
        MBProgressHUD.showAdded(to: cell.hudView, animated: true)
        loadImagesConsistently(directoryPath: pathToDirectory, imageIndex: 0, cell: cell)
    }
    
    private func createPathToDirectory(storeId: String, cycleId: String) -> String {
        let pathToFiles = "https://api.backendless.com/204914E5-38EB-6319-FF36-0C1EE7666C00/v1/files/"
        return pathToFiles.appending("images/store_\(storeId)/cycle_\(cycleId)/")
    }
    
    private func loadImageWithDirectoryPath(_ path: String, andImageName name: String, callback: ((UIImage?) -> (Void))?) {
        var image: UIImage? = nil
        let url = URL(string: path.appending(name))
        let request = URLRequest(url: url!)
        let downloadTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if error == nil, let data = data {
                image = UIImage(data: data)
            }
            else {
                print(error.debugDescription)
            }
            DispatchQueue.main.sync {
                callback?(image)
            }
        })
        downloadTask.resume()
    }
    
    private func loadImagesConsistently(directoryPath: String, imageIndex: Int, cell: CompletedOrdersViewCell?) {
        weak var orderCell = cell
        var image: UIImage? = nil
        let url = URL(string: directoryPath.appending(imageNames[imageIndex]))
        let request = URLRequest(url: url!)
        let downloadTask = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
            DispatchQueue.main.sync {
                if error == nil, let data = data {
                    image = UIImage(data: data)
                    if let strongCell = orderCell {
                        MBProgressHUD.hide(for: strongCell.hudView, animated: true)
                        strongCell.cycleImage?.image = image
                    }
                }
                else if imageIndex < (self?.imageNames.count ?? 0) - 1 {
                    self?.loadImagesConsistently(directoryPath: directoryPath, imageIndex: imageIndex + 1, cell: orderCell)
                } else {
                    orderCell?.cycleImage?.image = UIImage(named: "NoImageAvailible")
                }
            }
        })
        downloadTask.resume()
    }
}
