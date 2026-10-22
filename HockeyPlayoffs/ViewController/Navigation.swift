import AVKit
import CocoaLumberjackSwift
import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.backgroundColor()
        if #available(iOS 27.1, *) {
            registerForTraitChanges(UITraitCollection.systemTraitsAffectingVerticalBarEdge) {
                (controller: BaseViewController, _: UITraitCollection) in controller.updateNavigationBarMinimization()
            }
        }
        registerForTraitChanges([UITraitPreferredContentSizeCategory.self]) {
            (controller: BaseViewController, _: UITraitCollection) in
            for table in controller.view.subviews.compactMap({ $0 as? UITableView }) { table.reloadData() }
        }
        NotificationCenter.default.addObserver(
            self, selector: #selector(dismissVideo), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateNavigationBarMinimization()
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: .playoffsUpdated, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .playoffsUpdated, object: nil)
    }
    deinit { NotificationCenter.default.removeObserver(self) }
    private func updateNavigationBarMinimization() {
        if #available(iOS 27.1, *) {
            var configuration = navigationItem.navigationBarMinimization
            configuration.minimizationBehavior = traitCollection.verticalBarEdge == .unspecified ? .automatic : .never
            navigationItem.navigationBarMinimization = configuration
        }
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .allButUpsideDown }
    @objc func refresh() {}
    @objc private func dismissVideo() {
        if navigationController?.presentedViewController is AVPlayerViewController {
            navigationController?.dismiss(animated: true)
        }
    }
    func playHighlights(_ url: URL?) {
        guard let url else {
            ToastHandler.show(localized("error.video.title"))
            return
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch { DDLogError("Error configuring playback: \(error)") }
        let controller = AVPlayerViewController()
        controller.player = AVPlayer(url: url)
        controller.player?.isMuted = true
        navigationController?.present(controller, animated: true)
        controller.player?.play()
    }
    func install(_ scrollView: UIScrollView, readable: Bool = false) {
        view.addForLayout(scrollView)
        let guide = readable ? view.readableContentGuide : view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: readable ? -16 : 0),
            scrollView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: readable ? 16 : 0),
        ])
    }
    func installRefreshControl(on scrollView: UIScrollView) -> UIRefreshControl {
        let control = UIRefreshControl()
        control.tintColor = Colors.refreshControlColor()
        control.addTarget(self, action: #selector(reloadFromAPI(_:)), for: .valueChanged)
        scrollView.refreshControl = control
        return control
    }
    @objc private func reloadFromAPI(_ sender: UIRefreshControl) {
        Task { [weak self] in
            await APIRequestHandler.shared.refresh()
            self?.refresh()
            try? await Task.sleep(for: .milliseconds(300))
            sender.endRefreshing()
        }
    }
}

final class BaseUINavigationController: UINavigationController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .allButUpsideDown }
}

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let bracket = BracketViewController()
        let recent = RecentGamesViewController()
        bracket.tabBarItem = UITabBarItem(title: bracket.title, image: UIImage(named: "Bracket"), selectedImage: nil)
        recent.tabBarItem = UITabBarItem(title: recent.title, image: UIImage(named: "Recent"), selectedImage: nil)
        viewControllers = [bracket, recent].map { root in
            let navigation = BaseUINavigationController(rootViewController: root)
            if #available(iOS 26, *) {
            } else {
                navigation.navigationBar.standardAppearance.backgroundColor = Colors.navigationBarColor()
                navigation.navigationBar.scrollEdgeAppearance = navigation.navigationBar.standardAppearance
            }
            return navigation
        }
        if #available(iOS 26, *) {
        } else {
            tabBar.standardAppearance.backgroundColor = Colors.navigationBarColor()
            tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        }
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .allButUpsideDown }
}
