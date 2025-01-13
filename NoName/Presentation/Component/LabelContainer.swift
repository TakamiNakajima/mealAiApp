import UIKit

class LabelContainer: UIView {
    private let titleLabel = UILabel()
    private let containerView = UIView()
    private var cornersToRound: UIRectCorner = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false

        // コンテナビューの設定
        containerView.backgroundColor = .systemGray5
        containerView.layer.masksToBounds = true
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // ラベルの設定
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        titleLabel.textColor = .darkGray
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // コンテナビューとラベルを追加
        addSubview(containerView)
        addSubview(titleLabel)
                
        // Auto Layout 制約を設定
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 48),
            
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
    
    // Configureメソッドに上下の角丸の設定を追加
    func configure(title: String, topRadius: Bool = true, bottomRadius: Bool = true, parentView: UIView) {
        titleLabel.text = title
        containerView.backgroundColor = UIColor(named: "bgColor")
        
        // 上下の角丸をフラグで管理
        var corners: UIRectCorner = []
        if topRadius {
            corners.insert([.topLeft, .topRight])
        }
        if bottomRadius {
            corners.insert([.bottomLeft, .bottomRight])
        }
        
        cornersToRound = corners
        
        // 親ビューに追加し、左右の固定値を設定
        parentView.addSubview(self)
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 24),
            self.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -24)
        ])
        
        setNeedsLayout()
    }
    
    private func applyRoundedCorners(corners: UIRectCorner) {
        let path = UIBezierPath(roundedRect: containerView.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: 12, height: 12))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        containerView.layer.mask = mask
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyRoundedCorners(corners: cornersToRound)
    }
}
