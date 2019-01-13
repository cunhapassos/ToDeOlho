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

class EntrarViewController: BaseViewController, FBSDKLoginButtonDelegate, GIDSignInDelegate, GIDSignInUIDelegate {
    
    let URL_USER_LOGIN = "http://projetomds.herokuapp.com/app/login"
    
    @IBOutlet weak var imageSocial: UIImageView!
    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var senha: UITextField!
    @IBOutlet weak var loginButton: FBSDKLoginButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var labelError: UILabel!
    

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
        

        guard FBSDKAccessToken.current() == nil else {
            // User is logged in, use 'accessToken' here.
            //showProgressIndicator()
            //socialAuth.facebookLogin()
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
    
    // GOOGLE LOGIN API -----
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
    /*
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
    } */
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
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
            hideProgressIndicator()
            //socialAuth.facebookLogin()
            return
        }
        
        onFBErrorResponse(error : error)
        return
    }
    
    func onFBSuccessResponse(user: Any) {
        print(user)
        
        if let userDataDict = user as? NSDictionary {
            let first_name = userDataDict["first_name"] as? String
            _ = userDataDict["id"] as? String
            let last_name = userDataDict["last_name"] as? String
            let pictDict =  userDataDict["picture"] as? NSDictionary
            let pictureUrl = pictDict?["data"] as? NSDictionary
            let picture = pictureUrl?["url"] as? String
            
            labelError.isHidden = false;
            labelError.text = "Profile : "+first_name!+" "+last_name!+""
            
            URLSession.shared.dataTask(with: NSURL(string: picture!)! as URL, completionHandler: { (data, response, error) -> Void in
                
                if error != nil {
                    print(error ?? "No Error")
                    return
                }
                DispatchQueue.main.async(execute: { () -> Void in
                    let image = UIImage(data: data!)
                    self.imageSocial.image = image
                    self.imageSocial.layer.borderWidth = 1
                    self.imageSocial.layer.masksToBounds = false
                    self.imageSocial.layer.borderColor = UIColor.clear.cgColor
                    self.imageSocial.layer.cornerRadius = self.imageSocial.frame.height/2
                    self.imageSocial.clipsToBounds = true
                })
                
            }).resume()
            
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

}
