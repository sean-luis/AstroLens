import Foundation
import UIKit
import NASAApi

class PhotoOfTheDayViewModel {
    let defaultImage = UIImage(named: "nasaDefault") ?? UIImage()
    
    init(numberOfPhotosToRetrieve: Int) {
        NASAApi.shared.dateBackNumberOfDays = numberOfPhotosToRetrieve
    }
    
    var numberOfPhotosToRetrieve: Int {
        return NASAApi.shared.dateBackNumberOfDays
    }
    
    func fetchPhotoOfTheDay(at index: Int, completionHandler: @escaping (PhotoOfTheDay) -> Void) {
        NASAApi.shared.fetchPhotoOfTheDay(at: index, completionHandler: completionHandler)
    }
    
    func isContentBeingLoadedForCorrectIndex(at indexPath: IndexPath, for visibleIndexPaths: [IndexPath]?, response: PhotoOfTheDay) -> Bool {
        guard let isIndexInRange = visibleIndexPaths?.contains(indexPath), isIndexInRange == true else { return false }
        let savedPhotos = NASAApi.shared.savedPhotos
        guard savedPhotos.indices.contains(indexPath.section) else { return false }
        guard response.imageURL == savedPhotos[indexPath.section].imageURL else {
            print("Loading image: \(response.imageURL), not equal to: \(String(describing: NASAApi.shared.savedPhotos[indexPath.section].imageURL))")
            return false
        }
        return true
    }
}
