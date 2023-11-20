import Foundation

class PhotoViewModel {
    private let userDefaultsKey = "photos1"

    func savePhotosToUserDefaults(photos: [Photo]) {
        let photoDictionaries = photos.map { $0.toDictionary() }
        UserDefaults.standard.set(photoDictionaries, forKey: userDefaultsKey)
    }

    func getPhotosFromUserDefaults() -> [Photo] {
        if let photoDictionaries = UserDefaults.standard.array(forKey: userDefaultsKey) as? [[String: Any]] {
            return photoDictionaries.compactMap { Photo.fromDictionary($0) }
        }
        return []
    }
}
