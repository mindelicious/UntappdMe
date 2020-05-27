//
//  Location.swift
//  UntappdMe
//
//  Created by Matt on 13/05/2020.
//  Copyright © 2020 mindelicious. All rights reserved.
//

import Foundation

struct Location: Codable {
    var breweryCity: String
    var breweryState: String
    
    enum CodingKeys: String, CodingKey {
        case breweryCity = "brewery_city"
        case breweryState = "brewery_state"
    }
}

