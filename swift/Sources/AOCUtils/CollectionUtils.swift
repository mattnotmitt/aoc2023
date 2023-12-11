//
//  CollectionUtils.swift
//
//
//  Created by Matt Coomber on 11/12/2023.
//

import Foundation

// Source: https://stackoverflow.com/a/54505803
public func transpose(_ input: [[Character]], fill: Character = ".") -> [[Character]] {
  let columns = input.count
  let rows = input.reduce(0) { max($0, $1.count) }

  return (0..<rows).reduce(into: []) { result, row in
    result.append(
      (0..<columns).reduce(into: []) { result, column in
        result.append(row < input[column].count ? input[column][row] : fill)
      })
  }
}
