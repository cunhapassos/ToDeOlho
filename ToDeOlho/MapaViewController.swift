//
//  ViewController.swift
//  MDD
//
//  Created by Paulo Passos on 25/07/18.
//  Copyright © 2018 paulopassos. All rights reserved.

import UIKit
import MapKit
import Alamofire
import SVProgressHUD

class MapaViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIButton!
    
    var listaDenuncias: [Denuncia] = []
    let locationManager = CLLocationManager()
    var cnt: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate           = self
        locationManager.delegate        = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let template                        = URLs.openstreetmap // Buscando openstreetmap
        let carte_indice                    = MKTileOverlay(urlTemplate: template)
        carte_indice.canReplaceMapContent   = true
        self.mapView.add(carte_indice)
        
        sideMenu()
        configurarAddButton()
        apresentarDesordens()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !CheckInternet.Connection(){
            self.exibirMensagem(titulo: "Erro de Conexão", mensagem: "O aparelho está sem conexão com a internet! E não é possivel carregar as desordens no mapa")
        }
    }
    
    func exibirMensagem(titulo: String, mensagem: String) {
        let alerta = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
        let acaoCancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alerta.addAction(acaoCancelar)
        present(alerta, animated: true, completion: nil)
    }
    
    fileprivate func apresentarDesordens() {
        SVProgressHUD.show(withStatus: "Carregando...")
        
        Alamofire.request(URLs.denuncias, method: .get).validate().responseJSON{
            response in
            guard let data = response.data else{return}
            
            do{
                let decoder  = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                self.listaDenuncias = try! decoder.decode([Denuncia].self, from: data)
                
                for key in self.listaDenuncias{
                    let lat = key.latitude
                    let lon = key.longitude
                    let titulo = key.des_descricao
                    
                    let latitude: CLLocationDegrees = lat
                    print(latitude)
                    let longitude: CLLocationDegrees = lon
                    let ponto: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
                    let anotacao = MKPointAnnotation()
                    
                    anotacao.coordinate = ponto
                    anotacao.title = titulo
                    self.mapView.addAnnotation(anotacao)
                }
            } catch DecodingError.dataCorrupted(let context) {
                print(context.debugDescription)
            } catch DecodingError.keyNotFound(let codingKey, let context) {
                print("Key: \(codingKey). \(context.debugDescription)")
            } catch DecodingError.typeMismatch(_, let context) {
                print(context.debugDescription)
            } catch {
                print(error.localizedDescription)
            }
        }
        SVProgressHUD.dismiss()
    }
    
    fileprivate func configurarAddButton() {
        addButton.layer.masksToBounds = true
        addButton.layer.zPosition = 1
        addButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        addButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        addButton.layer.shadowOpacity = 1.0
        addButton.layer.shadowRadius = 0.0
        addButton.layer.masksToBounds = false
        addButton.layer.cornerRadius = 4.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MKMapView!, rendererFor overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay is MKTileOverlay {
            let renderer = MKTileOverlayRenderer(overlay:overlay)
            renderer.alpha = 0.8
            return renderer
        }
        return nil
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        let userlocation:CLLocation = locations [0] as CLLocation
        locationManager.stopUpdatingLocation()
        
        let location = CLLocationCoordinate2D(latitude: userlocation.coordinate.latitude, longitude: userlocation.coordinate.longitude)
        let span = MKCoordinateSpanMake (1.0, 1.0)
        let region = MKCoordinateRegion(center: location, span: span)
        
        mapView.setRegion(region, animated: true)
    }
    
    
    func sideMenu(){
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.revealViewController()?.rearViewRevealWidth = 240
        }
    }
    
    @IBAction func adicionarDenuncia(_ sender: Any) {
        
        let status = UserDefaults.standard.bool(forKey: "usuarioLogado")
        
        if status {
            self.performSegue(withIdentifier: "denunciaSegue", sender: nil)
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
        }
    }
    
}

