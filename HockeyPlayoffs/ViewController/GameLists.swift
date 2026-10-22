import UIKit

// One owner for game-row navigation and highlights in both lists.
class GameListViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    let table: GamesTableView
    var games: [GameObject] { [] }
    init(kind: GamesTableView.Kind) {
        table = GamesTableView(kind: kind)
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("Programmatic controller") }
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        install(table, readable: self is SeriesViewController)
        _ = installRefreshControl(on: table)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }
    func numberOfSections(in tableView: UITableView) -> Int { 1 }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { games.count }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { GameOverviewView.height }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        self.tableView(tableView, heightForRowAt: indexPath)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "game", for: indexPath) as! GameCell
        cell.setGame(games[indexPath.row])
        cell.videoButton.tag = indexPath.row
        cell.videoButton.removeTarget(self, action: #selector(videoTapped(_:)), for: .touchUpInside)
        cell.videoButton.addTarget(self, action: #selector(videoTapped(_:)), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard games.indices.contains(indexPath.row) else { return }
        navigationController?.pushViewController(GameViewController(game: games[indexPath.row]), animated: true)
        navigationController?.setNavigationBarHidden(false, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    @objc private func videoTapped(_ sender: VideoButton) {
        guard games.indices.contains(sender.tag) else { return }
        playHighlights(games[sender.tag].videoLinks.first)
    }
}

final class RecentGamesViewController: GameListViewController {
    private let model = RecentGamesModel()
    private let datePicker = UIDatePicker()
    override var games: [GameObject] { model.games }
    init() {
        super.init(kind: .recent)
        title = localized("controller.recent.title")
    }
    required init?(coder: NSCoder) { fatalError("Programmatic controller") }
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.tintColor = Colors.tintColor()
        datePicker.date = model.date
        datePicker.addTarget(self, action: #selector(onDateChange(_:)), for: .valueChanged)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        let width = datePicker.widthAnchor.constraint(equalToConstant: scaled(144, style: .body))
        NSLayoutConstraint.activate([width, datePicker.heightAnchor.constraint(greaterThanOrEqualToConstant: 44)])
        registerForTraitChanges([UITraitPreferredContentSizeCategory.self]) {
            (_: RecentGamesViewController, _: UITraitCollection) in width.constant = scaled(144, style: .body)
        }
        let item = UIBarButtonItem(customView: datePicker)
        if #available(iOS 26, *) { item.hidesSharedBackground = true }
        navigationItem.rightBarButtonItem = item
    }
    override func refresh() {
        model.refresh()
        table.hasContent = !games.isEmpty
        table.reloadData()
        table.refreshControl?.endRefreshing()
    }
    @objc private func onDateChange(_ sender: UIDatePicker) {
        model.date = sender.date
        refresh()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { .leastNormalMagnitude }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { 8 }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! GameCell
        cell.showsBottomSeparator = indexPath.row + 1 < games.count
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        var corners: CACornerMask = []
        if indexPath.row == 0 { corners.formUnion([.layerMinXMinYCorner, .layerMaxXMinYCorner]) }
        if indexPath.row == games.count - 1 { corners.formUnion([.layerMinXMaxYCorner, .layerMaxXMaxYCorner]) }
        cell.layer.cornerRadius = 24
        cell.layer.cornerCurve = .continuous
        cell.layer.maskedCorners = corners
        cell.clipsToBounds = true
    }
}

final class SeriesViewController: GameListViewController {
    private let model: SeriesModel
    override var games: [GameObject] { model.games }
    init(series: SeriesObject) {
        model = SeriesModel(series: series)
        super.init(kind: .series)
    }
    required init?(coder: NSCoder) { fatalError("Programmatic controller") }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = model.series.title
        navigationItem.largeTitleDisplayMode = .never
    }
    override func refresh() {
        model.refresh()
        table.hasContent = !games.isEmpty
        table.reloadData()
        table.refreshControl?.endRefreshing()
    }
    override func numberOfSections(in tableView: UITableView) -> Int { 2 }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? (model.isRefreshing ? 1 : 0) : games.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        indexPath.section == 0 && games.isEmpty ? 44 : GameOverviewView.height
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        section == 0 && model.hasTeams ? SeriesHeader.height : .leastNormalMagnitude
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        self.tableView(tableView, heightForHeaderInSection: section)
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 && model.hasTeams else { return nil }
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "series") as! SeriesHeader
        header.setSeries(model)
        return header
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 { return tableView.dequeueReusableCell(withIdentifier: "refresh", for: indexPath) }
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section > 0 { super.tableView(tableView, didSelectRowAt: indexPath) }
    }
}
