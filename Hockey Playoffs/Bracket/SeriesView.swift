import UIKit

class SeriesView: UIView {
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    init() {
        super.init(frame: CGRect.zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.darkGray
        clipsToBounds = true
        
        layer.cornerRadius = 8.0
        layer.borderWidth = 2.0
        layer.borderColor = UIColor.white.cgColor
        
        let top = UIView()
        top.translatesAutoresizingMaskIntoConstraints = false
        top.backgroundColor = UIColor.red
        
        let bottom = UIView()
        bottom.translatesAutoresizingMaskIntoConstraints = false
        bottom.backgroundColor = UIColor.blue
        
        let seperater = UIView()
        seperater.translatesAutoresizingMaskIntoConstraints = false
        seperater.backgroundColor = UIColor.white
        
        addSubview(top)
        addSubview(seperater)
        addSubview(bottom)

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
}
