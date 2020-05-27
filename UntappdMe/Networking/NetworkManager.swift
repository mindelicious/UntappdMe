//
//  NetworkManager.swift
//  UntappdMe
//
//  Created by Matt on 19/05/2020.
//  Copyright © 2020 mindelicious. All rights reserved.
//

import UIKit
import Alamofire

class NetworkManager {
    
    private let userParameters: [String: String] = [
        "client_id" : Secret.clientId,
        "client_secret" : Secret.clientSecret
    ]
    
    func getUserBeers(byUser: String, onUserGet: @escaping (Result<BeerModel, AFError>) -> Void) {
        
        let basicURL = "https://api.untappd.com/v4/user/beers/\(byUser)"
        AF.request(basicURL, parameters: userParameters).responseDecodable(of: BeerModel.self) { response in
            onUserGet(response.result)
        }
    }
    
    func getBeerInfo(byBeerId: Int, onBeerGet: @escaping (Result<SingleBeerModel, AFError>) -> Void) {
       
        let basicURL = "https://api.untappd.com/v4/beer/info/\(byBeerId)"
        AF.request(basicURL, parameters: userParameters).responseDecodable(of: SingleBeerModel.self) { response in
            onBeerGet(response.result)
        }
    }
}

