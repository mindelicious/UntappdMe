//
//  BreweryContact.swift
//  UntappdMe
//
//  Created by Matt on 13/05/2020.
//  Copyright © 2020 mindelicious. All rights reserved.
//

import Foundation

struct BreweryContact: Codable {
    var twitter: String
    var facebook: String
    var instagram: String?
    var url: String
    
    var facebookURL: URL? {
        guard !facebook.isEmpty else { return nil }
        
        if let facebookURL = URL(string: facebook) {
            return facebookURL
        } else {
            return URL(string: "https://facbook.com/" + facebook)
        }
    }
    
    var instagramURL: URL? {
        guard let instagram = instagram, !instagram.isEmpty else { return nil }
        
        return URL(string: "https://instagram.com/" + instagram)
    }
    
    var twitterURL: URL? {
        guard !twitter.isEmpty else { return nil }
        
        return URL(string: "https://twitter.com/" + twitter)
    }
    
    var urlToURL: URL? {
        guard !url.isEmpty else { return nil }
        return URL(string: url)
    }
}

