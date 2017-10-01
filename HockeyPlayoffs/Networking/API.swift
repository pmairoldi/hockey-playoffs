import Foundation

struct API {

    func fetchBracket(completion: @escaping ([Matchup]?) -> Void) {
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

                    response.series.forEach { (matchup) in
                        let games = response.games.filter { (game) -> Bool in
                            return game.gameId.starts(with: matchup.id) && game.active == true
                        }

                        games.forEach { game in
                            let periods = response.periods.filter { (period) -> Bool in
                                return period.gameId == game.gameId
                            }

                            let events = response.events.filter { (event) -> Bool in
                                return event.gameId == game.gameId
                            }

                            game.periods.append(objectsIn: periods)
                            game.events.append(objectsIn: events)
                        }

                        matchup.games.append(objectsIn: games)
                    }

                    completion(response.series)
                } catch {
                    completion(nil)
                }
            }

            task.resume()
        }
    }
}
