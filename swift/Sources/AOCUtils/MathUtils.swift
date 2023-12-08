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
