//
//  DenunciaTableViewController.swift
//  MDD
//
//  Created by Paulo Passos on 30/07/18.
//  Copyright © 2018 paulopassos. All rights reserved.
//

import UIKit
import Alamofire
import MapKit

class DenunciaTableViewController: UITableViewController{

    /* COLOCAR URL COMO UserDefaults.standard */
    //let URL_TPOS_DESORDEM = "http://localhost:3000/api/tipodedesordem"
    //let URL_ISERIR_DENUNCIA = "http://localhost:3000/api/denuncia/inserir"

    //@IBOutlet weak var descricaoTextView: UITextView!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var horaLabel: UILabel!
    @IBOutlet weak var desordemTipoLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var horaPicker: UIDatePicker!
    @IBOutlet weak var tipoPicker: UIPickerView!
    @IBOutlet weak var proximoButton: UIBarButtonItem!
    @IBOutlet weak var coordenadas: UILabel!
    
    // datepicker related data
    var pickerIndexPath: IndexPath?
    var pickerVisible: Bool = false
    var tipoDenuncia = Array<String>()
    var localizacao: CLLocation!
    var denuncia: Denuncia?
    
    
    @IBAction func datePickerValueChanged(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let strDate = dateFormatter.string(from: datePicker.date)
        dataLabel.text = strDate
    }
    
    @IBAction func horaPickerValueChanged(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        let strDate = dateFormatter.string(from: horaPicker.date)
        horaLabel.text = strDate
    }
    
