//
//  SearchViewController.swift
//  UntappdMe
//
//  Created by Matt on 13/05/2020.
//  Copyright © 2020 mindelicious. All rights reserved.
//

import UIKit
import Alamofire
import Lottie
import Kingfisher

class SearchViewController: UIViewController {
    
    @IBOutlet private var emptyListAnimationView: AnimationView!
    @IBOutlet private weak var emptyListLabel: UILabel!
    @IBOutlet private weak var searchUserTextField: UITextField!
    @IBOutlet private var loadingAnimationView: AnimationView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var beersArray: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchUserTextField.delegate = self
        prepareTableView()
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        tableView.reloadData()
    }
    
// MARK: - Networking
    func getUserBeers(user: String) {
        showLoadingAnimation(true)
        let userFeched: (Result<BeerModel, AFError>) -> Void = { [weak self] result in
            self?.gotResponse(result: result)
            self?.showLoadingAnimation(false)
        }
        
        NetworkManager().getUserBeers(byUser: user, onUserGet: userFeched)
    }
    
    func gotResponse(result: Result<BeerModel, AFError>) {
        switch result {
        case .success(let beerModel):
            let beersItems = beerModel.response.beers.items
            if beerModel.response.totalCount > 0 {
                beersArray = beersItems
            } else {
                beersArray = []
                emptyListView()
            }
            tableView.reloadData()
        case .failure(_):
            userErrorAlert()
        }
    }
    
    func showLoadingAnimation(_ show: Bool) {
        if show {
            tableView.isHidden = true
            loadingAnimationView.isHidden = false
            loadingAnimationView.animation = Animation.named("loading")
            loadingAnimationView.loopMode = .loop
            loadingAnimationView.play()
        } else {
            loadingAnimationView.isHidden = true
            emptyListAnimationView.isHidden = false
            emptyListLabel.isHidden = false
            tableView.isHidden = beersArray.count == 0 ? true : false
        }
    }
    
// MARK: - ErrorHandling
    
    func userErrorAlert() {
        let alert = UIAlertController(title: String(format: "somethings_go_wrong".localized(), Constants.maxBeersAmount),
                                      message: nil,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    private func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
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
    
}

// MARK: - UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let user = searchUserTextField.text, !user.isEmpty {
            getUserBeers(user: user)
            tableView.reloadData()
        } else {
            emptyListView()
        }
        self.view.endEditing(true)
        return true
    }
}


// MARK: - TableView

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func prepareTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "BeerCell", bundle: nil), forCellReuseIdentifier: "beerCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "beerCell", for: indexPath) as! BeerCell
        let beers = beersArray[indexPath.row].beer
        let breweries = beersArray[indexPath.row].brewery
        let isBeerFavourite = FavouritesManager.shared.isBeerFavourite(beerId: beers.beerId)
        
        cell.showData(beer: beers, brewery: breweries)
        cell.prepareFavourite(isFavourite: isBeerFavourite)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = beersArray[indexPath.row]
        let storyboard = UIStoryboard(name: "BeerDetail", bundle: nil)
        let beerDetailViewController = storyboard.instantiateViewController(identifier: "BeerDetailViewController") as! BeerDetailViewController
        beerDetailViewController.beer = item.beer
        beerDetailViewController.brewery = item.brewery
        navigationController?.pushViewController(beerDetailViewController, animated: true)
    }
   
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
}
