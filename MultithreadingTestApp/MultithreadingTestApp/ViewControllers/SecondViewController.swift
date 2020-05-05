//
//  SecondViewController.swift
//  MultithreadingTestApp
//
//  Created by Алексей Смоляк on 5/4/20.
//  Copyright © 2020 Алексей Смоляк. All rights reserved.
//

import UIKit
enum LoadingType {
    case oneByOne, async
}
class SecondViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var downloadTypeLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Properties
    var type: LoadingType!
    var downloadedImages: [UIImage] = []
    var urlsForDownloadImage = [
        "http://img.bezkassira.y/img/organise/1233/large/8708_30d32-1582878914.jpg",
        "http://img.bezkassira.by/img/organise/1591/large/8193_eae1a-1579019500.jpg",
        "http://img.bezkassira.y/img/organise/2304/large/8505_9091c-1584379941.jpg",
        "http://img.bezkassira.by/img/organise/1233/large/8613_bb3fb-1582128043.png",
        "http://img.bezkassira.by/img/organise/1160/large/8006_53d5f-1576902225.jpg",
        "http://img.bezkassira.y/img/organise/1591/large/8783_54e62-1583487193.jpg",
        "http://img.bezkassira.by/img/organise/1902/large/8937_f0d25-1585829812.png",
        "http://img.bezkassira.y/img/organise/2098/large/9070_104da-1588231856.jpg",
        "http://img.bezkassira.by/img/organise/1433/large/9013_a4915-1586873451.jpg",
        "http://img.bezkassira.by/img/organise/1233/large/8601_b1b57-1587387785.jpg",
        "http://img.bezkassira.y/img/organise/1996/large/8876_05d7d-1585226695.png",
        "http://img.bezkassira.by/img/organise/1870/large/8831_a4238-1583933497.jpg",
        "http://img.bezkassira.by/img/organise/1996/large/8787_08062-1583504041.jpg",
        "http://img.bezkassira.y/img/organise/2009/large/8360_6917a-1584455486.jpg",
        "http://img.bezkassira.by/img/organise/1046/large/8917_3c47e-1585321104.png",
        "http://img.bezkassira.by/img/organise/1996/large/8427_6917a-1585930054.png",
        "http://img.bezkassira.by/img/organise/1996/large/8183_109e7-1585917819.png",
        "http://img.bezkassira.y/img/organise/1996/large/8688_97f7e-1582742084.png",
        "http://img.bezkassira.by/img/organise/1233/large/8020_82af7-1585754061.jpg",
        "http://img.bezkassira.by/img/organise/1996/large/8152_f3235-1579707274.png",
        "http://img.bezkassira.by/img/organise/1996/large/7894_562e5-1585427115.png"
    ]
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "UploadedImageCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "UploadedImageCollectionViewCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        switch type! {
        case .oneByOne:
            dowloadImagesOneByOne()
        case .async:
            dowloadImagesAsync()
        }
    }
    
    //MARK: - Supporting
    func dowloadImagesOneByOne() {
        for urlString in urlsForDownloadImage {
            guard let url = URL(string: urlString) else { return }
            DownloadManager.instance.downloadImage(from: url) { [weak self] (image, error) in
                if let image = image {
                    self?.downloadedImages.append(image)
                    self?.collectionView.reloadData()
                }
            }
        }
    }
    
    func dowloadImagesAsync() {
        var successCounter = 0
        var errorCounter = 0
        activityIndicatorView.startAnimating()
        let dispatchGroup = DispatchGroup()
        for urlString in urlsForDownloadImage {
            guard let url = URL(string: urlString) else { return }
            dispatchGroup.enter()
            DownloadManager.instance.downloadImage(from: url) { [weak self] (image, error) in
                if error != nil {
                    errorCounter += 1
                }
                if let image = image {
                    self?.downloadedImages.append(image)
                    successCounter += 1
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.collectionView.reloadData()
            self?.activityIndicatorView.stopAnimating()
            let alert = UIAlertController(title: "Information about loading", message: "downloaded - \(successCounter), failed to load \(errorCounter)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self!.present(alert, animated: true, completion: nil)
        }
    }
}

extension SecondViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return downloadedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UploadedImageCollectionViewCell", for: indexPath as IndexPath) as! UploadedImageCollectionViewCell
        let image = downloadedImages[indexPath.row]
        cell.downloadedImageView.image = image
        return cell
    }
}
