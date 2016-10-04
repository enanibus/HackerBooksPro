//
//  AsyncPdf.swift
//  HackerBooks
//
//  Created by Jacobo Enriquez Gabeiras on 10/7/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import Foundation

class AsyncPdf{
    
    //MARK: - Stored properties
    
    let pdfURL   : NSURL
    var pdfData  : NSData?
    
    //MARK: - Initialization
    
    init(withURL url: NSURL){
        self.pdfURL = url
        self.pdfData = nil
    }
    
    //MARK: - PDF Data management
    func getPDF() -> NSData?{
        
        if self.pdfData == nil{
            do{
                let data = try loadFilePdfOfBook(withUrl: self.pdfURL)
                self.pdfData = data
                return data
                        
            }catch{
                return nil
            }
        }else{
            return self.pdfData
        }
    }

    func loadFilePdfOfBook (withUrl url: NSURL) throws -> NSData{
        var data : NSData
        
        // 1. Pdf de directorio Cache

        do{
            data = try loadResourceFromCache(withUrl: url)
            return data
        }catch{
            print("PDF file not delivered from Cache directory")
            
            // 2. Pdf de URL remota
            do{
                data = try loadResourceFromUrl(withUrl: url)
                try saveResourceToCache(withUrl: url, andData: data)
                return data
            }
            catch{
                print("PDF file not delivered from remote URL")
                throw HackerBooksError.resourcePointedByURLNotReachable
            }
        }
    }
    
}