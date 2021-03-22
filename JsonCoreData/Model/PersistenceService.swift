//
//  PersistenceService.swift
//  JsonCoreData
//
//  Created by Antoine Antoniol on 17/03/2021.
//

import Foundation
import CoreData

class PersistenceService {
    
    private init() {}
    static let shared = PersistenceService()
    
    
    var context: NSManagedObjectContext { return persistentContainer.viewContext }
    
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "JsonCoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func save() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("save succesfully")
                NotificationCenter.default.post(name: NSNotification.Name("persistedDataUpdated"), object: nil)
            } catch {
               
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetch<T:NSManagedObject>(_ type:T.Type,completion:@escaping([T])->Void) {
        let request = NSFetchRequest<T>(entityName: String(describing: type))
        do{
            let objects = try context.fetch(request)
            completion(objects)

        } catch {
            print(error)
            completion([])
        }
    }
    
}
