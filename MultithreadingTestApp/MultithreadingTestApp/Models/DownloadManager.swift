//
//  DownloadManager.swift
//  MultithreadingTestApp
//
//  Created by Алексей Смоляк on 5/4/20.
//  Copyright © 2020 Алексей Смоляк. All rights reserved.
//

import Foundation
import UIKit

class DownloadManager {
    static var instance = DownloadManager()
    
    func downloadImage(from url: URL, onComplete: @escaping (UIImage?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                onComplete(nil, error)
                print(error!)
                return
            }
            DispatchQueue.global(qos: .background).async {
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    onComplete(image, nil)
                }
            }
        }.resume()
    }
}
