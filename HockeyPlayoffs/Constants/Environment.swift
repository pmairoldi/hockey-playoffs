import UIKit

public class Environment: NSObject {
    public static let apiBaseUrl: String = {
        guard let baseURLProperty = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String else {
            fatalError("API_BASE_URL not found in Info.plist")
        }
        return baseURLProperty
    }()
}
