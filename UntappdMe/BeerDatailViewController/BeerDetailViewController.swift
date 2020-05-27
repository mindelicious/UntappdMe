//
//  BeerDetailViewController.swift
//  UntappdMe
//
//  Created by Matt on 15/05/2020.
//  Copyright © 2020 mindelicious. All rights reserved.
//

import UIKit
import Lottie

class BeerDetailViewController: UIViewController {
    
    @IBOutlet weak var beerName: UILabel!
    @IBOutlet private weak var alcoholLabel: UILabel!
    @IBOutlet private weak var ratingsLabel: UILabel!
    @IBOutlet private weak var ibuLabel: UILabel!
    @IBOutlet private weak var breweryImageView: UIImageView!
    @IBOutlet private weak var breweryName: UILabel!
    @IBOutlet private weak var countryLabel: UILabel!
    @IBOutlet var favouriteView: AnimationView!
    @IBOutlet private weak var cityLabel: UILabel!
    
    @IBOutlet private weak var facebookBtn: UIButton!
    @IBOutlet private weak var instagramBtn: UIButton!
    @IBOutlet private weak var twitterBtn: UIButton!
    @IBOutlet private weak var webBtn: UIButton!
    
    var beer: Beer!
    var brewery: Brewery!
    var isFavourite: Bool {
        return FavouritesManager.shared.isBeerFavourite(beerId: beer.beerId)
    }
    var item: Item {
        return Item(beer: beer, brewery: brewery)
    }

    var breweryContact: BreweryContact {
        return brewery.contact
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareInterface()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       playFavouriteAnimationIfNeccessary()
    }
    
    func playFavouriteAnimationIfNeccessary() {
        if isFavourite {
            favouriteView.play(fromProgress: 0.6, toProgress: 0.6)
        } else {
            favouriteView.animation = Animation.named(Constants.favourite)
        }
    }
    
    func prepareInterface() {
        tabBarController?.tabBar.isHidden = true
        setData()
        checkSocial(url: breweryContact.facebookURL, forButton: facebookBtn)
        checkSocial(url: breweryContact.instagramURL, forButton: instagramBtn)
        checkSocial(url: breweryContact.twitterURL, forButton: twitterBtn)
        checkSocial(url: breweryContact.urlToURL, forButton: webBtn)
        preapreFavouriteView()
    }
    
    func checkSocial(url: URL?, forButton button: UIButton) {
        button.alpha = url == nil ? 0.5 : 1.0
        button.isEnabled = url != nil
    }
    
    func setData() {
        beerName.text = beer.beerName
        alcoholLabel.text = String(beer.beerAbv)
        ratingsLabel.text = beer.ratingsDoubleToString
        ibuLabel.text = String(beer.beerIbu)
        
        breweryName.text = brewery.breweryName
        countryLabel.text = String(format: "country".localized(), brewery.countryName)
        if brewery.location.breweryCity.isEmpty {
            cityLabel.isHidden = true
        } else {
            cityLabel.text = String(format: "city".localized(), brewery.location.breweryCity)
        }
        breweryImageView.kf.setImage(with: brewery.breweryLabel)
        breweryImageView.layer.cornerRadius = breweryImageView.bounds.size.width / 2
        breweryImageView.contentMode = .scaleAspectFit
    }
}
// MARK: - HandleTap & Add to Favourites
extension BeerDetailViewController {

    func preapreFavouriteView() {
        favouriteView.animation = Animation.named(Constants.favourite)
        favouriteView.isUserInteractionEnabled = true
        addFavouriteTapRecognizer()
    }

    func addFavouriteTapRecognizer() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleFavourite(recognizer:)))
        tapRecognizer.numberOfTapsRequired = 1
        favouriteView.addGestureRecognizer(tapRecognizer)
        favouriteView.play(toProgress: 0)
    }

    @objc func toggleFavourite (recognizer:UITapGestureRecognizer) {
        
        playFavouriteAnimationIfNeccessary()
        if isFavourite {
            favouriteView.animation = Animation.named(Constants.favourite)
            FavouritesManager.shared.removeBeerById(beerId: beer.beerId)
        } else {
            if FavouritesManager.shared.isMaxAmountOfBeersReached() {
                favouritesMaxAlert()
            } else {
                favouriteView.play()
                FavouritesManager.shared.saveBeer(beer: item)
            }
        }
    }
}

// MARK: - IBAction
extension BeerDetailViewController {

    @IBAction private func backButtonTap(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func socialTap(_ sender: UIButton) {
        switch sender {
        case facebookBtn:
            leavingAppAlert(url: breweryContact.facebookURL!, socialString: Constants.facebook)
        case instagramBtn:
            leavingAppAlert(url: breweryContact.instagramURL!, socialString: Constants.instagram)
        case twitterBtn:
            leavingAppAlert(url: breweryContact.twitterURL!, socialString: Constants.twitter)
        case webBtn:
            leavingAppAlert(url: breweryContact.urlToURL!, socialString: Constants.website)
        default:
            break
        }
    }

    // MARK: - Alert handler
    func leavingAppAlert(url: URL, socialString: String) {
        let alert = UIAlertController(title: "you_will_open".localized() + socialString, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            UIApplication.shared.open(url)
        }))
        self.present(alert, animated: true)
    }
    
    func favouritesMaxAlert() {
        let alert = UIAlertController(title: String(format: "you_got_limit_of_favourites".localized(), Constants.maxBeersAmount),
                                      message: nil,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
   
}
