//
//  BarraLateralTableViewController.swift
//  MDD
//
//  Created by Paulo Passos on 02/09/18.
//  Copyright © 2018 paulopassos. All rights reserved.
//

import UIKit

class BarraLateralTableViewController: UITableViewController{

    @IBOutlet weak var nomeUsuarioLabel: UILabel!
    @IBOutlet weak var profile: UIImageView!
    
    var reference: EntrarViewController?
    
    
    @IBAction func logout(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "usuario")
        UserDefaults.standard.removeObject(forKey: "senha")
        UserDefaults.standard.setValue(false, forKey: "usuarioLogado")
        nomeUsuarioLabel.text = "Fazer Login"
        self.profile.image = UIImage(named: "login.png")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.bool(forKey: "usuarioLogado"){
            nomeUsuarioLabel.text = UserDefaults.standard.string(forKey: "usuario")
            
            let imgData = UserDefaults.standard.data(forKey: "perfil")
            self.profile.image = UIImage(data: imgData!)
        }
        else{
            self.profile.image = UIImage(named: "login.png")
        }
        
        self.profile.layer.cornerRadius = 10
        self.profile.clipsToBounds = true
        self.profile.layer.borderColor = UIColor.blue.cgColor
        self.profile.layer.borderWidth = 4
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0{
            if nomeUsuarioLabel.text == "Fazer Login"{
                self.performSegue(withIdentifier: "fazerLoginSegue", sender: nil)
            }
        }
    }

}
