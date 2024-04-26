import Foundation


enum GraphErros : Error {
    case indexAlreadyInUse(index: Int)
    case vertexDoesNotExist(vertex: Int)
}


struct Graph<VERTEX_T, EDGE_T>
{
    private var adjacency_list  : [Int : Set<Int>]  = [:]
    private var vertices        : [Int : VERTEX_T]  = [:]
    private var edges           : [EdgeID : EDGE_T] = [:]
    private var vertex_ids      : Int               = 0
    
    
    /// Query the number of vertices
    /// - Returns: Number of vertices
    func vertex_count() -> Int
    {
        return self.vertices.count
    }
    
    
    /// Query the number of edges
    /// - Returns: Number of edges
    func edge_count() -> Int
    {
        return self.edges.count
    }
    
    
    /// Get the internal vertices
    /// - Returns: Map from the vertex id to the user provided vertex
    func get_vertices() -> [Int : VERTEX_T]
    {
        return self.vertices
    }
    
    
    /// Get the internal edges
    /// - Returns: Map from EdgeID to the edge
    func get_edges() -> [EdgeID : EDGE_T]
    {
        return self.edges
    }
    
    
    /// Checks whether a vertex with given vertex id is contained in the graph
    /// - Parameter vertex: The id of the vertex to be checked
    /// - Returns: True if the certex is present, false if not
    func has_vertex(vertex: Int) -> Bool
    {
        return self.vertices[vertex] != nil
    }
    
    
    /// Checks whether two vertices are connected
    /// - Parameters:
    ///   - lhs: The first vertex of the edge
    ///   - rhs: The second vertex of the edge
    /// - Returns: True if there is an edge between the two vertices, false if not
    func has_edge(lhs: Int, rhs: Int) -> Bool
    {
        return self.edges[EdgeID(left: lhs, right: rhs)] != nil
    }
    
    
    /// Get the vertex with a certain vertex id
    /// - Parameter vertex: The vertex id of the wanted vertex
    /// - Returns: The vertex if found, nil otherwise
    func get_vertex(vertex: Int) -> VERTEX_T?
    {
        return self.vertices[vertex]
    }
    
    
    /// Get the edge between two vertices with their vertex id
    /// - Parameters:
    ///   - lhs: The vertex id of the first vertex
    ///   - rhs: The vertex id of the second vertex
    /// - Returns: The edge if it exists, nil otherwise
    func get_edge(lhs: Int, rhs: Int) -> EDGE_T?
    {
        return self.edges[EdgeID(left: lhs, right: rhs)]
    }
    
    
    /// Get the edge between two vertices with the edgeID
    /// - Parameter edge: The edge id of the edge
    /// - Returns: The edge if it exists, nil otherwise
    func get_edge(edge: EdgeID) -> EDGE_T?
    {
        return self.edges[edge]
    }
    
    
    /// Get a list of neighbour vertices
    /// - Parameter vertex: The vertex id of the vertex to find the neighbors of
    /// - Returns: A set with neighboring vertices, or nil if the vertex does not exist
    func get_neighbors(vertex: Int) -> Set<Int>?
    {
        return self.adjacency_list[vertex]
    }
    
    
    /// Add a vertex to the graph
    /// - Parameter vertex: The vertex to add
    /// - Returns: The vertex id given to the inserted vertex
    mutating func add_vertex(vertex: VERTEX_T) -> Int
    {
        // Search an index for the vertex
        while has_vertex(vertex: vertex_ids)
        {
            self.vertex_ids += 1;
        }
        
        // Add the vertex
        self.vertices[vertex_ids] = vertex
        return vertex_ids
    }
    
    
    /// Add a vertex to the graph with a given vertex id
    /// - Parameters:
    ///   - vertex: The vertex to add
    ///   - vertex_id: The wanted vertex id of the vertex
    /// - Returns: The vertex id given to the inserted vertex
    /// - Throws: When the wanted veretx id is already in use
    mutating func add_vertex(vertex: VERTEX_T, vertex_id: Int) throws -> Int
    {
        // Check if the index is already in use
        if has_vertex(vertex: vertex_id) {
            throw GraphErros.indexAlreadyInUse(index: vertex_id)
        }
        
        // If not in use, add vertex
        self.vertices[vertex_id] = vertex;
        return vertex_id;
    }
    
    
    /// Remove a vertex of the graph
    /// - Parameter vertex: The vertex id of the vertex to be removed
    mutating func remove_vertex(vertex: Int)
    {
        // Check if the vertex exists
        if let neighbors = self.adjacency_list[vertex] {
            // Remove all edges to and from the vertex
            for neighbor in neighbors {
                self.remove_edge(lhs: vertex, rhs: neighbor)
            }
        }
        
        // Remove the vertex from the data structures
        self.vertices.removeValue(forKey: vertex)
        self.adjacency_list.removeValue(forKey: vertex)
    }
    
    
    /// Add an edge to the graph between two vertices
    /// - Parameters:
    ///   - lhs: The vertex id of the first vertex
    ///   - rhs: The vertex id of the second vertex
    ///   - edge: The edge to be added
    /// - Throws: When either of the vertices does not exist
    mutating func add_edge(lhs: Int, rhs: Int, edge: EDGE_T) throws
    {
        // If one the vertices does not exist throw error
        if !has_vertex(vertex: lhs) {
            throw GraphErros.vertexDoesNotExist(vertex: lhs)
        }
        else if !has_vertex(vertex: rhs) {
            throw GraphErros.vertexDoesNotExist(vertex: rhs)
        }
        
        // Add the edges to the data structures
        self.edges[EdgeID(left: lhs, right: rhs)] = edge
        self.adjacency_list[lhs]!.insert(rhs)
        self.adjacency_list[rhs]!.insert(lhs)
    }
    
    
    /// Remove an edge from the graph
    /// - Parameters:
    ///   - lhs: The vertex id of the first vertex of the edge
    ///   - rhs: The vertex id of the second vertex of the edge
    mutating func remove_edge(lhs: Int, rhs: Int)
    {
        // Remove the edge from the data structures
        self.edges.removeValue(forKey: EdgeID(left: lhs, right: rhs))
        self.adjacency_list[lhs]?.remove(rhs)
        self.adjacency_list[rhs]?.remove(lhs)
    }
}
