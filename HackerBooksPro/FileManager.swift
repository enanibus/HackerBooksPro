//
//  FileManager.swift
//  HackerBooks enanibus imported
//
//  Created by Jacobo Enriquez Gabeiras on 8/7/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import Foundation
import CoreData

enum Directories{
    case Documents
    case Cache
}

//MARK: - NSUserDefaults & Favorites management

func setDefaults(){
    let fav = defaults.array(forKey: FAVORITES)
    
    defaults.set(JSON_DOWNLOADED, forKey: JSON_DOWNLOADED)
    defaults.set(fav, forKey: FAVORITES)
    defaults.synchronize()
}

func getFavoritesFromNSDefault() -> [String]{
    guard let fav = defaults.array(forKey: FAVORITES) as? [String] else{
        return []
    }
    return fav
}

func addFavoriteToNSDefault(withBookTitle title: String){
    var fav = getFavoritesFromNSDefault()
        fav.append(title)
        defaults.set(fav, forKey: FAVORITES)
        defaults.synchronize()
}

func deleteFavoriteToNSDefault(withBookTitle title: String?){
    var fav = getFavoritesFromNSDefault()
    if title != nil {
        fav.remove(at: (fav.index(of: title!))!)
        defaults.set(fav, forKey: FAVORITES)
        defaults.synchronize()
    }
}

//MARK: - URL resources loading management

func getLocalURL(fromPath path: Directories) throws -> NSURL{
    let fm = FileManager.default
    var url: NSURL?
    switch path {
        case .Documents :
            url = fm.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).last as NSURL?
        case .Cache:
            url = fm.urls(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).last as NSURL?
    }
    guard let localUrl = url else{
        throw HackerBooksError.urlNotFoundError
    }
    return localUrl
}

func loadResourceFromCache(withUrl url: NSURL) throws -> NSData{
    do{
        let path = try getLocalURL(fromPath: .Cache)
        guard let resource = url.lastPathComponent else{
            throw HackerBooksError.resourcePointedByURLNotReachable
        }
        let locUrl = path.appendingPathComponent(resource)
        let data = NSData(contentsOf: locUrl!)
        guard let localData = data else{
            throw HackerBooksError.resourcePointedByURLNotReachable
        }
        return localData
    }
    catch{
        throw HackerBooksError.resourcePointedByURLNotReachable
    }
}

func loadResourceFromUrl(withUrl url: NSURL) throws -> NSData{
    let data = NSData(contentsOf: url as URL)
    guard let urlData = data else{
        throw HackerBooksError.resourcePointedByURLNotReachable
    }
    return urlData
}


func saveResourceToCache(withUrl url: NSURL, andData data: NSData) throws {
    var cacheUrl: URL
    let path = try! getLocalURL(fromPath: .Cache)
    cacheUrl = (path.appendingPathComponent(url.lastPathComponent!))!
    guard data.write(to: cacheUrl as URL, atomically: true) else{
        print("Failed to saving data in .Cache")
        throw HackerBooksError.resourcePointedByURLNotReachable
    }
}



//MARK: - Utils for LAST_BOOK

func saveBookInDefaults(withModel model: Book){
    let uri = model.objectID.uriRepresentation()
    let deb = uri.absoluteString
    defaults.set(deb,forKey: LAST_BOOK)
}

func getBookFromDefaults(inContext context : NSManagedObjectContext?)->Book?{
    
    
    let myObjectUrl = NSURL(string: UserDefaults.standard.value(forKey: LAST_BOOK) as! String)
    if (myObjectUrl == nil){
        return nil
    }
    let myObjectId = context?.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: myObjectUrl as! URL)
    if (myObjectId == nil){
        return nil
    }
    do{
        let myObject = try context?.existingObject(with: myObjectId!)
        let theBook = myObject as? Book
        return theBook
    }
    catch{
        return nil
    }
}


