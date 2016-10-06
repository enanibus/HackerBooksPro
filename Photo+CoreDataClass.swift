//
//  Photo+CoreDataClass.swift
//  HackerBooksPro
//
//  Created by Jacobo Enriquez Gabeiras on 18/9/16.
//  Copyright © 2016 enanibus. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public class Photo: NSManagedObject {
    static let entityName = "Photo"
    
    var image : UIImage?{
        get{
            guard let data = photoData else{
                return nil
            }
            return UIImage(data: data as Data)!
        }
        
        set{
            guard let img = newValue else{
                photoData = nil
                return
            }
            photoData = UIImageJPEGRepresentation(img, 0.9) as NSData!
        }
        
    }
    
    convenience init (image: UIImage,
                      inContext context: NSManagedObjectContext){
        
        let ent = NSEntityDescription.entity(forEntityName: Photo.entityName,
                                             in: context)!
        self.init(entity: ent, insertInto: context)
        self.image = image
    }
}
