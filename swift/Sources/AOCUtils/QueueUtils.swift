//
//  QueueUtils.swift
//
//
//  Created by Matt Coomber on 17/12/2023.
//

import Collections
import Foundation

public struct PriorityQueue<Element: Comparable & Hashable> {
  // Underlying datatype of Heap is very slow to search, so pair it with a Set
  var heap: Heap<Element>
  var set: Set<Element>

  public init(_ seq: any Sequence<Element>) {
    self.heap = Heap(seq)
    self.set = Set(seq)
  }

  public mutating func insert(_ n: Element) {
    heap.insert(n)
    set.insert(n)
  }

  public func contains(_ n: Element) -> Bool {
    set.contains(n)
  }

  public mutating func popMin() -> Element {
    let n = heap.popMin()!
    set.remove(n)
    return n
  }

  public func isEmpty() -> Bool {
    heap.isEmpty && set.isEmpty
  }
}
