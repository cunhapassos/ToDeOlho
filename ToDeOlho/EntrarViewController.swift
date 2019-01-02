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
    
    //let URL_USER_LOGIN =
    
    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var senha: UITextField!
    
    @IBAction func entrar(_ sender: Any) {
            
            let parametros: Parameters = ["email": login.text!, "password": senha.text!]
            
        Alamofire.request(Config.loginURL, method: .post, parameters: parametros).responseJSON{
                response in
                    print("Success: \(response.result.isSuccess)")
                print("Response String: \(String(describing: response.result.value))")
                
                var statusCode = response.response?.statusCode
                if let error = response.result.error as? AFError {
                    statusCode = error._code // statusCode private
                    switch error {
                    case .invalidURL(let url):
                        print("Invalid URL: \(url) - \(error.localizedDescription)")
                    case .parameterEncodingFailed(let reason):
                        print("Parameter encoding failed: \(error.localizedDescription)")
                        print("Failure Reason: \(reason)")
                    case .multipartEncodingFailed(let reason):
                        print("Multipart encoding failed: \(error.localizedDescription)")
                        print("Failure Reason: \(reason)")
                    case .responseValidationFailed(let reason):
                        print("Response validation failed: \(error.localizedDescription)")
                        print("Failure Reason: \(reason)")
                        
                        switch reason {
                        case .dataFileNil, .dataFileReadFailed:
                            print("Downloaded file could not be read")
                        case .missingContentType(let acceptableContentTypes):
                            print("Content Type Missing: \(acceptableContentTypes)")
                        case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
                            print("Response content type: \(responseContentType) was unacceptable: \(acceptableContentTypes)")
                        case .unacceptableStatusCode(let code):
                            print("Response status code was unacceptable: \(code)")
                            statusCode = code
                        }
                    case .responseSerializationFailed(let reason):
                        print("Response serialization failed: \(error.localizedDescription)")
                        print("Failure Reason: \(reason)")
                        // statusCode = 3840 ???? maybe..
                    }
                    
                    print("Underlying error: \(error.underlyingError)")
                } else if let error = response.result.error as? URLError {
                    print("URLError occurred: \(error)")
                } else {
                    print("Unknown error: \(response.result.error)")
                }
                
                print(statusCode) // the status code
                
                if statusCode == 200 {
                    //Persistindo dados de usuario
                    UserDefaults.standard.set(self.login.text!, forKey: "usuario")
                    UserDefaults.standard.set(self.senha.text!, forKey: "senha")
                    UserDefaults.standard.set(true, forKey: "usuarioLogado")
                    
                    // Indo para tela princiapal
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
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
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
