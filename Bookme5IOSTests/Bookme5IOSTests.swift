//
//  BookMe5iOSTests.swift
//  BookMe5iOSTests
//
//  Created by Remi Robert on 06/12/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

import XCTest
import RxSwift

class BookMe5iOSTests: XCTestCase {

    private let disposeBag = DisposeBag()
    private let viewmodel = FeedListViewModel()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testFeedBusiness() {
        var endRequest = false

        viewmodel.buisiness.asObservable().subscribeNext { models in
            print("models : \(models.count)")
            XCTAssertTrue(models.count > 0)
            endRequest = true
        }.addDisposableTo(self.disposeBag)

        viewmodel.fetchFeedList()

        while (!endRequest) {
            CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.01, true)
        }
    }    
}
