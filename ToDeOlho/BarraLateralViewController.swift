//
//  BarraLateralViewController.swift
//  ToDeOlho
//
//  Created by Paulo Passos on 29/05/19.
//  Copyright © 2019 paulopassos. All rights reserved.
//

import UIKit

class BarraLateralViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var menuTable: UITableView!
    @IBOutlet weak var nomeUsuarioLabel: UILabel!
    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var btControle: UIButton!
    
    var reference: EntrarViewController?
    let cellReuseIdentifier = "menuTableViewCell"
    var menuOptions = ["Mapa", "Desordens", "Perfil", "Sobre"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuTable.delegate = self
        menuTable.dataSource = self
        
        if UserDefaults.standard.bool(forKey: "usuarioLogado"){
            nomeUsuarioLabel.text = UserDefaults.standard.string(forKey: "usuario")
            
            let imgData = UserDefaults.standard.data(forKey: "perfil")
            self.profile.image = UIImage(data: imgData!)
            self.btControle.setTitle("Sair", for: .normal)
        }
        else{
            self.profile.image = UIImage(named: "logo.png")
            self.btControle.setTitle("Entar", for: .normal)
        }
        
        self.profile.layer.cornerRadius = 10
        self.profile.clipsToBounds = true
        self.profile.layer.borderColor = UIColor.white.cgColor
        self.profile.layer.borderWidth = 4
    }
    
    @IBAction func logout(_ sender: Any) {
        
        if(self.btControle.titleLabel?.text == "Sair"){
            UserDefaults.standard.removeObject(forKey: "usuario")
            UserDefaults.standard.removeObject(forKey: "senha")
            UserDefaults.standard.setValue(false, forKey: "usuarioLogado")
            nomeUsuarioLabel.text = ""
            self.btControle.setTitle("Entar", for: .normal)
            self.profile.image = UIImage(named: "logo.png")
        }
        else{
            self.performSegue(withIdentifier: "login", sender: nil)
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : MenuTableViewCell = tableView.dequeueReusableCell(withIdentifier: "menuTableViewCell") as! MenuTableViewCell
        
        cell.optionMenu.text = menuOptions[indexPath.row]
        
        /* Para alterar as configurações das celulas da tabela */
        //cell.backgroundColor = UIColor.white
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 0.2
        //cell.layer.cornerRadius = 8
        //cell.clipsToBounds = true
        
        return cell
    }
    /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: menuOptions[indexPath.row], sender: self)
    } */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // ...
        let dashboardNC = revealViewController().frontViewController as! UINavigationController
        _ = revealViewController().frontViewController as! UINavigationController
        
            // Instantiate controller from story board
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let controller = sb.instantiateViewController(withIdentifier: menuOptions[indexPath.row])
        dashboardNC.popViewController(animated: true)
        dashboardNC.pushViewController(controller, animated: false)
    
        // Push it with SWRevealViewController
        revealViewController().pushFrontViewController(dashboardNC, animated: true)
        
    }
}
