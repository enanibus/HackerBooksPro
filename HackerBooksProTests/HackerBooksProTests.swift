//
//  HackerBooksProTests.swift
//  HackerBooksProTests
//
//  Created by Jacobo Enriquez Gabeiras on 6/9/16.
//  Copyright © 2016 enanibus. All rights reserved.
//

import XCTest
@testable import HackerBooksPro
import CoreData

class HackerBooksProTests: XCTestCase {
    
    
    override func setUp() {
        do{
            try model.dropAllData()
            
        }
        catch{
            print("Test Setup: Error deleting data")
        }
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

}
