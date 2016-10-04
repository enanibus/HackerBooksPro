//
//  AsyncImage.swift
//  HackerBooks
//
//  Created by Jacobo Enriquez Gabeiras on 10/7/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import Foundation
import UIKit

class AsyncImage{
    
    //MARK: - Stored properties
    
    let imageURL : NSURL
    var image    : UIImage?
    
    //MARK: - Initialization
    
    init(withURL url: NSURL, withImage image: UIImage){
        self.imageURL = url
        self.image = image
    }
    
    //MARK: - Image management
    func getImage() -> UIImage?{
        
        // 1. Imagen por defecto UIImage(imageLiteral: COVER_FILE)
        
        // 2. Imagen de directorio Cache
        
        do{
            let dataOfImage = try loadResourceFromCache(withUrl: self.imageURL)
            guard let uiImg = UIImage(data: dataOfImage as Data) else{
                return nil
            }
            self.image = uiImg
            return self.image
        }catch {
            print("Image not delivered from Cache directory")
    
        // 3. Imagen de URL remota con GCD en background
        
//            downloadImageInBackground()
            
            return self.image
        }
    }
    
//    func downloadImageInBackground(){
//        let download = dispatch_get_global_queue(DispatchQueue.GlobalQueuePriority.default,0)
//        let bloque : dispatch_block_t = {
//            do{
//                let dataOfImage = try loadResourceFromUrl(withUrl: self.imageURL)
//                try saveResourceToCache(withUrl: self.imageURL, andData: dataOfImage)
//                guard let uiImg = UIImage(data: dataOfImage) else {
//                    self.image = UIImage(imageLiteral: COVER_FILE)
//                    return
//                }
//                self.image = uiImg
//                
//                // notificar de la descarga a suscriptores
//                self.notifyAsyncImageDidChange(self.image!)
//                
//            }catch{
//                print("Image not delivered from remote URL")
//            }
//        }
//        dispatch_async(download, bloque)
//    }
    
    func notifyAsyncImageDidChange(withImage: UIImage){
        let nc = NotificationCenter.default
        let notif = NSNotification(name: NSNotification.Name(rawValue: IMAGE_DID_CHANGE_NOTIFICATION),
                                   object: self,
                                   userInfo: [IMAGE_KEY: withImage])
        nc.post(notif as Notification)
    }
    
    
}
