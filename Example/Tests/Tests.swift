import UIKit
import XCTest
import DLCache

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSimpleGetCall() {
        
        let expectation = XCTestExpectation(description: "Download data from test server")
        
        //GET Example
        let urlGet = URL(string: "https://jsonplaceholder.typicode.com/posts?userId=1")
        DLCache().getJSON(from: urlGet!, removeCacheData: true, success: { (data) in
            
            guard let array = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
                XCTFail("Error on parser")
                return
            }
            
            XCTAssertLessThan(1, array!.count, "Expected at least one value")

            let dicc = array![0]
            
            guard let idvalue = dicc["userId"] as? Int else{
                XCTFail("Error on getting id from test JSON")
                return
            }
            
            XCTAssertEqual(idvalue, 1, "id dosent match with expected result")
            
            // Fulfill the expectation to indicate that the background task has finished successfully.
            expectation.fulfill()

        }) { _ in
            XCTFail("Error on test server")
        }
        
        // Wait until the expectation is fulfilled, with a timeout of 10 seconds.
        wait(for: [expectation], timeout: 3.0)
    }
    
    
}
