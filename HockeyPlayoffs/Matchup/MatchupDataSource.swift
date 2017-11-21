import UIKit
import RealmSwift

class MatchupDataSource: NSObject, UITableViewDataSource {

    private let games: List<Game>

    init(games: List<Game>) {
        self.games = games
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: MatchupGameCell.reuseIdentifier, for: indexPath) as? MatchupGameCell else {
            fatalError()
        }

        cell.game = games[indexPath.row]

        return cell
    }
}
