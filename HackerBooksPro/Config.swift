//
//  Constants.swift
//  HackerBooks enanibus imported
//
//  Created by Jacobo Enriquez Gabeiras on 30/6/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import Foundation
import UIKit

public let REMOTE_LIBRARY_URL                   =   "https://t.co/K9ziV0z3SJ"
public let FAVORITES                            =   "favorites"
public let JSON_LIBRARY_FILE                    =   "books_readable.json"
public let COVER_FILE                           =   "PlaceholderBook.png"
public let JSON_DOWNLOADED                      =   "jsonDownloadedInDocuments"
public let BOOK_KEY                             =   "BookKey"
public let IMAGE_KEY                            =   "ImageKey"
public let BOOK_DID_CHANGE_NOTIFICATION         =   "Selected Book did change"
public let TAG_DID_CHANGE_NOTIFICATION          =   "Book Tag did change"
public let FAVORITES_DID_CHANGE_NOTIFICATION    =   "Favorites did change"
public let IMAGE_DID_CHANGE_NOTIFICATION        =   "Image did change"
public let TAG                                  =   "Tag"
public let TITLE                                =   "Title"
public let ORDER_BY_TAG                         =   0
public let ORDER_BY_TITLE                       =   1
public let LITERAL_SECTION_ORDER_BY_TITLE       =   "Books by Title"
public let IS_IPHONE = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone
