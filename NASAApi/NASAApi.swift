import Foundation
import UIKit

public final class NASAApi {
    public static let shared = NASAApi()
    public private(set) var savedPhotos: [PhotoOfTheDay] = [] {
        didSet {
            let photosOrderedByDate = savedPhotos.sorted(by: { $0.date > $1.date })
            savedPhotos = photosOrderedByDate
        }
    }
    public private(set) var previousDates: [String] = []
    public var dateBackNumberOfDays = 7
    
    public func fetchPhotoOfTheDay(at index: Int, completionHandler: @escaping (PhotoOfTheDay) -> Void) {
        if !savedPhotos.isEmpty && previousDates[index] == findDateOfSavedPhoto(atIndex: index) {
            retrievePhotoOfTheDayFromStorage(atIndex: index, completionHandler: completionHandler)
        } else {
            retrievePhotoOfTheDayViaNetwork(atIndex: index, completionHandler: completionHandler)
        }
    }
    
    private func retrievePhotoOfTheDayFromStorage(atIndex index: Int, completionHandler:  @escaping (PhotoOfTheDay) -> Void) {
        guard savedPhotos.indices.contains(index) else { return }
        completionHandler(savedPhotos[index])
    }
    
    private func retrievePhotoOfTheDayViaNetwork(atIndex index: Int, completionHandler: @escaping (PhotoOfTheDay) -> Void) {
        previousDates = dates(datingBack: dateBackNumberOfDays)
        let urlString = "https://api.nasa.gov/planetary/apod?date=\( previousDates[index])&hd=true&api_key=DEMO_KEY"
        guard let url = URL(string: urlString) else { return }
        
        retrievePhotoOfTheDayContent(with: url, at: index, completionHandler: completionHandler)
    }
    
    private func retrievePhotoOfTheDayContent(with url: URL, at index: Int, completionHandler: @escaping (PhotoOfTheDay) -> Void) {
        let defaultContent = PhotoOfTheDay(title: "No content available for this date", date: findDateOfSavedPhoto(atIndex: index), description: "No content available for this date", image: nil, imageURL: "")
        URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data, error == nil else {
                print("A problem occured whilst trying to load with error: \(String(describing: error))")
                completionHandler(defaultContent)
                return
            }
            do {
                let response = try JSONDecoder().decode(PhotoOfTheDayResponse.self, from: data)
                
                DispatchQueue.global().async { [weak self] in
                    self?.loadImage(from: response, completionHandler: { content in
                        DispatchQueue.main.async { [weak self] in
                            self?.storeContent(content: content)
                        }
                        completionHandler(content)
                    })
                }
            } catch let parseError as NSError {
                completionHandler(defaultContent)
                print("Completed with parseError: \(parseError.localizedDescription)")
            }
        }).resume()
    }
    
    private func loadImage(from response: PhotoOfTheDayResponse, completionHandler: @escaping (PhotoOfTheDay) -> Void) {
        guard let imageURL = URL(string: response.imageURL), let data = try? Data(contentsOf: imageURL), let image = UIImage(data: data) else {
            completionHandler(PhotoOfTheDay(title: response.title,
                                            date: response.date,
                                            description: response.description,
                                            image: nil,
                                            imageURL: response.imageURL))
            return
        }
        completionHandler(PhotoOfTheDay(title: response.title,
                                        date: response.date,
                                        description: response.description,
                                        image: image,
                                        imageURL: response.imageURL))
    }
    
    private func storeContent(content: PhotoOfTheDay) {
        if !(savedPhotos.contains(where: { $0.date == content.date })) {
            savedPhotos.append(content)
        }
    }
    
    private func findDateOfSavedPhoto(atIndex index: Int) -> String {
        let savedPhotosOrderedByDate = savedPhotos.sorted(by: { $0.date > $1.date })
        guard index <= savedPhotosOrderedByDate.endIndex - 1 else { return "" }
        return savedPhotosOrderedByDate[index].date
    }
    
    private func makePhotoOfTheDay(withResponse response: PhotoOfTheDayResponse, image: UIImage?) -> PhotoOfTheDay {
        return PhotoOfTheDay(title: response.title, date: response.date, description: response.description, image: image, imageURL: response.imageURL)
    }
    
    private func dates(datingBack numberOfDays: Int) -> [String] {
        let calender = Calendar.current
        var date = calender.startOfDay(for: Date())
        var days = [String]()
        for _ in 1 ... numberOfDays {
            days.append(formattedDate(calender: calender, date: date, days: days))
            date = calender.date(byAdding: .day, value: -1, to: date)!
        }
        return days
    }
    
    private func formattedDate(calender: Calendar, date: Date, days: [String]) -> String {
        let day = calender.component(.day, from: date)
        let month = calender.component(.month, from: date)
        let year = calender.component(.year, from: date)
        var monthStr = "\(month)"
        var dayStr = "\(day)"
        if month < 10 {
            monthStr = "0\(monthStr)"
        }
        if day < 10 {
            dayStr = "0\(dayStr)"
        }
        return "\(year)-\(monthStr)-\(dayStr)"
    }
}
