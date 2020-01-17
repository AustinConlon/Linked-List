struct LinkedList<Value> {
    // Properties are read-only outside of this type to ensure data consistency.
    private(set) var firstNode: Node?
    private(set) var lastNode: Node?
}

extension LinkedList {
    class Node {
        var value: Value
        // This linked list is doubly linked, so each node references both its previous and next neighbor. The reference to the previous node is `weak` to avoid retain cycles that would come from `strong` references in both directions.
        fileprivate weak var previous: Node?
        fileprivate var next: Node?
        
        init(value: Value) {
            self.value = value
        }
    }
}

/// `Sequence` conformance is to be able to iterate over and mutate properties.
extension LinkedList: Sequence {
    func makeIterator() -> AnyIterator<Value> {
        var node = firstNode
        
        return AnyIterator {
            // Iterate through all nodes by continuously moving to the next one and extracting its value.
            let value = node?.value
            node = node?.next
            return value
        }
    }
}

extension LinkedList {
    // Since `Node` isn't necessarily needed at this functions point of use, the compiler will not generate warnings in that case.
    @discardableResult
    mutating func append(_ value: Value) -> Node {
        let node = Node(value: value)
        node.previous = lastNode
        
        lastNode?.next = node
        lastNode = node
        
        if firstNode == nil {
            firstNode = node
        }
        
        return node
    }
}

extension LinkedList {
    mutating func remove(_ node: Node) {
        node.previous?.next = node.next
        node.next?.previous = node.previous
        
        // Identity comparisons.
        if firstNode === node {
            firstNode = node.next
        }
        
        if lastNode === node {
            lastNode = node.previous
        }
    }
}
