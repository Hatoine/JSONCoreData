//
//  Products+CoreDataProperties.swift
//  JsonCoreData
//
//  Created by Antoine Antoniol on 17/03/2021.
//
//

import Foundation
import CoreData


extension Products {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Products> {
        return NSFetchRequest<Products>(entityName: "Products")
    }

    @NSManaged public var name: String?
    @NSManaged public var image: String?
    @NSManaged public var price: Double
    @NSManaged public var id: Int16

}

extension Products : Identifiable {

}
