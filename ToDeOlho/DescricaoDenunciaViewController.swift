//
//  DescricaoDenunciaViewController.swift
//  ToDeOlho
//
//  Created by Paulo Passos on 10/02/19.
//  Copyright © 2019 paulopassos. All rights reserved.
//

import UIKit
import Alamofire

class DescricaoDenunciaViewController: UIViewController,  UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var descricaoTextView: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var enviarButton: UIButton!
    @IBOutlet weak var anonimatoSwitch: UISwitch!
    
    var imagens: [UIImage] = []
    var denuncia: Denuncia?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.descricaoTextView.text = "Descreva brevemente o problema encontrado..."
        self.descricaoTextView.textColor = UIColor.lightGray
        self.descricaoTextView.delegate = self
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsetsMake(0, 2, 0, 2)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0

        
        cameraButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        cameraButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        cameraButton.layer.shadowOpacity = 1.0
        cameraButton.layer.shadowRadius = 0.0
        
        //enviarButton.isEnabled = false
        enviarButton.setTitleColor(UIColor.lightGray, for: .normal)
    }
    
    /* Função relacionadas ao placeholder do descricaoTextView */
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            descricaoTextView.resignFirstResponder()
            return false
        }
        return true
    }
    
    /* Função relacionadas ao placeholder do descricaoTextView */
    func textViewDidBeginEditing(_ textView: UITextView) {
        if  self.descricaoTextView.text == "Descreva brevemente o problema encontrado..." {
            descricaoTextView.text = ""
            descricaoTextView.textColor = UIColor.black
        }
    }

    /* Função relacionadas ao placeholder do descricaoTextView */
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if descricaoTextView.text == "" {
            descricaoTextView.text = "Descreva brevemente o problema  encontrado..."
            descricaoTextView.textColor = UIColor.lightGray
        } else {
            enviarButton.setTitleColor(.white, for: .normal)
        }
    }
    
    /********************************************************/
    /***** Funções para Imagens do ViewCollection ***********/
    /********************************************************/
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagens.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        cell.deleteView.isHidden = true
        let imageView = cell.viewWithTag(1) as! UIImageView
        imageView.image = imagens[indexPath.row]
        
        // Colocar bordas na imagem
        //imageView.layer.borderColor = UIColor.lightGray.cgColor
        //imageView.layer.borderWidth = 0.5
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 2
        cell.deleteView.isHidden = false
        cell.view = self // Recebe a view atual
        cell.index = indexPath // Passa o index da celelula celecionada
    }
    
    /* Deleta uma celula da collection conforme o index passado */
    func deletarCelulaCollection(index: IndexPath){
        self.imagens.remove(at: index[1])
        self.collectionView.deleteItems(at: [index])
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        cell.deleteView.isHidden = true
    }
    
    /* Função para selecionar imagem */
    @IBAction func selectSource(_ sender: Any) {
        if self.imagens.count <  4 {
            
            let alert = UIAlertController(title: "Selecionar origem da foto", message: "", preferredStyle: .actionSheet)
        
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                let cameraAction = UIAlertAction(title: "Câmera", style: .default, handler: { (action) in
                    self.selectPicture(sourceType: .camera)
                })
                alert.addAction(cameraAction)
            }
            
            let libraryAction = UIAlertAction(title: "Biblioteca", style: .default) { (action) in
                self.selectPicture(sourceType: .photoLibrary)
            }
            alert.addAction(libraryAction)
            
            let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: nil)
            
        } else{
            self.exibirMensagem(titulo: "Número de fotos execedidas", mensagem: "Já foram inseridas 4 fotos! Caso queira inserir um nova foto, deve excluir uma das fotos existentes.")
        }
    }
    
    func selectPicture(sourceType: UIImagePickerControllerSourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    /***** FIM - Funções para Imagens do ViewCollection ***********/
    
    /****** Função que envia o conteúdo da denúncia ao servidor ******/
    @IBAction func enviarDenuncia(_ sender: Any) {
        if (descricaoTextView.text == "" ) || (descricaoTextView.text == "Descreva brevemente o problema  encontrado..." ){
            self.exibirMensagem(titulo: "Descreva a denúncia", mensagem: "Dê um descrição para a denúncia")
        }else{
            enviarButton.isUserInteractionEnabled = true
            enviarButton.setTitleColor(.white, for: .normal)
            
            denuncia?.setDescricaoDesordem(descricao: self.descricaoTextView.text)
            let usuario = UserDefaults.standard.string(forKey: "usuario")
            denuncia?.setUsuaio(usuario: usuario!)

            if anonimatoSwitch.isOn{
                denuncia?.setAnonimato(anonimato: 1)
            }else{
                denuncia?.setAnonimato(anonimato: 0)
            }
            
            let parametros: Parameters = ["usuario": denuncia?.getUsuario() ?? "", "den_status": denuncia?.getStatus() ?? "", "den_descricao": denuncia?.getDescricao() ?? "", "den_anonimato": denuncia?.getAnonimato() ?? "", "desordem": denuncia?.getDescricaoDesordem() ?? "", "den_datahora_registro": denuncia?.getDataHoraRegistro() ?? "", "den_datahora_ocorreu": denuncia?.getDataHoraOcorreu() ?? "", "den_nivel_confiabilidade": denuncia?.getConfiabilidade() ?? "", "img_denuncia_id": denuncia?.imagem ?? "", "den_local_latitude": denuncia?.getLatitide() ?? "", "den_local_longitude": denuncia?.getLlongitude() ?? ""]
            
            for image in self.imagens{
                uploadImagem(image: image)
            }
            
            
            //print(parametros)
            
            Alamofire.request(URLs.inserirDenuncia, method: .post, parameters: parametros).responseJSON
                {
                    response in switch response.result
                    {
                    case .success(let JSON):
                        let response = JSON as! NSDictionary
                        
                        let sucesso = response["sucesso"] as? Int
                        if sucesso == 0 { // "0" eh o retorno equivalente a false
                            let erro = response.value(forKey: "Error")
                            print(erro ?? "")
                            self.exibirMensagem(titulo: "Ocorreu um erro!", mensagem: "Não foi possivel inserir a denúncia no nosso Banco de Dados")
                            
                        } else{
                            print("Denúncia Inserida com sucesso!")
                            
                            let alerta = UIAlertController(title: "Denúncia Inserida com sucesso!", message: "", preferredStyle: .alert)
                            
                            alerta.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                                self.performSegue(withIdentifier: "retornarMapa", sender: nil)
                            }))
                            self.present(alerta, animated: true, completion: nil)
                        }
                    case .failure(let error):
                        print("Request failed with error:\(error)")
                    }
            } 
            
        }
    }
    func exibirMensagem(titulo: String, mensagem: String) {
        let alerta = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
        let acaoCancelar = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        alerta.addAction(acaoCancelar)
        present(alerta, animated: true, completion: nil)
    }
    
    func uploadImagem(image: UIImage)
    {
        //SwiftLoader.show(title: "Loading...", animated: true)
        
        if !self.imagens.isEmpty{
            if let imageData: Data = (UIImageJPEGRepresentation(image, 1.0) as Data?) {
                
                let URL1 = URLs.uploadImagem  // @"https://....."
                
                Alamofire.upload(multipartFormData: { (multipartFormData) in
                    multipartFormData.append(imageData, withName: "image", fileName: "image.jpg", mimeType: "image/jpg")
                
                    
                }, to: URL1, method: .post, encodingCompletion: {
                    (result) in
                    switch result {
                    case .success(let upload, _, _):
                        
                        upload.responseJSON { response in
                            
                            //SwiftLoader.hide()
                            print("Enviando imagem...")
                            print(response.timeline)
                            print("Request: \(String(describing: response.request))") // original url request
                            
                            print("Result: \(response.result)")                         // response serialization result
                            
                            if(response.error == nil){
                                let resp = response.value as! NSDictionary
                                let filename = resp["filename"] as! String
                                print("Upload bem sucedido!")
                                print("Nome do arquivo: \(filename)")

                            }else{
                                print("Error: \(String(describing: response.error))")
                            }

                        }
                        
                    case .failure(let encodingError):
                        print(encodingError)
                        //SwiftLoader.hide()
                        //Constant.showAlert(vc: self, titleStr: "Error !", messageStr: "No Internet Connection.")
                    }
                })
            }
        }
    }


    
}

extension DescricaoDenunciaViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            let originalWidth = image.size.width
            let aspectRatio = originalWidth/image.size.height
            var smallSize: CGSize
            if aspectRatio > 1{
                smallSize = CGSize(width: 118, height: 118/aspectRatio)
            }else{
                smallSize = CGSize(width: 118*aspectRatio, height: 118)
            }
            
            UIGraphicsBeginImageContext(smallSize)
            image.draw(in: CGRect(x: 0, y: 0, width: smallSize.width, height: smallSize.height))
            let smallImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            dismiss(animated: true, completion: {
                self.imagens.append(smallImage!)
                self.collectionView?.reloadData() // Recarrega o collectionView para mostrar a foto carregada
            })
        }
    }
    
    
}
