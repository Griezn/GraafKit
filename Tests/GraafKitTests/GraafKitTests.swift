@testable import GraafKit
import XCTest


class GraphTests : XCTestCase
{
    func testAddVertex()
    {
        var graph = Graph<Int, Edge<Int>>()
        XCTAssertEqual(graph.vertex_count(), 0)
        XCTAssertEqual(graph.get_vertices(), [:])
        
        let vertex_id_1 = graph.add_vertex(vertex: 10)
        XCTAssertEqual(graph.vertex_count(), 1)
        XCTAssertTrue(graph.has_vertex(id: vertex_id_1))
        XCTAssertEqual(graph.get_vertex(id: vertex_id_1), 10)
        XCTAssertEqual(graph.get_vertices(), [vertex_id_1:10])
        
        let vertex_id_2 = graph.add_vertex(vertex: 20)
        XCTAssertEqual(graph.vertex_count(), 2)
        XCTAssertTrue(graph.has_vertex(id: vertex_id_2))
        XCTAssertEqual(graph.get_vertex(id: vertex_id_2), 20)
        XCTAssertEqual(graph.get_vertices(), [vertex_id_1:10, vertex_id_2:20])
        
        let specific_id = 2
        XCTAssertNoThrow(try graph.add_vertex(vertex: 30, id: specific_id))
        XCTAssertEqual(graph.vertex_count(), 3)
        XCTAssertTrue(graph.has_vertex(id: specific_id))
        XCTAssertEqual(graph.get_vertex(id: specific_id), 30)
        XCTAssertEqual(graph.get_vertices(), [vertex_id_1:10, vertex_id_2:20
                                              , specific_id:30])
        
        XCTAssertThrowsError(try graph.add_vertex(vertex: 40, id: specific_id))
        XCTAssertEqual(graph.vertex_count(), 3)
        XCTAssertTrue(graph.has_vertex(id: specific_id))
        XCTAssertEqual(graph.get_vertex(id: specific_id), 30)
        XCTAssertEqual(graph.get_vertices(), [vertex_id_1:10, vertex_id_2:20
                                              , specific_id:30])
    }
    
    
    func testRemoveVertex()
    {
        var graph = Graph<Int, Edge<Int>>()
        
        let vertex_id_0 = graph.add_vertex(vertex: 10)
        graph.remove_vertex(id: vertex_id_0)
        XCTAssertEqual(graph.vertex_count(), 0)
        XCTAssertFalse(graph.has_vertex(id: vertex_id_0))
        
        let vertex_id_1 = graph.add_vertex(vertex: 10)
        let vertex_id_2 = graph.add_vertex(vertex: 20)
        let vertex_id_3 = graph.add_vertex(vertex: 30)
        try? graph.add_edge(from: vertex_id_1, to: vertex_id_2, edge: Edge())
        try? graph.add_edge(from: vertex_id_2, to: vertex_id_3, edge: Edge())
        try? graph.add_edge(from: vertex_id_3, to: vertex_id_1, edge: Edge())
        
        graph.remove_vertex(id: vertex_id_2)
        XCTAssertEqual(graph.vertex_count(), 2)
        XCTAssertEqual(graph.edge_count(), 1)
        XCTAssertFalse(graph.has_vertex(id: vertex_id_2))
        XCTAssertFalse(graph.get_neighbors(id: vertex_id_1)!.contains(vertex_id_2))
        XCTAssertFalse(graph.get_neighbors(id: vertex_id_3)!.contains(vertex_id_2))
        
        graph.remove_vertex(id: vertex_id_3)
        XCTAssertEqual(graph.vertex_count(), 1)
        XCTAssertEqual(graph.edge_count(), 0)
        XCTAssertFalse(graph.has_vertex(id: vertex_id_3))
        XCTAssertFalse(graph.get_neighbors(id: vertex_id_1)!.contains(vertex_id_3))
    }
    
    
    func testAddEdge()
    {
        var graph = Graph<Int, Edge<Int>>()
        
        XCTAssertThrowsError(try graph.add_edge(from: 0, to: 1, edge: Edge()))
        XCTAssertEqual(graph.edge_count(), 0)
        XCTAssertFalse(graph.has_edge(from: 0, to: 1))
        XCTAssertEqual(graph.get_edges(), [:])
        
        let vertex_id_1 = graph.add_vertex(vertex: 10)
        XCTAssertThrowsError(try graph.add_edge(from: vertex_id_1, to: 1, edge: Edge()))
        XCTAssertThrowsError(try graph.add_edge(from: 1, to: vertex_id_1, edge: Edge()))
        XCTAssertEqual(graph.edge_count(), 0)
        XCTAssertFalse(graph.has_edge(from: 0, to: 1))
        XCTAssertEqual(graph.get_edges(), [:])
        
        let vertex_id_2 = graph.add_vertex(vertex: 20)
        XCTAssertNoThrow(try graph.add_edge(from: vertex_id_1, to: vertex_id_2, edge: Edge(weight: 10)))
        XCTAssertEqual(graph.edge_count(), 1)
        XCTAssertTrue(graph.has_edge(from: vertex_id_1, to: vertex_id_2))
        XCTAssertTrue(graph.has_edge(from: vertex_id_2, to: vertex_id_1))
        XCTAssertEqual(graph.get_edges(), [EdgeID(left: vertex_id_1, right: vertex_id_2):Edge(weight: 10)])
        XCTAssertEqual(graph.get_edge(from: vertex_id_1, to: vertex_id_2), Edge(weight: 10))
        XCTAssertEqual(graph.get_edge(from: vertex_id_2, to: vertex_id_1), Edge(weight: 10))
        XCTAssertEqual(graph.get_edge(id: EdgeID(left: vertex_id_1, right: vertex_id_2)), Edge(weight: 10))
        XCTAssertEqual(graph.get_edge(id: EdgeID(left: vertex_id_2, right: vertex_id_1)), Edge(weight: 10))
        
        XCTAssertNoThrow(try graph.add_edge(from: vertex_id_1, to: vertex_id_2, edge: Edge(weight: 20)))
        XCTAssertEqual(graph.edge_count(), 1)
        XCTAssertTrue(graph.has_edge(from: vertex_id_1, to: vertex_id_2))
        XCTAssertTrue(graph.has_edge(from: vertex_id_2, to: vertex_id_1))
        XCTAssertEqual(graph.get_edges(), [EdgeID(left: vertex_id_1, right: vertex_id_2):Edge(weight: 20)])
        XCTAssertEqual(graph.get_edge(from: vertex_id_1, to: vertex_id_2), Edge(weight: 20))
        XCTAssertEqual(graph.get_edge(from: vertex_id_2, to: vertex_id_1), Edge(weight: 20))
        XCTAssertEqual(graph.get_edge(id: EdgeID(left: vertex_id_1, right: vertex_id_2)), Edge(weight: 20))
        XCTAssertEqual(graph.get_edge(id: EdgeID(left: vertex_id_2, right: vertex_id_1)), Edge(weight: 20))
        
        XCTAssertNoThrow(try graph.add_edge(from: vertex_id_2, to: vertex_id_1, edge: Edge(weight: 30)))
        XCTAssertEqual(graph.edge_count(), 1)
        XCTAssertTrue(graph.has_edge(from: vertex_id_1, to: vertex_id_2))
        XCTAssertTrue(graph.has_edge(from: vertex_id_2, to: vertex_id_1))
        XCTAssertEqual(graph.get_edges(), [EdgeID(left: vertex_id_1, right: vertex_id_2):Edge(weight: 30)])
        XCTAssertEqual(graph.get_edge(from: vertex_id_1, to: vertex_id_2), Edge(weight: 30))
        XCTAssertEqual(graph.get_edge(from: vertex_id_2, to: vertex_id_1), Edge(weight: 30))
        XCTAssertEqual(graph.get_edge(id: EdgeID(left: vertex_id_1, right: vertex_id_2)), Edge(weight: 30))
        XCTAssertEqual(graph.get_edge(id: EdgeID(left: vertex_id_2, right: vertex_id_1)), Edge(weight: 30))
    }
    
