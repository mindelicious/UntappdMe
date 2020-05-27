//
//  Brewery.swift
//  UntappdMe
//
//  Created by Matt on 13/05/2020.
//  Copyright © 2020 mindelicious. All rights reserved.
//

import UIKit

struct Brewery: Codable {
    var breweryId: Int
    var breweryName: String
    var breweryType: String
    var breweryLabel: URL
    var countryName: String
    var contact: BreweryContact
    var location: Location
    
    enum CodingKeys: String, CodingKey {
        case breweryId = "brewery_id"
        case breweryName = "brewery_name"
        case breweryType = "brewery_type"
        case breweryLabel = "brewery_label"
        case countryName = "country_name"
        case contact
        case location
    }
}
