import UIKit

extension UIColor {

    convenience init(redComponent: CGFloat, greenComponent: CGFloat, blueComponent: CGFloat, alpha: CGFloat = 1.0) {
        self.init(red: redComponent/255.0, green: greenComponent/255.0, blue: blueComponent/255.0, alpha: alpha)
    }

    class var tint: UIColor {
        return UIColor(redComponent: 0.0, greenComponent: 122.0, blueComponent: 255.0)
    }

    class var darkGray: UIColor {
        return UIColor(redComponent: 51.0, greenComponent: 51.0, blueComponent: 51.0)
    }

    class var lightGray: UIColor {
        return UIColor(redComponent: 92.0, greenComponent: 92.0, blueComponent: 92.0)
    }

    class var light: UIColor {
        return .white
    }

    class var ultraLightGray: UIColor {
        return UIColor(redComponent: 220.0, greenComponent: 220.0, blueComponent: 220.0)
    }

    class var background: UIColor {
        return .darkGray
    }

    class var seriesBackground: UIColor {
        return .light
    }

    class var seriesBorder: UIColor {
        return .light
    }

    class var seriesActiveBorder: UIColor {
        return .tint
    }

    class var seriesSelected: UIColor {
        return UIColor(white: 0.7, alpha: 0.7)
    }

    class var bracketLine: UIColor {
        return .light
    }

    class var seriesTeamName: UIColor {
        return .light
    }

    class var seriesTeamWins: UIColor {
        return .light
    }

    class var seriesHeaderBackground: UIColor {
        return .light
    }

    class var gameBackground: UIColor {
        return .light
    }

    class var gameCellStatusText: UIColor {
        return .darkGray
    }

    class var gameCellTeamText: UIColor {
        return .lightGray
    }

    class var tableViewSeperator: UIColor {
        return .ultraLightGray
    }

    class var navigationBar: UIColor {
        return .white
    }

    class var gameDetailCellText: UIColor {
        return .darkGray
    }

    class var gameDetailCellTime: UIColor {
        return .lightGray
    }

    class var gameDetailHeaderText: UIColor {
        return .darkGray
    }

    class var gameDetailHeaderBackground: UIColor {
        return .ultraLightGray
    }

    class var gameCellScore: UIColor {
        return .darkGray
    }

    class var periodScoreBackground: UIColor {
        return .darkGray
    }

    class var periodScoreSeperator: UIColor {
        return .light
    }

    class var segmentBackground: UIColor {
        return .clear
    }

    class var segmentTint: UIColor {
        return .tint
    }

    class var periodScoreViewHeaderFont: UIColor {
        return .lightGray
    }

    class var videoButtonDisabled: UIColor {
        return .ultraLightGray
    }

    class var videoButtonUnselected: UIColor {
        return .tint
    }

    class var videoButtonSelected: UIColor {
        return .lightGray
    }

    class var seriesCellBackground: UIColor {
        return UIColor(redComponent: 200.0, greenComponent: 200.0, blueComponent: 200.0)
    }

    class var expandedVideoBackground: UIColor {
        return .light
    }

    class var gameLabelText: UIColor {
        return .lightGray
    }
}
