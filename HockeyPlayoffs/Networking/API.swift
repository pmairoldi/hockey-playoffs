import Foundation

struct API {

    func fetchBracket(completion: @escaping (Bracket?) -> Void) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            let session = URLSession.shared
            let task = session.dataTask(with: URL(string: "\(Env.host)/playoffs")!) { (data, response, error) in
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
                    let response = try decoder.decode(Bracket.self, from: data)

                    completion(response)
                } catch {
                    completion(nil)
                }
            }

            task.resume()
        }
    }
}
