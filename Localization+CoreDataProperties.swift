//
//  Localization+CoreDataProperties.swift
//  HackerBooksPro
//
//  Created by Jacobo Enriquez Gabeiras on 21/9/16.
//  Copyright © 2016 enanibus. All rights reserved.
//

import Foundation
import CoreData


extension Localization {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Localization> {
        return NSFetchRequest<Localization>(entityName: "Localization");
    }

    @NSManaged public var address: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var annotations: NSSet?

}

// MARK: Generated accessors for annotations
extension Localization {

    @objc(addAnnotationsObject:)
    @NSManaged public func addToAnnotations(_ value: Annotation)

    @objc(removeAnnotationsObject:)
    @NSManaged public func removeFromAnnotations(_ value: Annotation)

    @objc(addAnnotations:)
    @NSManaged public func addToAnnotations(_ values: NSSet)

    @objc(removeAnnotations:)
    @NSManaged public func removeFromAnnotations(_ values: NSSet)

}
