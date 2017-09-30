import UIKit

enum Teams: String {
    case carolineHurricanes = "car"
    case columbusBlueJackets = "cbj"
    case newJerseyDevils = "njd"
    case newYorkIslanders = "nyi"
    case newYorkRangers = "nyr"
    case philadelphiaFlyers = "phi"
    case pittsburghPenguins = "pit"
    case washingtonCaptials = "wsh"
    case bostonBruins = "bos"
    case buffaloSabres = "buf"
    case detroitRedWings = "det"
    case floridaPanthers = "fla"
    case montrealCanadiens = "mtl"
    case ottawaSenators = "ott"
    case tampaBayLightning = "tbl"
    case torontoMapleLeafs = "tor"
    case chicagoBlackhawks = "chi"
    case coloradoAvalanche = "col"
    case dallasStars = "dal"
    case minnesotaWild = "min"
    case nashvillePredators = "nsh"
    case stLouisBlues = "stl"
    case winnipegJets = "wpg"
    case anaheimDucks = "ana"
    case arizonaCoyotes = "ari"
    case calgaryFlames = "cgy"
    case edmontonOilers = "edm"
    case losAngelesKings = "lak"
    case sanJoseSharks = "sjs"
    case vancouverCanucks = "van"
    case vegasGoldenKnights = "vgk"

    //Old Teams
    case atlantaTrashers = "atl"
    case phoenixCoyotes = "phx"
}

extension Teams {

    var color: UIColor {
        switch self {
        case .carolineHurricanes:
            return UIColor(red: 159, green: 19, blue: 39)
        case .columbusBlueJackets:
            return UIColor(red: 0, green: 26, blue: 57)
        case .newJerseyDevils:
            return UIColor(red: 159, green: 10, blue: 39)
        case .newYorkIslanders:
            return UIColor(red: 201, green: 63, blue: 16)
        case .newYorkRangers:
            return UIColor(red: 0, green: 46, blue: 133)
        case .philadelphiaFlyers:
            return UIColor(red: 199, green: 56, blue: 22)
        case .pittsburghPenguins:
            return UIColor(red: 167, green: 161, blue: 126)
        case .washingtonCaptials:
            return UIColor(red: 158, green: 10, blue: 38)
        case .bostonBruins:
            return UIColor(red: 205, green: 146, blue: 14)
        case .buffaloSabres:
            return UIColor(red: 0, green: 26, blue: 57)
        case .detroitRedWings:
            return UIColor(red: 159, green: 10, blue: 39)
        case .floridaPanthers:
            return UIColor(red: 0, green: 26, blue: 57)
        case .montrealCanadiens:
            return UIColor(red: 134, green: 20, blue: 38)
        case .ottawaSenators:
            return UIColor(red: 159, green: 10, blue: 39)
        case .tampaBayLightning:
            return UIColor(red: 0, green: 30, blue: 80)
        case .torontoMapleLeafs:
            return UIColor(red: 0, green: 30, blue: 80)
        case .chicagoBlackhawks:
            return UIColor(red: 159, green: 10, blue: 39)
        case .coloradoAvalanche:
            return UIColor(red: 80, green: 31, blue: 49)
        case .dallasStars:
            return UIColor(red: 2, green: 57, blue: 39)
        case .minnesotaWild:
            return UIColor(red: 2, green: 57, blue: 39)
        case .nashvillePredators:
            return UIColor(red: 205, green: 146, blue: 14)
        case .stLouisBlues:
            return UIColor(red: 0, green: 41, blue: 113)
        case .winnipegJets:
            return UIColor(red: 0, green: 30, blue: 80)
        case .anaheimDucks:
            return UIColor(red: 201, green: 63, blue: 16)
        case .arizonaCoyotes:
            return UIColor(red: 104, green: 29, blue: 41)
        case .calgaryFlames:
            return UIColor(red: 159, green: 19, blue: 39)
        case .edmontonOilers:
            return UIColor(red: 0, green: 26, blue: 57)
        case .losAngelesKings:
            return UIColor(red: 27, green: 6, blue: 85)
        case .sanJoseSharks:
            return UIColor(red: 0, green: 83, blue: 96)
        case .vancouverCanucks:
            return UIColor(red: 0, green: 106, blue: 53)
        case .vegasGoldenKnights:
            return UIColor(red: 128, green: 114, blue: 79)

        //Old Teams
        case .atlantaTrashers:
            return UIColor(red: 0, green: 30, blue: 80)
        case .phoenixCoyotes:
            return UIColor(red: 104, green: 29, blue: 41)
        }
    }

    var name: String {
        switch self {
        default:
            return "tes"
        }
    }

    var city: String {
        switch self {
        default:
            return "tes"
        }
    }
}

fileprivate extension UIColor {
    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        self.init(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0)
    }
}
