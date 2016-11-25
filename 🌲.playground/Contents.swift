//: 🌲🌲🌲 playgrounds

import UIKit
import GameKit

class point: NSObject {
    var x: Float = 0
    var y: Float = 0
    var name: String = "?"
    var padding: Float = 0.05

    init(x: Float, y: Float, name: String) {
        self.x = x
        self.y = y
        self.name = name
    }

    override var description: String {
        return String(format: "%@ (%f,%f) ±%f", self.name, self.x, self.y, self.padding)
    }

    var v3: vector_float3 {
        return vector3(Float(self.x), Float(self.y), Float(1))
    }

    var v2: vector_float2 {
        return vector2(Float(self.x), Float(self.y))
    }

    var v2min: vector_float2 {
        return vector2(Float(self.x - self.padding), Float(self.y - self.padding))
    }

    var v2max: vector_float2 {
        return vector2(Float(self.x + self.padding), Float(self.y + self.padding))
    }
}

// https://developer.apple.com/reference/gameplaykit/gkoctree

func octree () {
    let p1 = point(x: 1, y: 1, name: "a")
    let p2 = point(x: 2, y: 2, name: "b")
    let p3 = point(x: 2, y: 1, name: "c")
    let points = [p1, p2, p3]

    let min = point(x:0, y: 0, name: "min")
    let max = point(x:3, y: 3, name: "max")

    let box = GKBox(boxMin: min.v3, boxMax: max.v3)
    let cellSize: Float = 0.5
    let tree = GKOctree(boundingBox: box, minimumCellSize: cellSize)

    for p in points {
        tree.add(p, at: p.v3)
    }

    // All
    tree.elements(in: box)

    // Expect to get back only p1, since p1 is the only one located in 0,0 - 1.5,1.5
    let half = point(x:1.5, y:1.5, name: "half")
    let halfBox = GKBox(boxMin: min.v3, boxMax: half.v3)

    tree.elements(in: halfBox)
    tree.elements(at: p1.v3)
}

octree()

// https://developer.apple.com/reference/gameplaykit/gkrtree

func rtree() {
    let p1 = point(x: 1, y: 1, name: "a")
    let p2 = point(x: 2, y: 2, name: "b")
    let p3 = point(x: 2, y: 1, name: "c")
    let points = [p1, p2, p3]

    let min = point(x:0, y: 0, name: "min")
    // let max = point(x:3, y: 3, name: "max")
    let half = point(x:2, y:2, name: "half")

    let tree = GKRTree(maxNumberOfChildren: 3)

    for p in points {
        tree.addElement(p, boundingRectMin: p.v2min, boundingRectMax: p.v2max, splitStrategy: GKRTreeSplitStrategy.reduceOverlap)
    }

    // expect to gate back only p1, since it is the only one in 0,0 - 1.5,1.5
    tree.elements(inBoundingRectMin: min.v2, rectMax: half.v2)
}

rtree()
