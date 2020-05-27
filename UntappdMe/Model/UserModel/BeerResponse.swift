//
//  BeerResponse.swift
//  UntappdMe
//
//  Created by Matt on 14/05/2020.
//  Copyright © 2020 mindelicious. All rights reserved.
//

import Foundation

struct BeerResponse: Codable {
    var totalCount: Int
    var beers: Beers
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case beers
    }
}
