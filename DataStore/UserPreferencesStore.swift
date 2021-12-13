import Foundation

public protocol DataStore {
    func storeObject(forKey key: String, value: String)
    func removeObject(forKey key: String)
    func retrieveObject(forKey key: String) -> String?
}

public final class DataStoreImplementation: DataStore {
    public static let shared = DataStoreImplementation()
    
    public func storeObject(forKey key: String, value: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    public func removeObject(forKey key: String) {
        UserDefaults.standard.object(forKey: key)
    }
    
    public func retrieveObject(forKey key: String) -> String? {
        UserDefaults.standard.object(forKey: key) as? String
    }
}
