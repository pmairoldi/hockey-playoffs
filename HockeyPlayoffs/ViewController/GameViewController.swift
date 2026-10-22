import UIKit

final class GameViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    private let model: GameModel
    private let table = GamesTableView(kind: .game)
    init(game: GameObject) {
        model = GameModel(game: game)
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("Programmatic controller") }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = model.game.title
        navigationItem.largeTitleDisplayMode = .never
        table.hasContent = true
        table.delegate = self
        table.dataSource = self
        install(table, readable: true)
        _ = installRefreshControl(on: table)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }
    override func refresh() {
        model.refresh()
        table.reloadData()
        table.refreshControl?.endRefreshing()
    }
    func numberOfSections(in tableView: UITableView) -> Int { model.numberOfSections }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? (model.isRefreshing ? 1 : 0) : max(1, model.events(in: section).count)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        section == 0 ? GameHeader.height : GameDetailHeader.height
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        self.tableView(tableView, heightForHeaderInSection: section)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 { return 44 }
        return model.events(in: indexPath.section).isEmpty ? NoDataTableViewCell.height : UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        indexPath.section == 0 ? 44 : 80
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 { return tableView.dequeueReusableCell(withIdentifier: "refresh", for: indexPath) }
        let events = model.events(in: indexPath.section)
        if events.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "empty", for: indexPath)
            cell.textLabel?.text = model.noDataText
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "event", for: indexPath) as! GameDetailCell
        cell.setEvent(events[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "game") as! GameHeader
            header.setGame(model)
            header.sectionControl.selectedSegmentIndex = model.sectionIndex
            header.sectionControl.removeTarget(self, action: #selector(tabSwitched(_:)), for: .valueChanged)
            header.sectionControl.addTarget(self, action: #selector(tabSwitched(_:)), for: .valueChanged)
            header.videoButton.removeTarget(self, action: #selector(videoTapped), for: .touchUpInside)
            header.videoButton.addTarget(self, action: #selector(videoTapped), for: .touchUpInside)
            return header
        }
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "period") as! GameDetailHeader
        header.setPeriod(periodTitle(section))
        return header
    }
    @objc private func tabSwitched(_ sender: UISegmentedControl) {
        guard sender.selectedSegmentIndex != model.sectionIndex else { return }
        model.sectionIndex = sender.selectedSegmentIndex
        table.reloadData()
    }
    @objc private func videoTapped() { playHighlights(model.game.videoLinks.first) }
}
