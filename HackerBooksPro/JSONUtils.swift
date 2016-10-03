//
//  JSONProcessing.swift
//  HackerBooks
//
//  Created by Jacobo Enriquez Gabeiras on 30/6/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import Foundation

// Ejemplo de Book
/*
 {
 "authors": "Scott Chacon, Ben Straub",
 "image_url": "http://hackershelf.com/media/cache/b4/24/b42409de128aa7f1c9abbbfa549914de.jpg",
 "pdf_url": "https://progit2.s3.amazonaws.com/en/2015-03-06-439c2/progit-en.376.pdf",
 "tags": "version control, git",
 "title": "Pro Git"
 }
 */

//MARK: - JSON Utils


//MARK: - JSON Loading
func loadFromLocalFile(fileName name: String, bundle: Bundle = Bundle.main) throws -> JSONArray{
    
    if let url = bundle.url(forResource: name, withExtension: "json"),
        let data = NSData(contentsOf: url),
        let maybeArray = try? JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.allowFragments) as? JSONArray,
        let array = maybeArray{
        
        return array
        
    }else{
        throw HackerBooksError.jsonParsingError
    }
}

func loadFromURL() throws -> JSONArray{
    
    if let url = NSURL(string: REMOTE_LIBRARY_URL),
        let data = NSData(contentsOf: url as URL),
        let maybeArray = try? JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.allowFragments) as? JSONArray,
        let array = maybeArray{
        return array
    }else{
        throw HackerBooksError.jsonParsingError
    }
}

func loadFromDocuments() throws -> JSONArray{
    do{
        let data = try getJSONFromDocuments()
        if let maybeArray = try? JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.allowFragments) as? JSONArray,
            let array = maybeArray{
            return array
        } else{
            throw HackerBooksError.jsonParsingError
        }
    }
    catch{
        throw HackerBooksError.jsonParsingError
    }
}


//MARK: - JSON Downloading

func downloadFromURL() throws -> NSData{
    let data = NSData(contentsOf: NSURL(string: REMOTE_LIBRARY_URL)! as URL)
    guard let json = data else{
        throw HackerBooksError.resourcePointedByURLNotReachable
    }
    return json
}

func isJSONDownloaded() -> Bool{
    let isDownloaded = defaults.object(forKey: JSON_DOWNLOADED) as? String
    if isDownloaded == JSON_DOWNLOADED{
        return true
    }
    return false
}

func setIsJSONDownloaded(){
    defaults.set(JSON_DOWNLOADED, forKey: JSON_DOWNLOADED)
    defaults.synchronize()
}

func downloadRemoteJSON() throws  {
    if !isJSONDownloaded(){
        do{
            let data = try downloadFromURL()
            setDefaults()
            try saveJSONToDocuments(withData: data)
        }catch{
            throw HackerBooksError.jsonDownloadingError
        }
    }
}

func saveJSONToDocuments(withData data: NSData) throws {
    var url: URL
    var newUrl: URL
    do{
        try url = getLocalURL(fromPath: .Documents) as URL
        newUrl = url.appendingPathComponent(JSON_LIBRARY_FILE)
    }catch{
        throw HackerBooksError.urlNotFoundError
    }
    
    guard data.write(to: newUrl as URL, atomically: true) else{
        throw HackerBooksError.jsonSavingFileError
    }
    
}

func getJSONFromDocuments() throws -> NSData{
    var url : URL
    var newUrl : URL
    do{
        try url = getLocalURL(fromPath: .Documents) as URL
        newUrl = url.appendingPathComponent(JSON_LIBRARY_FILE)
    }catch{
        throw HackerBooksError.resourcePointedByURLNotReachable
    }
    let datos = NSData(contentsOf: newUrl as URL)
    guard let data = datos else{
        throw HackerBooksError.wrongJSONFormat
    }
    return data
}








