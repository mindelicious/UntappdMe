//
//  Extensions.swift
//  UntappdMe
//
//  Created by Matt on 19/05/2020.
//  Copyright © 2020 mindelicious. All rights reserved.
//

import Foundation

extension String {
  
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
