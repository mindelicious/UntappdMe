//
//  FavouritesViewController.swift
//  UntappdMe
//
//  Created by Matt on 13/05/2020.
//  Copyright © 2020 mindelicious. All rights reserved.
//

import UIKit
import Lottie
import Alamofire

class FavouritesViewController: UIViewController {
    
    @IBOutlet private var emptyListAnimationView: AnimationView!
    @IBOutlet private weak var emptyListLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var loadingAnimationView: AnimationView!
  
    var favBeers: [Item] {
        return FavouritesManager.shared.favBeers
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareInterface()
        handleEmptyTableView()
        prepareTableView()
    }
    
    func prepareInterface() {
        navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = false
    }
    
// MARK: - Loading Animation & Empty List
    func showLoadingAnimation(_ show: Bool) {
        if show {
            tableView.isHidden = true
            loadingAnimationView.isHidden = false
            emptyListAnimationView.isHidden = true
            emptyListLabel.isHidden = true
            loadingAnimationView.animation = Animation.named("loading")
            loadingAnimationView.loopMode = .loop
            loadingAnimationView.play()
        } else {
            tableView.isHidden = false
            loadingAnimationView.isHidden = true
            emptyListAnimationView.isHidden = false
            emptyListLabel.isHidden = false
        }
    }
    
    func handleEmptyTableView() {
        if favBeers.isEmpty {
            emptyListView()
        } else {
            tableView.isHidden = false
        }
    }
    
    func emptyListView() {
        loadingAnimationView.isHidden = true
        emptyListLabel.isHidden = false
        emptyListAnimationView.isHidden = false
        emptyListAnimationView.animation = Animation.named("emptyList")
        emptyListAnimationView.loopMode = .loop
        emptyListAnimationView.play()
        tableView.isHidden = true
    }
// MARK: - Networking
    func getBeerInfo(beer: Int) {
        showLoadingAnimation(true)
        let beerFetched: (Result<SingleBeerModel, AFError>) -> Void = { [weak self] result in
            self?.gotBeerResponse(result: result)
            self?.showLoadingAnimation(false)
        }
        NetworkManager().getBeerInfo(byBeerId: beer, onBeerGet: beerFetched)
    }
    
    func gotBeerResponse(result: Result<SingleBeerModel, AFError>) {
        switch result {
        case .success(let singleBeerModel):
            let beer = singleBeerModel.response.beer
            let item = Item(beer: beer, brewery: beer.brewery!)
            let storyboard = UIStoryboard(name: "BeerDetail", bundle: nil)
            let beerDetailViewController = storyboard.instantiateViewController(identifier: "BeerDetailViewController") as! BeerDetailViewController
    
            beerDetailViewController.beer = beer
            beerDetailViewController.brewery = beer.brewery
            
            FavouritesManager.shared.replaceItem(item: item)
            
            navigationController?.pushViewController(beerDetailViewController, animated: true)
        case .failure(_):
           singleBeerRequesErrorAlert()
        }
    }
    
    func singleBeerRequesErrorAlert() {
           let alert = UIAlertController(title: String(format: "somethings_go_wrong".localized(), Constants.maxBeersAmount),
                                         message: nil,
                                         preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
           self.present(alert, animated: true)
       }
    
}
// MARK: - TableView
extension FavouritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func prepareTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "BeerCell", bundle: nil), forCellReuseIdentifier: "beerCell")
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favBeers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "beerCell", for: indexPath) as! BeerCell
        let beers = favBeers[indexPath.row]
        let breweries = favBeers[indexPath.row].brewery
        cell.favouriteView.isHidden = true
        cell.showData(beer: beers.beer, brewery: breweries)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let beer = favBeers[indexPath.row]
        getBeerInfo(beer: beer.beer.beerId)
    }
    
}