    func testRemoveEdge()
    {
        var graph = Graph<Int, Edge<Int>>();
        
        let vertex_id_1 = graph.add_vertex(vertex: 10)
        let vertex_id_2 = graph.add_vertex(vertex: 20)
        let vertex_id_3 = graph.add_vertex(vertex: 30)
        
        XCTAssertNoThrow(try graph.add_edge(from: vertex_id_1, to: vertex_id_2, edge: Edge(weight: 10)))
        XCTAssertNoThrow(try graph.add_edge(from: vertex_id_2, to: vertex_id_3, edge: Edge(weight: 10)))
        XCTAssertNoThrow(try graph.add_edge(from: vertex_id_3, to: vertex_id_1, edge: Edge(weight: 10)))
        XCTAssertEqual(graph.edge_count(), 3)
        XCTAssertTrue(graph.get_neighbors(id: vertex_id_1)!.contains(vertex_id_2))
        XCTAssertTrue(graph.get_neighbors(id: vertex_id_2)!.contains(vertex_id_3))
        XCTAssertTrue(graph.get_neighbors(id: vertex_id_3)!.contains(vertex_id_1))
        
        graph.remove_edge(lhs: vertex_id_1, rhs: vertex_id_2)
        XCTAssertEqual(graph.edge_count(), 2)
        XCTAssertFalse(graph.get_neighbors(id: vertex_id_1)!.contains(vertex_id_2))
        XCTAssertFalse(graph.get_neighbors(id: vertex_id_2)!.contains(vertex_id_1))
        XCTAssertTrue(graph.get_neighbors(id: vertex_id_2)!.contains(vertex_id_3))
        
        graph.remove_edge(lhs: vertex_id_2, rhs: vertex_id_3)
        XCTAssertEqual(graph.edge_count(), 1)
        XCTAssertFalse(graph.get_neighbors(id: vertex_id_2)!.contains(vertex_id_3))
        XCTAssertFalse(graph.get_neighbors(id: vertex_id_3)!.contains(vertex_id_2))
        XCTAssertTrue(graph.get_neighbors(id: vertex_id_1)!.contains(vertex_id_3))
        
        graph.remove_edge(lhs: vertex_id_1, rhs: vertex_id_3)
        XCTAssertEqual(graph.edge_count(), 0)
        XCTAssertFalse(graph.get_neighbors(id: vertex_id_2)!.contains(vertex_id_3))
        XCTAssertFalse(graph.get_neighbors(id: vertex_id_3)!.contains(vertex_id_2))
        XCTAssertFalse(graph.get_neighbors(id: vertex_id_1)!.contains(vertex_id_3))
        
        graph.remove_edge(lhs: vertex_id_3, rhs: vertex_id_1)
        XCTAssertEqual(graph.edge_count(), 0)
        XCTAssertFalse(graph.get_neighbors(id: vertex_id_2)!.contains(vertex_id_3))
        XCTAssertFalse(graph.get_neighbors(id: vertex_id_3)!.contains(vertex_id_2))
        XCTAssertFalse(graph.get_neighbors(id: vertex_id_1)!.contains(vertex_id_3))
    }
}
