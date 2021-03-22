//
//  ViewController.swift
//  JsonCoreData
//
//  Created by Antoine Antoniol on 17/03/2021.
//

import UIKit

final class ProductsViewController: UITableViewController {
    
    
    let networking = NetworkingService.shared
    let persistence = PersistenceService.shared
    var products = [Products]()
    private let urlPath = "https://agf.ikomobi.fr/ios-hiring-test/products.json"
    
    
    private func getProducts() {
        networking.request(urlPath) { [weak self] (result) in
            switch result {
            case .success(let data):
                do {
                    guard let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]]
                    else { return }
                    let products: [Products] = jsonArray.compactMap {
                        guard let strongSelf = self,
                              let name = $0["name"] as? String,
                              let price = $0["price"] as? Double,
                              let image = $0["image"] as? String,
                              let id = $0["id"] as? Int16
                        else  { return nil }
                        
                        let product = Products(context:strongSelf.persistence.context)
                        product.name = name
                        product.id = id
                        product.price = price
                        product.image = image
                        
                        return product
                    }
                    
                    self?.products = products
                    DispatchQueue.main.async {
                        self?.persistence.save()
                        self?.tableView.reloadData()
                    }
                } catch {
                    print(error)
                }
            case.failure(let error):print(error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.register(UINib(nibName: "ProductsTableViewCell", bundle: nil), forCellReuseIdentifier: "productsCell")
        getProducts()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("persistedDataUpdated"), object: nil, queue: .main) { (_) in
        }
        persistence.fetch(Products.self) { [weak self] (products) in
            self?.products = products
            self?.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "productsCell", for: indexPath) as? ProductsTableViewCell else {
            fatalError()
        }
        cell.product = self.products[indexPath.row]
        return cell
    }
}

