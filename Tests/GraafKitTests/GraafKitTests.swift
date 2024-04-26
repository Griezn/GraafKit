@testable import GraafKit
import XCTest


class GraphTests : XCTestCase
{
    func testVertexCount()
    {
        var graph = Graph<Int, Edge<Int>>()
        XCTAssertEqual(graph.vertex_count(), 0)
        
        let vertex_id_1 = graph.add_vertex(vertex: 10)
        XCTAssertEqual(graph.vertex_count(), 1)
        XCTAssertTrue(graph.has_vertex(vertex: vertex_id_1))
        XCTAssertEqual(graph.get_vertex(vertex: vertex_id_1), 10)
        
        let vertex_id_2 = graph.add_vertex(vertex: 20)
        XCTAssertEqual(graph.vertex_count(), 2)
        XCTAssertTrue(graph.has_vertex(vertex: vertex_id_2))
        XCTAssertEqual(graph.get_vertex(vertex: vertex_id_2), 20)
        
        let specific_id = 2
        XCTAssertNotNil(try graph.add_vertex(vertex: 30, vertex_id: specific_id))
        XCTAssertEqual(graph.vertex_count(), 3)
        XCTAssertTrue(graph.has_vertex(vertex: specific_id))
        XCTAssertEqual(graph.get_vertex(vertex: specific_id), 30)
    }
    
    
    func testRemoveVertex()
    {
        
    }
}
