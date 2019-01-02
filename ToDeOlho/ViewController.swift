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
        locationManager.startUpdatingLocation()
        
        self.mapView.delegate = self

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
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        
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
    
}

