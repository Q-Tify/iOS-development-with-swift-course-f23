import Foundation

func getCurrentDateTimeFromAPI(completion: @escaping (String?) -> Void) {
    let apiUrl = URL(string: "https://worldtimeapi.org/api/ip")!
    
    URLSession.shared.dataTask(with: apiUrl) { data, _, error in
        if let data = data, error == nil {
            do {
                let decoder = JSONDecoder()
                let apiResponse = try decoder.decode(WorldTimeApiResponse.self, from: data)
                let formattedDateTime = apiResponse.formattedDateTime
                completion(formattedDateTime)
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil)
            }
        } else {
            print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
            completion(nil)
        }
    }.resume()
}
