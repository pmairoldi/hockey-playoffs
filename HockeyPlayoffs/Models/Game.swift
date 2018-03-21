import Foundation
import RealmSwift

class Game: Object, Codable {
    @objc dynamic var id: String = ""
    @objc dynamic var awayTeam: GameTeam?
    @objc dynamic var homeTeam: GameTeam?
    @objc dynamic var period: Int = 0 //TODO: make enum of 1, 2, 3, ot(Int = 0)
    @objc dynamic var periodTime: String = ""
    @objc dynamic var date: String = ""
    @objc dynamic var time: String = ""
    @objc dynamic var tv: String = ""
    @objc dynamic var active: Bool = true

    let periods: List<Period> = List<Period>()
    let events: List<Event> = List<Event>()

    override static func primaryKey() -> String? {
        return "id"
    }

    enum CodingKeys: String, CodingKey {
        case id
        case awayTeam
        case homeTeam
        case period
        case periodTime
        case date
        case time
        case tv
        case active
    }

//    func getGameStatus() -> String {
//
//        if (period == 0) {
//            //not started show game time
//
//            NSString *date = [DateTimeHandler getDateForDate:_date andTime:_time]
//            NSString *time = [DateTimeHandler getTimeForDate:_date andTime:_time]
//
//            return [NSString stringWithFormat:@"%@\n%@", date, time]
//        } else {
//            //started show period data
//            NSString *periodTime
//
//            if (_periodTime.length != 0) {
//                periodTime = NSLocalizedString(_periodTime, nil)
//            } else {
//                periodTime = @"20:00"
//            }
//
//            NSString *periodTitle
//
//            switch (_period) {
//
//            case 0:
//                periodTitle = NSLocalizedString(@"period.first.short", nil)
//                break
//
//            case 1:
//                periodTitle = NSLocalizedString(@"period.first.short", nil)
//                break
//
//            case 2:
//                periodTitle = NSLocalizedString(@"period.second.short", nil)
//                break
//
//            case 3:
//                periodTitle = NSLocalizedString(@"period.third.short", nil)
//                break
//
//            case 4:
//                periodTitle = NSLocalizedString(@"period.ot.short", nil)
//                break
//
//            case 5:
//                periodTitle = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"period.second.short", nil), NSLocalizedString(@"period.ot.short", nil)]
//                break
//
//            case 6:
//                periodTitle = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"period.third.short", nil), NSLocalizedString(@"period.ot.short", nil)]
//                break
//
//            default:
//                periodTitle = [NSString stringWithFormat:@"%d%@ %@", _period-3, NSLocalizedString(@"period.number.ending", nil), NSLocalizedString(@"period.ot.short", nil)]
//                break
//            }
//
//            return [NSString stringWithFormat:@"%@\n%@", periodTime, periodTitle]
//        }
//    }
}
