






import UIKit
import CoreData

func saveShoe(imageName: String, name: String, number: Int64, price: Int64)  throws {
    let context = PersistenceController.shared.viewContext

    let newShoe = Shoe(context: context)
    newShoe.imageName = imageName
    newShoe.name = name
    newShoe.number = number
    newShoe.price = price

    try context.save()
    print("Shoe saved successfully!")
}
