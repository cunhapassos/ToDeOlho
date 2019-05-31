import Foundation

struct Constants {
    static let googleClientID: String        = "1052359812626-5kj19jotg9812s88o204p1aep8qi246d.apps.googleusercontent.com"
    static let twitterConsumerKey: String    = "1lkN9XOHRKK6WmJ3qcvS7T3BQ"
    static let twitterConsumerSecret: String = "gvCWBYyO35r37xjYCAojRfHxiVfslOU44UQufXQGoMPPADBiPF"
}

struct URLs {
    //static let main = "http://localhost:3000/"
    static let main             = "http://projetomds.herokuapp.com/"
    
    /// POST {login, password}
    static let login            = main + "app/login"
    static let denuncias        = main + "api/denuncias/coordsA"
    static let tiposDesordem    = main + "api/tipodedesordem"
    static let inserirUsuario   = main + "app/usuarios/insert"
    static let inserirDenuncia  = main + "api/denuncia/inserir2"
    
    /// POST {image}
    static let uploadImagem     = main + "api/denuncia/upload/imagems"
    static let openstreetmap    = "http://tile.openstreetmap.org/{z}/{x}/{y}.png"
}


