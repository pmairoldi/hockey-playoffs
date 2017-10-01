import UIKit

class SeriesView: UIView {

    fileprivate let top: TeamView
    fileprivate let bottom: TeamView

    let round: Round

    var data: Matchup? {
        didSet {
            top.data = data?.topTeam
            bottom.data = data?.bottomTeam
        }
    }

    init(round: Round) {

        self.round = round

        top = TeamView(position: .top)
        bottom = TeamView(position: .bottom)

        let seperater = UIView()
        seperater.translatesAutoresizingMaskIntoConstraints = false
        seperater.backgroundColor = UIColor.white

        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.darkGray
        clipsToBounds = true

        layer.cornerRadius = 10.0
        layer.borderWidth = 1.5
        layer.borderColor = UIColor.white.cgColor

        addSubview(top)
        addSubview(seperater)
        addSubview(bottom)

        //TODO: move to stackview?
        top.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        top.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        top.topAnchor.constraint(equalTo: topAnchor).isActive = true
        top.bottomAnchor.constraint(equalTo: seperater.topAnchor).isActive = true

        seperater.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        seperater.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        seperater.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        seperater.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        bottom.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        bottom.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        bottom.topAnchor.constraint(equalTo: seperater.bottomAnchor).isActive = true
        bottom.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
