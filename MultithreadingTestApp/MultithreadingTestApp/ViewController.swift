//
//  ViewController.swift
//  MultithreadingTestApp
//
//  Created by Алексей Смоляк on 5/4/20.
//  Copyright © 2020 Алексей Смоляк. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Actions
    @IBAction func downloadTypeSegmentedControl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let secondVC = storyBoard.instantiateViewController(identifier: "SecondViewController") as! SecondViewController
            secondVC.type = .async
            DispatchQueue.main.async {
                secondVC.downloadTypeLabel.text = "Async"
            }
            navigationController?.pushViewController(secondVC, animated: true)
        }
        else if sender.selectedSegmentIndex == 1 {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let secondVC = storyBoard.instantiateViewController(identifier: "SecondViewController") as! SecondViewController
            secondVC.type = .oneByOne
            DispatchQueue.main.async {
                secondVC.downloadTypeLabel.text = "One by one"
            }
            navigationController?.pushViewController(secondVC, animated: true)
        }
    }
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

