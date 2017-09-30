import UIKit

enum TeamPosition {
    case top
    case bottom
}

class TeamView: UIView {
    
    fileprivate let teamLabel: UILabel
    fileprivate let scoreLabel: UILabel
    
    var data: Teams? {
        didSet {
            backgroundColor = data?.color
            teamLabel.text = data?.rawValue.uppercased()
            scoreLabel.text = "0"
        }
    }
    
    init(position: TeamPosition) {
        
        teamLabel = UILabel()
        teamLabel.translatesAutoresizingMaskIntoConstraints = false
        teamLabel.textColor = .white
        teamLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        teamLabel.textAlignment = NSTextAlignment.left
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textColor = .white
        scoreLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
        scoreLabel.textAlignment = NSTextAlignment.right
        
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        switch position {
        case .top:
            layoutMargins = UIEdgeInsetsMake(8, 6, 6, 6)
        case .bottom:
            layoutMargins = UIEdgeInsetsMake(6, 6, 8, 6)
        }
        
        addSubview(teamLabel)
        addSubview(scoreLabel)
                
        teamLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        teamLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        teamLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor).isActive = true
        
        scoreLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        scoreLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        scoreLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor).isActive = true
        scoreLabel.widthAnchor.constraint(equalToConstant: 10).isActive = true
        
        scoreLabel.leadingAnchor.constraint(equalTo: teamLabel.trailingAnchor, constant: 4).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}