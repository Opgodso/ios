//
//  Persistence.swift
//  FormValidationStarter
//
//  Created by NDHU_CSIE on 2024/12/23.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentContainer
    var viewContext: NSManagedObjectContext { container.viewContext}

    init() {
        container = NSPersistentContainer(name: "Shoe")
        container.loadPersistentStores(completionHandler: {  (storeDescription, error) in
            if let error = error {  print(error)  }   })
        }
    }

