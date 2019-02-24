//
//  Denuncia.swift
//  ToDeOlho
//
//  Created by Paulo Passos on 26/01/19.
//  Copyright © 2019 paulopassos. All rights reserved.
//

import Foundation

class Denuncia {

    private var idImagem: Int
    private var anonimato: Int
    private var status: String
    private var usuario: String
    private var latitude: Double
    private var longitude: Double
    private var descricao: String
    private var confiabilidade: Int
    private var dataHoraOcorreu: String
    private var dataHoraRegistro: String
    private var descricaoDesordem: String
    var imageFileName: [String] = []
    var imagem = 0

    
    init(usuario: String) {
        self.idImagem   = 0
        self.anonimato  = 0
        self.status     = "Com problemas"
        self.usuario    = usuario
        self.descricao  = ""
        self.confiabilidade     = 0
        self.dataHoraOcorreu    = "01/01/2019"
        self.dataHoraRegistro   = "01/01/2019"
        self.descricaoDesordem  = ""
        self.latitude = 0.0
        self.longitude = 0.0
    }
    
    func setImagem(idImagem: Int){
        self.idImagem = idImagem
    }
    func getImagem() -> Int{
        return self.idImagem
    }
    func setAnonimato(anonimato: Int){
        self.anonimato = anonimato
    }
    func  getAnonimato() -> Int {
        return self.anonimato
    }
    func setStatus(status: String) {
        self.status = status
    }
    func getStatus() -> String {
        return self.status
    }
    func setUsuaio(usuario: String) {
        self.usuario = usuario
    }
    func getUsuario() -> String {
        return self.usuario
    }
    func setDescricao(descricao: String) {
        self.descricao = descricao
    }
    func getDescricao() -> String {
        return self.descricao
    }
    func setConfiabilidade(confiabilidade: Int) {
        self.confiabilidade = confiabilidade
    }
    func getConfiabilidade() -> Int {
        return self.confiabilidade
    }
    func setDataHoraOcorreu(dataHora: String) {
        self.dataHoraOcorreu = dataHora
    }
    func getDataHoraOcorreu() -> String {
        return self.dataHoraOcorreu
    }
    func setDataHoraRegistro(dataHoara: String) {
        self.dataHoraRegistro = dataHoara
    }
    func getDataHoraRegistro() -> String {
        return self.dataHoraRegistro
    }
    func setDescricaoDesordem(descricao: String) {
        self.descricaoDesordem = descricao
    }
    func getDescricaoDesordem() -> String {
        return self.descricaoDesordem
    }
    func setLatitude(latitude: Double) {
        self.latitude = latitude
    }
    func getLatitide() -> Double {
        return self.latitude
    }
    func setLongitude(longitude: Double) {
        self.longitude = longitude
    }
    func getLlongitude() -> Double {
        return self.longitude
    }
}
