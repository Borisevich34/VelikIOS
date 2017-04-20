//
//  ImagesHelper.swift
//  Velik
//
//  Created by Pavel Borisevich on 20.04.17.
//  Copyright © 2017 Pavel Borisevich. All rights reserved.
//

import Foundation

protocol ImageHelperDelegate: class {
    func addImage(_ image: UIImage?)
}

class ImagesHelper {
    
    static var shared = ImagesHelper()
    weak var delegate: ImageHelperDelegate?
    
    func downloadImagesOfCycle(_ cycle: Cycle, fromStore store: Store) -> Bool {
        guard let storeId = (store.objectId as String?), let cycleId = (cycle.objectId as String?) else { return false }
        let pathToFiles = "https://api.backendless.com/204914E5-38EB-6319-FF36-0C1EE7666C00/v1/files/"
        let pathToDirectory = pathToFiles.appending("images/store_\(storeId)/cycle_\(cycleId)/")
        
        loadImageWithDirectoryPath(pathToDirectory, andImageName: "firstImage.png")
        loadImageWithDirectoryPath(pathToDirectory, andImageName: "secondImage.png")
        loadImageWithDirectoryPath(pathToDirectory, andImageName: "thirdImage.png")
        
        return true
    }
    
    private func loadImageWithDirectoryPath(_ path: String, andImageName name: String) {
        
        var image: UIImage? = nil
        let url = URL(string: path.appending(name))
        let request = URLRequest(url: url!)
        let downloadTask = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
            if error == nil, let data = data {
                image = UIImage(data: data)
            }
            else {
                print(error.debugDescription)
            }
            DispatchQueue.main.sync {
                self?.delegate?.addImage(image)
            }
        })
        downloadTask.resume()
    }
    
}
