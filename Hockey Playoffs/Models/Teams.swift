import UIKit

enum Teams: String {
    case CarolineHurricanes = "car"
    case ColumbusBlueJackets = "cbj"
    case NewJerseyDevils = "njd"
    case NewYorkIslanders = "nyi"
    case NewYorkRangers = "nyr"
    case PhiladelphiaFlyers = "phi"
    case PittsburghPenguins = "pit"
    case WashingtonCaptials = "wsh"
    case BostonBruins = "bos"
    case BuffaloSabres = "buf"
    case DetroitRedWings = "det"
    case FloridaPanthers = "fla"
    case MontrealCanadiens = "mtl"
    case OttawaSenators = "ott"
    case TampaBayLightning = "tbl"
    case TorontoMapleLeafs = "tor"
    case ChicagoBlackhawks = "chi"
    case ColoradoAvalanche = "col"
    case DallasStars = "dal"
    case MinnesotaWild = "min"
    case NashvillePredators = "nsh"
    case StLouisBlues = "stl"
    case WinnipegJets = "wpg"
    case AnaheimDucks = "ana"
    case ArizonaCoyotes = "ari"
    case CalgaryFlames = "cgy"
    case EdmontonOilers = "edm"
    case LosAngelesKings = "lak"
    case SanJoseSharks = "sjs"
    case VancouverCanucks = "van"
    case VegasGoldenKnights = "vgk"
    
    //Old Teams
    case AtlantaTrashers = "atl"
    case PhoenixCoyotes = "phx"
}

extension Teams {
    
    var color: UIColor {
        switch self {
        case .CarolineHurricanes:
            return UIColor(red: 159, green: 19, blue: 39)
        case .ColumbusBlueJackets:
            return UIColor(red: 0, green: 26, blue: 57)
        case .NewJerseyDevils:
            return UIColor(red: 159, green: 10, blue: 39)
        case .NewYorkIslanders:
            return UIColor(red: 201, green: 63, blue: 16)
        case .NewYorkRangers:
            return UIColor(red: 0, green: 46, blue: 133)
        case .PhiladelphiaFlyers:
            return UIColor(red: 199, green: 56, blue: 22)
        case .PittsburghPenguins:
            return UIColor(red: 167, green: 161, blue: 126)
        case .WashingtonCaptials:
            return UIColor(red: 158, green: 10, blue: 38)
        case .BostonBruins:
            return UIColor(red: 205, green: 146, blue: 14)
        case .BuffaloSabres:
            return UIColor(red: 0, green: 26, blue: 57)
        case .DetroitRedWings:
            return UIColor(red: 159, green: 10, blue: 39)
        case .FloridaPanthers:
            return UIColor(red: 0, green: 26, blue: 57)
        case .MontrealCanadiens:
            return UIColor(red: 134, green: 20, blue: 38)
        case .OttawaSenators:
            return UIColor(red: 159, green: 10, blue: 39)
        case .TampaBayLightning:
            return UIColor(red: 0, green: 30, blue: 80)
        case .TorontoMapleLeafs:
            return UIColor(red: 0, green: 30, blue: 80)
        case .ChicagoBlackhawks:
            return UIColor(red: 159, green: 10, blue: 39)
        case .ColoradoAvalanche:
            return UIColor(red: 80, green: 31, blue: 49)
        case .DallasStars:
            return UIColor(red: 2, green: 57, blue: 39)
        case .MinnesotaWild:
            return UIColor(red: 2, green: 57, blue: 39)
        case .NashvillePredators:
            return UIColor(red: 205, green: 146, blue: 14)
        case .StLouisBlues:
            return UIColor(red: 0, green: 41, blue: 113)
        case .WinnipegJets:
            return UIColor(red: 0, green: 30, blue: 80)
        case .AnaheimDucks:
            return UIColor(red: 201, green: 63, blue: 16)
        case .ArizonaCoyotes:
            return UIColor(red: 104, green: 29, blue: 41)
        case .CalgaryFlames:
            return UIColor(red: 159, green: 19, blue: 39)
        case .EdmontonOilers:
            return UIColor(red: 0, green: 26, blue: 57)
        case .LosAngelesKings:
            return UIColor(red: 27, green: 6, blue: 85)
        case .SanJoseSharks:
            return UIColor(red: 0, green: 83, blue: 96)
        case .VancouverCanucks:
            return UIColor(red: 0, green: 106, blue: 53)
        case .VegasGoldenKnights:
            return UIColor(red: 128, green: 114, blue: 79)
            
        //Old Teams
        case .AtlantaTrashers:
            return UIColor(red: 0, green: 30, blue: 80)
        case .PhoenixCoyotes:
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