    func validarUser() -> String{
        let status = UserDefaults.standard.bool(forKey: "usuarioLogado")
        
        if status {
            let usuario = UserDefaults.standard.string(forKey: "usuario")
            return usuario!
        } else{
            // Cria o alerta
            let alert = UIAlertController(title: "Não há usuário logado", message: "Para cadastrar uma denuncia você precisa fazer login. Deseja fazer login agora?", preferredStyle: .alert)
            
            // Adiciona acoes (botoes
            alert.addAction(UIAlertAction(title: "Sim", style: .default, handler: { action in
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }))
            alert.addAction(UIAlertAction(title: "Não", style: .cancel, handler: nil))
            
            // Mostra o alerta
            self.present(alert, animated: true, completion: nil)
            return ""
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Recuperando data do Registro
        let data = Date()
        let formatarData = DateFormatter()
        formatarData.dateFormat = "yyyy/MM/dd"
        let hoje = formatarData.string(from: data)
        
        // Covertendo data do fato para formato americano
        formatarData.dateFormat = "dd/MM/yyyy"
        let datahora_fato = formatarData.date(from: self.dataLabel.text!)
        formatarData.dateFormat = "yyyy/MM/dd"
        let dataHora = formatarData.string(from: datahora_fato!)
        
        
        self.denuncia?.setDescricao(descricao: self.desordemTipoLabel.text!)
        self.denuncia?.setStatus(status: "Com problemas")
        self.denuncia?.setConfiabilidade(confiabilidade: 0)
        self.denuncia?.setDataHoraRegistro(dataHoara: hoje)
        self.denuncia?.setDataHoraOcorreu(dataHora: dataHora)
        self.denuncia?.setLatitude(latitude: self.localizacao.coordinate.latitude)
        self.denuncia?.setLongitude(longitude: self.localizacao.coordinate.longitude)
        
        if segue.identifier == "denunciaSegue"{
            let svc = segue.destination as! DescricaoDenunciaViewController
            svc.denuncia = self.denuncia
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let usuario = validarUser()
        self.denuncia = Denuncia(usuario: usuario)
        
        datePicker.isHidden = true
        horaPicker.isHidden = true
        tipoPicker.isHidden = true
        pickerIndexPath = IndexPath(item: 1, section: 1 )
        proximoButton.isEnabled = false
        
        tipoPicker.dataSource = self
        tipoPicker.delegate = self
        
//        descricaoTextView.delegate = self
        let latitude    = String(self.localizacao.coordinate.latitude)
        let longitude   = String(self.localizacao.coordinate.longitude)
        
        coordenadas.text = "(\(latitude), \(longitude))"
        dataLabel.text = getToday()
        horaLabel.text = getHourNow()
        desordemTipoLabel.text = "Selecione o tipo de desordem"
        
        print(localizacao.coordinate.latitude)
        listarTiposDenuncia()
    }
    
    func listarTiposDenuncia(){
        Alamofire.request(Config.URL_TPOS_DESORDEM, method: .post).responseJSON{
            response in
            
            if let result = response.result.value as? NSArray{
                for key in result{
                    let key = key as! NSDictionary
                    let valor = key["des_descricao"] as! String
                    self.tipoDenuncia.append(valor)
                }
                // Teste: Fase de desenvolvimento
                for key in self.tipoDenuncia{
                    print(key)
                }
            }else{
                //Tratar erro de requisição
            }
            print("Success: \(response.result.isSuccess)")
            print("Response String: \(String(describing: response.result.value))")
        }
    }
    func getToday() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        let today = dateFormatter.string(from: Date(timeInterval: 0, since: Date()))
        
        return today
    }
    
    func getHourNow() -> String{
        let calendar = Calendar.current
        let time = calendar.dateComponents([.hour,.minute,.second], from: Date())
        return String(format:"%02i:%02i", time.hour!, time.minute!)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return pickerVisible ? 2 : 1
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.beginUpdates()
        switch indexPath.section {
        case 0:
           if indexPath.row == 1 {
                if pickerVisible && !datePicker.isHidden {
                    tableView.deleteRows(at: [pickerIndexPath!], with: .fade)
                    pickerVisible = false
                    datePicker.isHidden = true
                    horaPicker.isHidden = true
                    tipoPicker.isHidden = true
                    
                } else if pickerVisible && !horaPicker.isHidden {
                    datePicker.isHidden = false
                    horaPicker.isHidden = true
                    tipoPicker.isHidden = true
                    
                }else if pickerVisible && !tipoPicker.isHidden {
                    datePicker.isHidden = false
                    horaPicker.isHidden = true
                    tipoPicker.isHidden = true
                    
                }else{
                    pickerVisible = true
                    datePicker.isHidden = false
                    horaPicker.isHidden = true
                    tipoPicker.isHidden = true
                    tableView.insertRows(at: [pickerIndexPath!], with: .fade)
                }
            }else if indexPath.row == 2 {
                if pickerVisible && !horaPicker.isHidden{
                    tableView.deleteRows(at: [pickerIndexPath!], with: .fade)
                    pickerVisible = false
                    datePicker.isHidden = true
                    horaPicker.isHidden = true
                    tipoPicker.isHidden = true
                    
                }else if pickerVisible && !datePicker.isHidden {
                    datePicker.isHidden = true
                    horaPicker.isHidden = false
                    tipoPicker.isHidden = true
                    
                }else if pickerVisible && !tipoPicker.isHidden {
                    datePicker.isHidden = true
                    horaPicker.isHidden = false
                    tipoPicker.isHidden = true
        
                }else{
                    pickerVisible = true
                    datePicker.isHidden = true
                    horaPicker.isHidden = false
                    tipoPicker.isHidden = true
                    tableView.insertRows(at: [pickerIndexPath!], with: .fade)
                }
           }else{
                if pickerVisible {
                    tableView.deleteRows(at: [pickerIndexPath!], with: .fade)
                    pickerVisible = false
                    datePicker.isHidden = true
                    horaPicker.isHidden = true
                    tipoPicker.isHidden = true
                }
           }
            break
        case 1:
            if indexPath.row == 0 {
                if pickerVisible && !tipoPicker.isHidden {
                    tableView.deleteRows(at: [pickerIndexPath!], with: .fade)
                    pickerVisible = false
                    datePicker.isHidden = true
                    horaPicker.isHidden = true
                    tipoPicker.isHidden = true
                } else if pickerVisible && !horaPicker.isHidden {
                    datePicker.isHidden = true
                    horaPicker.isHidden = true
                    tipoPicker.isHidden = false
                    
                }else if pickerVisible && !datePicker.isHidden {
                    datePicker.isHidden = true
                    horaPicker.isHidden = true
                    tipoPicker.isHidden = false
                    
                }else{
                    pickerVisible = true
                    datePicker.isHidden = true
                    horaPicker.isHidden = true
                    tipoPicker.isHidden = false
                    tableView.insertRows(at: [pickerIndexPath!], with: .fade)
                }
            }
            break
        default:
            break
        }
        tableView.endUpdates()
    }
}

extension DenunciaTableViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tipoDenuncia.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.desordemTipoLabel.text = tipoDenuncia[row]
        /*
        if !self.descricaoTextView.text.isEmpty && (desordemTipoLabel.text != "Selecione o tipo de desordem"){
            self.regitrarButton.isEnabled = true
        }
        */
        if (desordemTipoLabel.text != "Selecione o tipo de desordem"){
            self.proximoButton.isEnabled = true
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return tipoDenuncia[row]
    }
}

extension DenunciaTableViewController: UITextViewDelegate{
    func textViewDidChangeSelection(_ textView: UITextView) {
        /*
        if !self.descricaoTextView.text.isEmpty && (desordemTipoLabel.text != "Selecione o tipo de desordem"){
            self.regitrarButton.isEnabled = true
        }
 */
        if (desordemTipoLabel.text != "Selecione o tipo de desordem"){
            self.proximoButton.isEnabled = true
        }
        tableView.beginUpdates()
        if pickerVisible {
            tableView.deleteRows(at: [pickerIndexPath!], with: .fade)
            pickerVisible = false
            datePicker.isHidden = true
            horaPicker.isHidden = true
            tipoPicker.isHidden = true
        }
        tableView.endUpdates()
    }
}
