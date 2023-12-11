extension Range {

  public init(unorderedLeft left: Bound, right: Bound) {
    if left <= right {
      self.init(uncheckedBounds: (left, right))
    } else {
      self.init(uncheckedBounds: (right, left))
    }
  }
}
