//
//  Denuncia.swift
//  ToDeOlho
//
//  Created by Paulo Passos on 26/01/19.
//  Copyright © 2019 paulopassos. All rights reserved.
//

import Foundation

class Denuncia {

    var idImagem: Int
    var anonimato: Int
    var status: String
    var usuario: String
    var descricao: String
    var confiabilidade: Int
    var dataHoraOcorreu: String
    var dataHoraRegistro: String
    var descricaoDesordem: String
    
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
}
