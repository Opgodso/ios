import CoreData
import SwiftUI

struct PersistenceController {
    static let shared = PersistenceController()
    
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        // 建立測試資料
        let newShoe = Shoe(context: viewContext)
        newShoe.name = "Preview Shoe"
        newShoe.imageName = "shoe1"
        newShoe.number = 1
        newShoe.price = 100
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    let container: NSPersistentContainer
    //訪問CoreData 接口
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Model") // 需要和 "Model" 必須與 .xcdatamodeld 的名稱一致
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                print(error)
            }
        })
        
        if let url = container.persistentStoreCoordinator.persistentStores.first?.url {
            print("Persistent Store URL: \(url)")
        }
    }
    


    //保存到CoreData
    static func saveData(viewContext: NSManagedObjectContext) {
        guard viewContext.hasChanges else { return }
        
        do {
            try viewContext.save()
        } catch {
            print("Failed to save data: \(error)")
        }
    }
    
    static func addShoe(viewContext: NSManagedObjectContext, name: String, imageName: String, number: Int64, price: Int64) {
        let newShoe = Shoe(context: viewContext)
        newShoe.name = name
        newShoe.imageName = imageName
        newShoe.number = number
        newShoe.price = price
        
        saveData(viewContext: viewContext)
    }
    
    static func deleteData(viewContext: NSManagedObjectContext, target: NSManagedObject) {
        viewContext.delete(target)
        
        saveData(viewContext: viewContext)
    }
}
