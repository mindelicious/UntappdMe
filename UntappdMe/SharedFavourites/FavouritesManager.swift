//
//  FavouritesManager.swift
//  UntappdMe
//
//  Created by Matt on 21/05/2020.
//  Copyright © 2020 mindelicious. All rights reserved.
//

import UIKit

class FavouritesManager {

    static let shared = FavouritesManager()
    var favBeers: [Item] = []
    private let BeersKey = "beers"
 
    private init() {}

    func saveBeer(beer: Item) {
        favBeers.append(beer)
        saveState()
    }
    
    private func saveState() {
        let beersData = try! JSONEncoder().encode(favBeers)
        UserDefaults.standard.set(beersData, forKey: BeersKey)
    }

    func getBeers() {
        guard let beersData = UserDefaults.standard.data(forKey: BeersKey) else { return }
        let beersArray = try! JSONDecoder().decode([Item].self, from: beersData)
        favBeers = beersArray
    }
    
    func removeBeer(beer: Item) {
        guard let elem = favBeers.firstIndex(where: { $0.beer.beerId == beer.beer.beerId }) else { return }
        favBeers.remove(at: elem)
        saveState()
    }
    
    func removeBeerById(beerId: Int) {
        guard let elem = favBeers.firstIndex(where: { $0.beer.beerId == beerId }) else { return }
        favBeers.remove(at: elem)
        saveState()
    }
    
    func isBeerFavourite(beerId: Int) -> Bool {
       return favBeers.contains(where: { $0.beer.beerId == beerId })
    }
    
    func isMaxAmountOfBeersReached() -> Bool {
        return favBeers.count == Constants.maxBeersAmount
    }
    
    private func updateBeer(atIndex: Int, item: Item) {
        favBeers[atIndex] = item
        saveState()
    }
    
    func replaceItem(item: Item) {
        guard let elem = favBeers.firstIndex(where: { $0.beer.beerId == item.beer.beerId }) else { return }
        updateBeer(atIndex: elem, item: item)
    }
        
}
