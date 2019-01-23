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
import FBSDKCoreKit
import FBSDKLoginKit

class EntrarViewController: BaseViewController, FBSDKLoginButtonDelegate, GIDSignInDelegate, GIDSignInUIDelegate, SocialDelegate {
    
    //let URL_USER_LOGIN = "http://projetomds.herokuapp.com/app/login"
    
    @IBOutlet weak var imageSocial: UIImageView!
    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var senha: UITextField!
    @IBOutlet weak var loginButton: FBSDKLoginButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var labelError: UILabel!
    
    let socialAuth : Autenticador = Autenticador()

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
        
        labelError.isHidden = true
        let status = UserDefaults.standard.bool(forKey: "usuarioLogado")
        
        if status {
            let logado = UserDefaults.standard.string(forKey: "usuarioLogado")
            let usuario = UserDefaults.standard.string(forKey: "usuario")
            print(logado!)
            print(usuario!)
            
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }
        
        loginButton.readPermissions = ["public_profile", "email"]
        //loginButton.frame = CGRect(x: 0, y: 0, width: 200, height: 45)
        loginButton.delegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        socialAuth.delegate = self

        guard FBSDKAccessToken.current() == nil else {
            // User is logged in, use 'accessToken' here.
            //showProgressIndicator()
            
            return
        }
    }
    
    @IBAction func googleLogin(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // ----- GOOGLE LOGIN API -----
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        print(user)
        
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            print("User id is "+userId!+"")
            
            let idToken = user.authentication.idToken // Safe to send to the server
            print("Authentication idToken is "+idToken!+"")
            let fullName = user.profile.name
            print("User full name is "+fullName!+"")
            let givenName = user.profile.givenName
            print("User given profile name is "+givenName!+"")
            let familyName = user.profile.familyName
            print("User family name is "+familyName!+"")
            let email = user.profile.email
            print("User email address is "+email!+"")
            
            if self.consultarUsuario(login: user.profile.email, senha: user.userID) {
                //print("NAO CADASTRADO")
                self.cadastrarUsuario(login: user.profile.email, senha: user.userID, nome: user.profile.name)
            }
            
            UserDefaults.standard.set(user.profile.email, forKey: "usuario")
            UserDefaults.standard.set(user.authentication.idToken, forKey: "senha")
            UserDefaults.standard.set(true, forKey: "usuarioLogado")
            
            
            labelError.isHidden = false;
            labelError.text = "Profile : "+fullName!+""
            
            
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
            
            if(user.profile.hasImage){
                URLSession.shared.dataTask(with: NSURL(string: user.profile.imageURL(withDimension: 400).absoluteString)! as URL, completionHandler: { (data, response, error) -> Void in
                    
                    if error != nil {
                        print(error ?? "No Error")
                        return
                    }
                    DispatchQueue.main.async(execute: { () -> Void in
                        let image = UIImage(data: data!)
                        let imgData = UIImageJPEGRepresentation(image!, 1)
                        UserDefaults.standard.set(imgData, forKey: "perfil")
                    })
                    
                }).resume()
            }else{
                let image = UIImage(named: "login.png")
                let imgData = UIImageJPEGRepresentation(image!, 1)
                UserDefaults.standard.set(imgData, forKey: "perfil")
            }
            
        } else {
            print("ERROR ::\(error.localizedDescription)")
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print(user)
        labelError.isHidden = true;
        self.labelError.text = ""
        self.imageSocial.image = UIImage(named: "login.png")
        self.imageSocial.clipsToBounds = false
    }
    
    func onGoogleSuccessResponse(user: Any) {
        hideProgressIndicator()
        print(user)
        labelError.isHidden = false;
        //        labelError.text = "Failed : "+user+""
    }
 
    func onGoogleErrorResponse(error: Error?) {
        hideProgressIndicator()
        print(error?.localizedDescription as Any)
        labelError.isHidden = false;
        labelError.text = "Failed : "+(error?.localizedDescription)!+""
    }
    // FACEBOOK LOGIN API -----
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        hideProgressIndicator()
        print("LOGOUT")
        self.labelError.text = ""
        self.login.text = ""
        self.senha.text = ""
        self.imageSocial.image = UIImage(named: "login.png")
        self.imageSocial.clipsToBounds = false
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        print("Will Logout")
        return true
    }
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        guard error != nil else{
            showProgressIndicator()
            print("LOGIN SUCCESSFULL")
            socialAuth.facebookLogin()
            hideProgressIndicator()
            //socialAuth.facebookLogin()
            return
        }
        
        onFBErrorResponse(error : error)
        return
    }
    
    func onFBSuccessResponse(user: Any) {
        //print("AQUI \n")
        //print(user)
        
        if let userDataDict = user as? NSDictionary {
            

            let usuario = userDataDict["email"] as! String
            let id = userDataDict["id"] as! String
            let name = userDataDict["first_name"] as! String
            
            if consultarUsuario(login: usuario, senha: id){
                cadastrarUsuario(login: usuario, senha: id, nome: name)
            }
            
            UserDefaults.standard.set(usuario, forKey: "usuario")
            UserDefaults.standard.set(id, forKey: "senha")
            UserDefaults.standard.set(true, forKey: "usuarioLogado")
            
            let pictDict =  userDataDict["picture"] as? NSDictionary
            let pictureUrl = pictDict?["data"] as? NSDictionary
            let picture = pictureUrl?["url"] as? String
            
            
            URLSession.shared.dataTask(with: NSURL(string: picture!)! as URL, completionHandler: { (data, response, error) -> Void in
                
                if error != nil {
                    print(error ?? "No Error")
                    return
                }
                DispatchQueue.main.async(execute: { () -> Void in
                    let image = UIImage(data: data!)
                    let imgData = UIImageJPEGRepresentation(image!, 1)
                    UserDefaults.standard.set(imgData, forKey: "perfil")
                })
                
            }).resume()
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }
        
        hideProgressIndicator()
    }
    
    func onFBErrorResponse(error: Error?) {
        hideProgressIndicator()
        print(error?.localizedDescription as Any)
        labelError.isHidden = false;
        labelError.text = "Failed : "+(error?.localizedDescription)!+""
        self.imageSocial.image = UIImage(named: "login.png")
    }
    
    func consultarUsuario(login: String, senha: String) -> Bool
    {
        let parametros: Parameters = ["email": login, "password": senha]
        var retornoBool = true
        
        Alamofire.request(Config.loginURL, method: .post, parameters: parametros).responseJSON
            {
                response in switch response.result
                {
                case .success(let JSON):
                    let response = JSON as! NSDictionary
                    
                    let sucesso = response["sucesso"] as? String
                    if sucesso == "false"{
                        retornoBool = false
                    }
                case .failure(let error):
                    print("Request failed with error:\(error)")
            }
        }
        return retornoBool
    }
    
    func cadastrarUsuario(login: String, senha: String, nome: String) -> Bool{
        
        
        let nascimento = "01/01/2001"
        let nomeUsuario = login
        let cpf = ""
        let confia = 0
        let tipo = 2
        let telefone = ""
        let email = login
        
        let parametros: Parameters = ["login": nomeUsuario, "senha": senha, "email": email, "nascimento": nascimento, "cpf": cpf,"nome": nome, "confia": confia, "tipo": tipo, "telefone": telefone]
        
        Alamofire.request(Config.inserirUsuarioURL, method: .post, parameters: parametros).responseJSON{
            response in
            let statusCode = response.response?.statusCode
            print(statusCode as Any) // the status code
            
            print("Success: \(response.result.isSuccess)")
            print("Response String: \(String(describing: response.result.value))")
            
            if statusCode == 200 {
                //CHAMar mensagem de usuario criado com sucesso
                // Indo para tela princiapal
                print("Usuario inserido com sucesso!")
            }
            else{
                // Emitir mensagem de ERRO
                self.exibirMensagem(titulo: "Erro no cadastro", mensagem: "Algo deu errado no cadastro do usuário, tente em instantes.")
            }
        }
        return true
    }
    
    func exibirMensagem(titulo: String, mensagem: String) {
        let alerta = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
        let acaoCancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alerta.addAction(acaoCancelar)
        present(alerta, animated: true, completion: nil)
    }

}
