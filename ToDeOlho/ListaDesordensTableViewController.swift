//
//  ListaDesordensViewController.swift
//  ToDeOlho
//
//  Created by Paulo Passos on 30/05/19.
//  Copyright © 2019 paulopassos. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD


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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellDesordem", for: indexPath) as! DenunciaTableViewCell
        /*
        var den: Denuncia
        den.den_datahora_registro = "20/03/2019"
        den.des_descricao = "Animais abandonados"
        den.den_descricao = "Nessa região está aparecendo muitos animais abandonados."
        
        cell.prepareCell(with: den) */
        return cell
    }

    
    func exibirMensagem(titulo: String, mensagem: String) {
        let alerta = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
        let acaoCancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alerta.addAction(acaoCancelar)
        present(alerta, animated: true, completion: nil)
    }

}
