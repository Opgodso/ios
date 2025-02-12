//
//  Shoe+CoreDataProperties.swift
//  FormValidationStarter
//
//  Created by NDHU_CSIE on 2024/12/23.
//
//

import Foundation
import CoreData


extension Shoe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Shoe> {
        return NSFetchRequest<Shoe>(entityName: "Shoe")
    }

    @NSManaged public var name: String?
    @NSManaged public var imageName: String?
    @NSManaged public var number: Int64
    @NSManaged public var price: Int64

}

extension Shoe : Identifiable {

}
