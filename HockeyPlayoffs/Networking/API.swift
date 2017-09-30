import Foundation

struct API {

    func fetchBracket(completion: @escaping (Response?) -> Void) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            let session = URLSession.shared
            let task = session.dataTask(with: URL(string: "\(Env.host)/Hockey/Playoffs")!) { (data, response, error) in
                guard error == nil else {
                    completion(nil)
                    return
                }

                guard let data = data else {
                    completion(nil)
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(Response.self, from: data)

                    completion(response)
                } catch {
                    completion(nil)
                }
            }

            task.resume()
        }
    }
}
