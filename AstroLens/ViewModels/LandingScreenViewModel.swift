import Foundation
import UIKit
import NASAApi

class LandingScreenViewModel {
    let loadingQueue = OperationQueue()
    var loadingOperations: [IndexPath: LandingScreenDataLoadOperation] = [:]
    let defaultImage = UIImage(named: "nasaDefault") ?? UIImage()
    
    init(numberOfPhotosToRetrieve: Int) {
        NASAApi.shared.dateBackNumberOfDays = numberOfPhotosToRetrieve
    }
    
    var numberOfPhotosToRetrieve: Int {
        return NASAApi.shared.dateBackNumberOfDays
    }
        
    func makeDataLoadOperation(atIndex index: Int, withCompletion completionHandler: @escaping ((PhotoOfTheDay) -> Void)) -> LandingScreenDataLoadOperation {
        return LandingScreenDataLoadOperation(atIndex: index, withCompletion: completionHandler)
    }
}
