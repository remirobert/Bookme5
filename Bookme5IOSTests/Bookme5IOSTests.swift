//
//  BookMe5iOSTests.swift
//  BookMe5iOSTests
//
//  Created by Remi Robert on 06/12/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

import XCTest
@testable import BookMe5iOS

class BookMe5iOSTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testFeedBusiness() {
        var endRequest = false
        let viewmodel = FeedListViewModel()

        viewmodel.fetchFeedList()


        while (!endRequest) {
            CFRunLoopRunInMode(CFRunLoopMode.defaultMode, 0.01, true)
        }
    }    
}
