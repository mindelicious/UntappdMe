//
//  Beer.swift
//  UntappdMe
//
//  Created by Matt on 14/05/2020.
//  Copyright © 2020 mindelicious. All rights reserved.
//

import Foundation

struct Beer: Codable {
    var beerName: String
    var beerLabel: URL
    var beerAbv: Double
    var beerIbu: Double
    var ratingsScore: Double
    var beerId: Int
    var brewery: Brewery?
    
    var ratingsDoubleToString: String {
        return String(format:"%.2f", ratingsScore)
    }
    
    enum CodingKeys: String, CodingKey {
        case beerName = "beer_name"
        case beerLabel = "beer_label"
        case beerAbv = "beer_abv"
        case beerIbu = "beer_ibu"
        case ratingsScore = "rating_score"
        case beerId = "bid"
        case brewery
    }
}
