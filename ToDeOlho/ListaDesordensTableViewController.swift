//
//  ListaDesordensViewController.swift
//  ToDeOlho
//
//  Created by Paulo Passos on 30/05/19.
//  Copyright © 2019 paulopassos. All rights reserved.
//

import UIKit

class ListaDesordensTableViewController: UITableViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

       sideMenu()
    }
    
    func sideMenu(){
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.revealViewController()?.rearViewRevealWidth = 240
        }
    }

}
