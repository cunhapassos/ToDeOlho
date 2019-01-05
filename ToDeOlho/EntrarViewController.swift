//
//  EntrarViewController.swift
//  MDD
//
//  Created by Paulo Passos on 11/08/18.
//  Copyright © 2018 paulopassos. All rights reserved.
//

import UIKit
import Alamofire


class EntrarViewController: UIViewController {
    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var senha: UITextField!
    
    @IBAction func entrar(_ sender: Any) {
            
        let parametros: Parameters = ["email": login.text!, "password": senha.text!]
            
        Alamofire.request(Config.loginURL, method: .post, parameters: parametros).responseJSON{ response in
            guard let json = response.result.value as? [String: Any] else{
                print("Nao foi possivel obter o objeto de retorno como JSON from API")
                if let error = response.result.error {
                    print("Error: \(error)")
                }
                return
            }
            guard let retorno = json["sucesso"] as? String else{
                print("Nao foi possivel recuperar o retorno do login")
                return
            }
            print("Created retorno with id: \(retorno)")

            if retorno == "true" {
                //Persistindo dados de usuario
                UserDefaults.standard.set(self.login.text!, forKey: "usuario")
                UserDefaults.standard.set(self.senha.text!, forKey: "senha")
                UserDefaults.standard.set(true, forKey: "usuarioLogado")
                    
                // Indo para tela princiapal
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
            else{
               print("Senha ou email errado")
                let alertController = UIAlertController(title: "Erro de login", message: "Nome de usuário ou senha errados. Por favor tente outra vez.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let status = UserDefaults.standard.bool(forKey: "usuarioLogado")
        if status {
            let logado = UserDefaults.standard.string(forKey: "usuarioLogado")
            let usuario = UserDefaults.standard.string(forKey: "usuario")
            print(logado!)
            print(usuario!)
            
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
