//
//  PerfilViewController.swift
//  ToDeOlho
//
//  Created by Paulo Passos on 30/05/19.
//  Copyright © 2019 paulopassos. All rights reserved.
//

import UIKit
import SVProgressHUD


class PerfilViewController: UIViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenu()
        SVProgressHUD.show(withStatus: "Carregando...")
    }
    
    func sideMenu(){
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.revealViewController()?.rearViewRevealWidth = 240
        }
    }
    @IBAction func stopSV(_ sender: Any) {
        SVProgressHUD.dismiss()
    }
    

}
