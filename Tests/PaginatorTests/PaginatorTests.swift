import XCTest

import HTTP
import Vapor

@testable import Paginator

class PaginatorTests: XCTestCase {
    static var allTests = [
        ("testRequestQueryExtension", testRequestQueryExtension)
    ]

    func testRequestQueryExtension() {
        var request = Request(method: .get, uri: "/?key=value")
        request = try! request.addingValues(["hello": "world"])
        
        guard var query = request.query?.object else {
            XCTFail("Query shouldn't be nil")
            return
        }
        
        let expect: [String: Node] = [
            "key": "value",
            "hello": "world"
        ]
        
        expect.forEach {
            guard let value = query[$0.key] else {
                XCTFail()
                return
            }
            
            let expectedValue = expect[$0.key]
            XCTAssertEqual(value, expectedValue)
            query.removeValue(forKey: $0.key)
        }

        let count = query.count
        XCTAssertEqual(count, 0, "Query has \(count) additional, unexpected fields.")
    }
}
