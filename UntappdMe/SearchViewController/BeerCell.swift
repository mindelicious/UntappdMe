//
//  BeerCell.swift
//  UntappdMe
//
//  Created by Matt on 14/05/2020.
//  Copyright © 2020 mindelicious. All rights reserved.
//

import UIKit
import Kingfisher
import Lottie

class BeerCell: UITableViewCell {
    
    @IBOutlet private weak var beerImageView: UIImageView!
    @IBOutlet private weak var beerName: UILabel!
    @IBOutlet private weak var breweryName: UILabel!
    @IBOutlet private weak var ratingsLabel: UILabel!
    @IBOutlet var favouriteView: AnimationView!
    
    func showData(beer: Beer, brewery: Brewery) {

        beerImageView.kf.indicatorType = .activity
        let cornerRadius = RoundCornerImageProcessor(cornerRadius: 6)
        beerImageView.kf.setImage(with: beer.beerLabel,
                                  placeholder: UIImage(named: "placeholderImage"),
                                  options: [.processor(cornerRadius)])
        
        beerName.text = beer.beerName
        breweryName.text = brewery.breweryName
        ratingsLabel.text = beer.ratingsDoubleToString
        favouriteView.animation = Animation.named(Constants.favourite)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        beerImageView.kf.cancelDownloadTask()
    }
    
    func prepareFavourite(isFavourite: Bool) {
        if isFavourite {
            favouriteView.play(fromProgress: 0.6, toProgress: 0.6)
        } else {
            favouriteView.animation = Animation.named(Constants.favourite)
        }
    }
    
}
