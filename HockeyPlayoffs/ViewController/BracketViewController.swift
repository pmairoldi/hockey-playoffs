import UIKit

final class BracketViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private let bracketView = BracketView()
    private let model = BracketModel()
    private var refreshControl: UIRefreshControl!
    init() {
        super.init(nibName: nil, bundle: nil)
        title = localized("controller.bracket.title")
    }
    required init?(coder: NSCoder) { fatalError("Programmatic controller") }
    override func viewDidLoad() {
        super.viewDidLoad()
        bracketView.delegate = self
        bracketView.dataSource = self
        install(bracketView)
        refreshControl = installRefreshControl(on: bracketView)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        refresh()
    }
    override func refresh() {
        model.refresh()
        bracketView.reloadData()
        refreshControl?.endRefreshing()
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int { BracketModel.counts.count }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        BracketModel.counts[section]
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "series", for: indexPath) as! SeriesCell
        cell.setSeries(model.getSeriesAtIndex(indexPath), refreshing: model.isRefreshing)
        return cell
    }
    func collectionView(
        _ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let connector =
            collectionView.dequeueReusableSupplementaryView(
                ofKind: kind, withReuseIdentifier: "connector", for: indexPath) as! BracketSection
        connector.configure(bracket: bracketView, section: indexPath.section)
        return connector
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let series = model.getSeriesAtIndex(indexPath) else { return }
        navigationController?.pushViewController(SeriesViewController(series: series), animated: true)
        navigationController?.setNavigationBarHidden(false, animated: true)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    func collectionView(
        _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize { bracketView.itemSize(indexPath.section) }
    func collectionView(
        _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets { bracketView.sectionInsets(section) }
    func collectionView(
        _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat { bracketView.spacing(section) }
    func collectionView(
        _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat { 0 }
    func collectionView(
        _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize { bracketView.headerSize(section) }
}
