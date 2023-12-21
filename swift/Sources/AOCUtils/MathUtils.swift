//
//  File.swift
//
//
//  Created by Matt Coomber on 08/12/2023.
//

import Foundation
import Numerics

public func lcm(a: Int, b: Int) -> Int {
  return a * b / gcd(a, b)
}

// Taken from here: https://stackoverflow.com/a/59461073
infix operator %%

extension Int {
  public static func %% (_ left: Int, _ right: Int) -> Int {
    if left >= 0 { return left % right }
    if left >= -right { return (left + right) }
    return ((left % right) + right) % right
  }
}
