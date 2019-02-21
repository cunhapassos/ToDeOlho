//
//  Constantes.swift
//  ToDeOlho
//
//  Created by Paulo Passos on 02/01/19.
//  Copyright © 2019 paulopassos. All rights reserved.
//
import Foundation

struct Constants {
    static let googleClientID: String = "1052359812626-5kj19jotg9812s88o204p1aep8qi246d.apps.googleusercontent.com"
    static let twitterConsumerKey: String = "1lkN9XOHRKK6WmJ3qcvS7T3BQ"
    static let twitterConsumerSecret: String = "gvCWBYyO35r37xjYCAojRfHxiVfslOU44UQufXQGoMPPADBiPF"
}

struct URLs {
    //static let main = "http://localhost:3000/"
     static let main = "http://projetomds.herokuapp.com/"
    
    /// POST {login, password}
    static let login = main + "app/login"
    static let inserirUsuario = main + "app/usuarios/insert"
    static let tiposDesordem = main + "api/tipodedesordem"
    static let inserirDenuncia = main + "api/denuncia/inserir"
    
    /// POST {image}
    static let uploadImagem = main + "api/denuncia/upload/imagem"
}


