import Foundation

extension Collection where Self.Index == Self.Indices.Iterator.Element {
    /**
     Returns an optional element. If the `index` does not exist in the collection, the subscript returns nil.

     - parameter safe: The index of the element to return, if it exists.

     - returns: An optional element from the collection at the specified index.
     */
    public subscript(safe i: Index) -> Self.Iterator.Element? {
        return at(i)
    }

    /**
     Returns an optional element. If the `index` does not exist in the collection, the function returns nil.

     - parameter index: The index of the element to return, if it exists.

     - returns: An optional element from the collection at the specified index.
     */
    public func at(_ i: Index) -> Self.Iterator.Element? {
        return indices.contains(i) ? self[i] : nil
    }
}
