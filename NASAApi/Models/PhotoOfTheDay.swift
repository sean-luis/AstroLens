import UIKit

public struct PhotoOfTheDay: Hashable {
    public private(set) var title: String
    public private(set) var date: String
    public private(set) var description: String
    public private(set) var image: UIImage?
    public private(set) var imageURL: String

    public func contains(_ filter: String?) -> Bool {
        guard let filterText = filter else { return true }
        if filterText.isEmpty { return true }
        let lowercasedFilter = filterText.lowercased()
        return title.lowercased().contains(lowercasedFilter)
    }
}
