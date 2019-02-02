//
//  ViewController.swift
//  MDD
//
//  Created by Paulo Passos on 25/07/18.
//  Copyright © 2018 paulopassos. All rights reserved.

import UIKit
import MapKit
import Alamofire


class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIButton!
    
    let locationManager = CLLocationManager()
    
    var cnt: Int = 0
    let URL_DENUNCIAS = "https://projetomds.herokuapp.com/api/denuncias/coordsA"
    
    fileprivate func apresentarDesordens() {
        Alamofire.request(URL_DENUNCIAS, method: .get).responseJSON{
            response in
            /* Inicio - Retirar após a fase de desenvolvimento */
            //print("Response String: \(String(describing: response.result.value))")
            /* Fim - Retirar após a fase de desenvolvimento*/
            if let result = response.result.value as? NSArray{
                for key in result{
                    let key = key as! NSDictionary
                    let lat = key["st_x"]
                    let lon = key["st_y"]
                    let titulo = key["des_descricao"] as! String
                    let latitude: CLLocationDegrees = lat! as! CLLocationDegrees
                    let longitude: CLLocationDegrees = lon! as! CLLocationDegrees
                    let ponto: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
                    let anotacao = MKPointAnnotation()
                    
                    anotacao.coordinate = ponto
                    anotacao.title = titulo
                    self.mapView.addAnnotation(anotacao)
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        //locationManager.startUpdatingLocation()
        
        /* Botão Adicionar denuncia */
        addButton.layer.masksToBounds = true
        addButton.layer.zPosition = 1
        addButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        addButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        addButton.layer.shadowOpacity = 1.0
        addButton.layer.shadowRadius = 0.0
        addButton.layer.masksToBounds = false
        addButton.layer.cornerRadius = 4.0
        
        self.mapView.delegate = self

        /* Buscando openstreetmap  */
        let template = "http://tile.openstreetmap.org/{z}/{x}/{y}.png"
        let carte_indice = MKTileOverlay(urlTemplate:template)
        
        //carte_indice.isGeometryFlipped = true
        
        carte_indice.canReplaceMapContent = true
        self.mapView.add(carte_indice)
        
        sideMenu()
        
        apresentarDesordens()
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MKMapView!, rendererFor overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay is MKTileOverlay
        {
            let renderer = MKTileOverlayRenderer(overlay:overlay)
            renderer.alpha = 0.8
            return renderer
        }
        return nil
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let localizacaoUsuario: CLLocation = locations.last!
        
        // Exibição do Mapa
        //Map centre
        let latitude: CLLocationDegrees = localizacaoUsuario.coordinate.latitude
        let longitude: CLLocationDegrees = localizacaoUsuario.coordinate.longitude
        let centre = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        //Declare span of map
        let span = MKCoordinateSpan(latitudeDelta: 0.007, longitudeDelta: 0.007)
        
        //Set region of the map
        let region = MKCoordinateRegion(center: centre, span: span)
        self.mapView.setRegion(region, animated: true)
        self.mapView.regionThatFits(region)
        
    }
    
    func sideMenu(){
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    @IBAction func adicionarDenuncia(_ sender: Any) {
        
        let status = UserDefaults.standard.bool(forKey: "usuarioLogado")
        
        if status {
            self.performSegue(withIdentifier: "denunciaSegue", sender: nil)
        }
        else{
            // Cria o alerta
            let alert = UIAlertController(title: "Não há usuário logado", message: "Para cadastrar uma denuncia você precisa fazer login. Deseja fazer login agora?", preferredStyle: UIAlertController.Style.alert)
            
            // Adiciona acoes (botoes
            alert.addAction(UIAlertAction(title: "Sim", style: UIAlertAction.Style.default, handler: { action in
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }))
            alert.addAction(UIAlertAction(title: "Não", style: UIAlertAction.Style.cancel, handler: nil))
            
            // Mostra o alerta
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

