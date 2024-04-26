@testable import GraafKit
import XCTest

class EdgeTests : XCTestCase
{
    func testEdgeInitialization() {
        let edge = Edge()
        XCTAssertEqual(edge.get_weight(), 1)
        
        let edge2 = Edge(weight: 15.4)
        XCTAssertEqual(edge2.get_weight(), 15.4)
    }
    
    func testEdgeIDInitialization() {
        // Test initialization with left <= right
        let edgeID1 = EdgeID(left: 1, right: 2)
        XCTAssertEqual(edgeID1.left, 1)
        XCTAssertEqual(edgeID1.right, 2)
        
        // Test initialization with left > right
        let edgeID2 = EdgeID(left: 3, right: 2)
        XCTAssertEqual(edgeID2.left, 2)
        XCTAssertEqual(edgeID2.right, 3)
    }
    
    func testHashValue() {
        let edgeID1 = EdgeID(left: 1, right: 2)
        let edgeID2 = EdgeID(left: 2, right: 1)
        
        XCTAssertEqual(edgeID1.hashValue, edgeID2.hashValue)
    }
    
    func testEquality() {
        let edgeID1 = EdgeID(left: 1, right: 2)
        let edgeID2 = EdgeID(left: 2, right: 3)
        
        XCTAssertNotEqual(edgeID1, edgeID2)
    }
}
