//
//  DiscoverViewController.swift
//  Aisle
//
//  Created by Chandra Kiran Reddy Yeduguri on 09/11/24.
//

import UIKit

class DiscoverViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let badgeColor = UIColor(cgColor: .init(red: CGFloat(140.0/255), green: CGFloat(92.0/255), blue: CGFloat(251.0/255), alpha: CGFloat(1.0)))
        
        if let tabBar = self.tabBarController?.tabBar {
            let noteTab = tabBar.items![1]
            noteTab.badgeColor = badgeColor
            noteTab.badgeValue = "9"
            
            let matchTab = tabBar.items![2]
            matchTab.badgeColor = badgeColor
            matchTab.badgeValue = "50+"
        }
    }

}
