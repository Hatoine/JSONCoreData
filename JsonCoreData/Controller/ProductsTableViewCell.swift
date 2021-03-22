//
//  ProductsTableViewCell.swift
//  JsonCoreData
//
//  Created by Antoine Antoniol on 17/03/2021.
//

import UIKit

class ProductsTableViewCell: UITableViewCell {

    @IBOutlet private var productImageView: UIImageView!
    @IBOutlet private var productName: UILabel!
    @IBOutlet private var productPrice: UILabel!
    
    var product: Products? {
        didSet {
            setCell(imageUrl: product?.image ?? "",name: product?.name ?? "",price: product?.price ?? Double())
        }
    }
    
    private func setCell(imageUrl:String,name:String,price:Double){
        productImageView?.loadImageUsingCacheWithUrlString(imageUrl)
        productName.text =  name
        productPrice.text = String(price) + " " + "€"
    }  
}
