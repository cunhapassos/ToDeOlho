//
//  REST.swift
//  MDD
//
//  Created by Paulo Passos on 11/08/18.
//  Copyright © 2018 paulopassos. All rights reserved.
//

import Foundation

class REST{
    private static let basePath = "http://projetomds.herokuapp.com/"
    
    private static let configuracao: URLSessionConfiguration = {
       let config = URLSessionConfiguration.default
        config.allowsCellularAccess = false
        config.httpAdditionalHeaders = ["Content-Type": "application/json"]
        config.timeoutIntervalForRequest = 30.0
        config.httpMaximumConnectionsPerHost = 6
        return config
    }()
    
    private static let sessao = URLSession(configuration: configuracao)
    
    
    class func carregarUsuario(){
        guard let url = URL(string: basePath) else{return}
        
        /*let dataTask = sessao.dataTask(with: url) { (data: Data?, response: URLResponse, error: Error?) in
            if error == nil{
                guard let response = response as? HTTPURLResponse else {return}
                if response.statusCode == 200{
                    guard let  data = data else {return}
                    do{
                        let usuario = try JSONDecoder.decode([].self, from: data)
                    }catch{
                        
                    }
                }
            }else{
                print(error)
            }
        }*/
        //dataTask.resume()
    }
}
