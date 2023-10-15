import Foundation

struct Contact: Codable, Hashable {
    let id: Int
    let name: String
    let email: String
    let phone: String
    let image: String
}
