//
//  Edge.swift
//  GraafKit
//
//  Created by Seppe Degryse on 25/04/2024.
//

import Foundation


struct Edge<WEIGHT_T:Comparable> : Equatable
{
    static func == (lhs: Edge<WEIGHT_T>, rhs: Edge<WEIGHT_T>) -> Bool {
        return lhs.weight == rhs.weight
    }
    
    private var weight : WEIGHT_T
    
    init(weight: WEIGHT_T) {
        self.weight = weight
    }
    
    
    func get_weight() -> WEIGHT_T
    {
        return self.weight
    }
}


extension Edge where WEIGHT_T == Int {
    init() {
        self.init(weight: 1)
    }
}


struct EdgeID : Hashable
{
    var left : Int
    var right : Int
      
    func hash(into hasher: inout Hasher)
    {
        hasher.combine(left)
        hasher.combine(right)
    }
    
    init(left: Int, right: Int)
    {
        if left <= right
        {
            self.left = left
            self.right = right
        }
        else
        {
            self.left = right
            self.right = left
        }
    }
}
