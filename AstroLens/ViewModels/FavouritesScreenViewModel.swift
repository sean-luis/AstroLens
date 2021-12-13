import Foundation
import UIKit
import NASAApi
import DataStore

class FavouritesScreenViewModel {
    let defaultImage = UIImage(named: "nasaDefault") ?? UIImage()

    private var favouritedPhotosByDate: [String] {
        return storedPhotos.compactMap({
            DataStoreImplementation.shared.retrieveObject(forKey: $0.date)
        })
    }
    
    private var storedPhotos: [PhotoOfTheDay] {
        return NASAApi.shared.savedPhotos
    }
    
    var favouritedPhotos: [PhotoOfTheDay] {
        return storedPhotos.filter({
            favouritedPhotosByDate.contains($0.date)
        })
    }
}
