import Foundation

struct API {

    func fetchBracket(completion: @escaping (Bracket?) -> Void) {
        request("/playoffs", completion: completion)
    }

    private func request<T: Decodable>(_ endpoint: String, completion: @escaping (T?) -> Void) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            let session = URLSession.shared
            let task = session.dataTask(with: URL(string: "\(Env.host)\(endpoint)")!) { (data, response, error) in
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
                    let response = try decoder.decode(T.self, from: data)

                    completion(response)
                } catch {
                    completion(nil)
                }
            }

            task.resume()
        }
    }
}
