//
//  CadastroTableViewController.swift
//  MDD
//
//  Created by Paulo Passos on 13/08/18.
//  Copyright © 2018 paulopassos. All rights reserved.
//

import UIKit
import Alamofire
import CryptoSwift

class CadastroTableViewController: UITableViewController {

    var datePickerIndexPath: IndexPath?
    var inputTexts: [String] = ["Nascimento"]
    var inputDates: [Date] = []
    var pickerVisible: Bool = false
    
    @IBOutlet weak var nomeTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var senhaTextField: UITextField!
    @IBOutlet weak var senhaConfirmarTextField: UITextField!
    @IBOutlet weak var cadastrarButton: UIButton!
    
    @IBAction func cadastrar(_ sender: Any) {
        if let email = self.emailTextField.text{
            let senha = self.senhaTextField.text!.md5()
            let confirmar = self.senhaConfirmarTextField.text!.md5()
                    if senha == confirmar{
                        print("Senhas iguais!")
                        
                        let nascimento = ""
                        print(nascimento)
                        let nomeUsuario = self.emailTextField.text!
                        let nome = nomeTextField.text!
                        let cpf = ""
                        print(cpf)
                        let confia = 0
                        let tipo = 2
                        let telefone = ""
                        
                        let parametros: Parameters = ["login": nomeUsuario, "senha": senha, "email": email, "nascimento": nascimento, "cpf": cpf,"nome": nome, "confia": confia, "tipo": tipo, "telefone": telefone]
                        
                        Alamofire.request(URLs.inserirUsuario, method: .post, parameters: parametros).responseJSON{
                            response in
                            let statusCode = response.response?.statusCode
                            print(statusCode as Any) // the status code
                            
                            print("Success: \(response.result.isSuccess)")
                            print("Response String: \(String(describing: response.result.value))")
   
                            if statusCode == 200 {
                                UserDefaults.standard.set(nomeUsuario, forKey: "usuario")
                                UserDefaults.standard.set(email, forKey: "nomeUsuario")
                                UserDefaults.standard.set(senha, forKey: "senha")
                                UserDefaults.standard.set(true, forKey: "usuarioLogado")
                                
                                let alerta = UIAlertController(title: "Cadastro realizado", message: "Usuário cadastrado com sucesso", preferredStyle: .alert)
                                
                                alerta.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                                    //self.performSegue(withIdentifier: "retornarMapa", sender: nil)
                                    if let navigation = self.navigationController{
                                        navigation.popToRootViewController(animated: true)
                                    }
                                }))
                                self.present(alerta, animated: true, completion: nil)
                                
                            }
                            else{
                                // Emitir mensagem de ERRO
                                self.exibirMensagem(titulo: "Erro no cadastro", mensagem: "Algo deu errado no cadastro do usuário, tente em instantes.")
                            }
                        }
                    }else{
                        self.exibirMensagem(titulo: "Dados incorretos", mensagem: "As senhas não estão iguais, digite novamente.")
                    }
            
            
        }
    }
    /*
    @IBAction func escolherData(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let strDate = dateFormatter.string(from: dataNascimentoDatePicker.date)
        nascimentoLabel.text = strDate
    }*/
    
    
    func exibirMensagem(titulo: String, mensagem: String) {
        let alerta = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
        let acaoCancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alerta.addAction(acaoCancelar)
        present(alerta, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       let tap: UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        tap.cancelsTouchesInView = false
       view.addGestureRecognizer(tap)
        
        //nascimentoLabel.text = getToday()
    }
    
    @objc func DismissKeyboard(){
        view.endEditing(true)
        
    }
    
    func getToday() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let today = dateFormatter.string(from: Date(timeInterval: 0, since: Date()))
        
        return today
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 5
        case 1:
            return pickerVisible ? 2 : 1
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        if indexPath.section == 1 && indexPath.row == 0{
            if !pickerVisible{
                tableView.insertRows(at: [IndexPath.init(row: 1, section: 1)], with: .fade)
                pickerVisible = true
            }else{
                tableView.deleteRows(at: [IndexPath.init(row: 1, section: 1)], with: .fade)
                 pickerVisible = false
            }
        }
        tableView.endUpdates()
    }
}
