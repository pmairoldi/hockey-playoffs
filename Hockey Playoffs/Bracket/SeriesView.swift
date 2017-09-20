import UIKit

class SeriesView: UIView {
    
    init() {
        super.init(frame: CGRect.zero)
        translatesAutoresizingMaskIntoConstraints = false;
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }
}
