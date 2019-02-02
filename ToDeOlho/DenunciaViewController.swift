//
//  DenunciaViewController.swift
//  MDD
//
//  Created by Paulo Passos on 27/07/18.
//  Copyright © 2018 paulopassos. All rights reserved.
//

import UIKit
import MapKit


class DenunciaViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapDenView: MKMapView!
    @IBOutlet weak var proximoButton: UIBarButtonItem!
    
    let locationManager = CLLocationManager()
    var latitude: CLLocationDegrees = 0.0
    var longitude: CLLocationDegrees = 0.0
    var cnt: Int = 0
    var localizacao: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        proximoButton.isEnabled         = false
        
        locationManager.delegate        = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        let lat: CLLocationDegrees = locationManager.location!.coordinate.latitude
        let lon: CLLocationDegrees = locationManager.location!.coordinate.longitude
        let localizacao: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, lon)
        let span    = MKCoordinateSpan.init(latitudeDelta: 0.07, longitudeDelta: 0.07) //Declare span of map
        let region  = MKCoordinateRegion(center: localizacao, span: span) //Set region of the map
        self.mapDenView.setRegion(region, animated: true)
        
    
        self.mapDenView.delegate = self
        
        let template = "http://tile.openstreetmap.org/{z}/{x}/{y}.png"
        let carte_indice = MKTileOverlay(urlTemplate:template) 
        
        //let denuncia = Denuncia()
        carte_indice.canReplaceMapContent = true
        self.mapDenView.add(carte_indice)
        
        // Para capturar um ponto no mapa
        let reconhecedorGesto = UILongPressGestureRecognizer(target: self, action: #selector(DenunciaViewController.marcar(gesture:)))
        reconhecedorGesto.minimumPressDuration = 0.5
        mapDenView.addGestureRecognizer(reconhecedorGesto)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @objc func marcar(gesture: UIGestureRecognizer){

        if gesture.state == UIGestureRecognizerState.began {
            let pontoSelecionado = gesture.location(in: self.mapDenView)
            let coordenadas = mapDenView.convert(pontoSelecionado, toCoordinateFrom: self.mapDenView)
            localizacao = CLLocation(latitude: coordenadas.latitude, longitude: coordenadas.longitude)
            
            // selecionar o endereço do ponto selecionado
            var localCompleto = "Endereço não encontrado"
            CLGeocoder().reverseGeocodeLocation(localizacao, completionHandler: { (local, erro) in
                if erro == nil {
                    if let dadosLocal = local?.first{
                        if let nome = dadosLocal.name{
                            localCompleto = nome
                        }
                        else{
                            if let endereco = dadosLocal.thoroughfare{
                                localCompleto = endereco
                            }
                        }
                    }
                    
                    let anotacao = MKPointAnnotation()
                    
                    anotacao.coordinate.latitude = coordenadas.latitude
                    anotacao.coordinate.longitude = coordenadas.longitude
                    
                    // Permite Apenas uma marcação no Mapa
                    let anotacoes = self.mapDenView.annotations
                    if !anotacoes.isEmpty{
                        self.mapDenView.removeAnnotation(anotacoes[0])
                    }
                    
                    self.mapDenView.addAnnotation(anotacao)
                    self.proximoButton.isEnabled = true
                }
                else{
                    print(erro!)
                }
            })
        }
    }
    // Enviando o localização da denuncia para proxima view para registro
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "pontoMapaSegue"{
            let svc = segue.destination as! DenunciaTableViewController
            svc.localizacao = localizacao

        }
    }
    
}
