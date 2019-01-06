//
//  EntrarViewController.swift
//  MDD
//
//  Created by Paulo Passos on 11/08/18.
//  Copyright © 2018 paulopassos. All rights reserved.
//

import UIKit
import Alamofire
import GoogleSignIn

@objc(VEntrarViewController)
// [START viewcontroller_interfaces]
class EntrarViewController: UIViewController , GIDSignInUIDelegate {
    // [END viewcontroller_interfaces]
    
    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var senha: UITextField!
    
    // [START viewcontroller_vars]
    @IBOutlet weak var signInButton: GIDSignInButton!
   // @IBOutlet weak var signOutButton: UIButton!
   // @IBOutlet weak var disconnectButton: UIButton!
    //@IBOutlet weak var statusText: UILabel!
    // [END viewcontroller_vars]
    
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
        GIDSignIn.sharedInstance().uiDelegate = self
        
        // Uncomment to automatically sign in the user.
        //GIDSignIn.sharedInstance().signInSilently()
        
        // TODO(developer) Configure the sign-in button look/feel
        // [START_EXCLUDE]
       /* NotificationCenter.default.addObserver(self,
                                               selector: #selector(EntrarViewController.receiveToggleAuthUINotification(_:)),
                                               name: NSNotification.Name(rawValue: "ToggleAuthUINotification"),
                                               object: nil)
        
        statusText.text = "Initialized Swift app..."
        toggleAuthUI()*/
        // [END_EXCLUDE]
        
    }

    /* [START signout_tapped]
    @IBAction func didTapSignOut(_ sender: AnyObject) {
        GIDSignIn.sharedInstance().signOut()
        // [START_EXCLUDE silent]
        statusText.text = "Signed out."
        toggleAuthUI()
        // [END_EXCLUDE]
    }
    // [END signout_tapped]
    
    // [START disconnect_tapped]
    @IBAction func didTapDisconnect(_ sender: AnyObject) {
        GIDSignIn.sharedInstance().disconnect()
        // [START_EXCLUDE silent]
        statusText.text = "Disconnecting."
        // [END_EXCLUDE]
    }
    // [END disconnect_tapped]
    
    // [START toggle_auth]
    func toggleAuthUI() {
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            // Signed in
            signInButton.isHidden = true
            signOutButton.isHidden = false
            disconnectButton.isHidden = false
        } else {
            signInButton.isHidden = false
            signOutButton.isHidden = true
            disconnectButton.isHidden = true
            statusText.text = "Google Sign in\niOS Demo"
        }
    }
    // [END toggle_auth]
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(rawValue: "ToggleAuthUINotification"),
                                                  object: nil)
    }
    
    @objc func receiveToggleAuthUINotification(_ notification: NSNotification) {
        if notification.name.rawValue == "ToggleAuthUINotification" {
            self.toggleAuthUI()
            if notification.userInfo != nil {
                guard let userInfo = notification.userInfo as? [String:String] else { return }
                self.statusText.text = userInfo["statusText"]!
            }
        }
    }
*/
}
