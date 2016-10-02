//
//  Errors.swift
//  HackerBooks enanibus imported
//
//  Created by Jacobo Enriquez Gabeiras on 29/6/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import Foundation

// MARK: -  JSON Errors
enum HackerBooksError : Error{
    case wrongURLFormatForJSONResource
    case resourcePointedByURLNotReachable
    case jsonParsingError
    case wrongJSONFormat
    case jsonDownloadingError
    case nilJSONObject
    case urlNotFoundError
    case jsonSavingFileError
    case idObjectError
}
