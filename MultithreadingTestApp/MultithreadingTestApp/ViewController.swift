//
//  ViewController.swift
//  MultithreadingTestApp
//
//  Created by Алексей Смоляк on 5/4/20.
//  Copyright © 2020 Алексей Смоляк. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    //MARK: - Properties
    var downloadType = "Async"
    
    //MARK: - Outlets
    @IBOutlet private weak var downloadButton: UIButton!
    
    
    //MARK: - Actions""
    @IBAction func downloadButtonClicked(_ sender: UIButton) {
        if downloadType == "Async" {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let secondVC = storyBoard.instantiateViewController(identifier: "SecondViewController") as! SecondViewController
            secondVC.type = .async
            secondVC.downloadType = "Async"
            navigationController?.pushViewController(secondVC, animated: true)
        }
        else if downloadType == "OneByOne" {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let secondVC = storyBoard.instantiateViewController(identifier: "SecondViewController") as! SecondViewController
            secondVC.type = .oneByOne
            secondVC.downloadType = "One by one"
            navigationController?.pushViewController(secondVC, animated: true)
        }
    }
    
    @IBAction func downloadTypeSegmentedControl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            downloadType = "Async"
        }
        else if sender.selectedSegmentIndex == 1 {
            downloadType = "OneByOne"
        }
    }
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

