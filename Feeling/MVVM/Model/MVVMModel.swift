import Foundation

struct WorldTimeApiResponse: Decodable {
    let formattedDateTime: String
    
    enum CodingKeys: String, CodingKey {
        case formattedDateTime = "datetime"
    }
}

struct Photo {
    let id: Int
    var imageName: String
    var description: String
    let creation_date: String
    
    static func fromDictionary(_ dictionary: [String: Any]) -> Photo? {
        guard
            let id = dictionary["id"] as? Int,
            let imageName = dictionary["imageName"] as? String,
            let description = dictionary["description"] as? String,
            let creation_date = dictionary["creation_date"] as? String
        else {
            return nil
        }
        return Photo(id: id, imageName: imageName, description: description, creation_date: creation_date)
    }

    func toDictionary() -> [String: Any] {
        return ["id": id, "imageName": imageName, "description": description, "creation_date": creation_date]
    }
}
