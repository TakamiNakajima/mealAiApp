import UIKit

class SettingComponent: UIView {
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let arrowImageView = UIImageView()
    private var cornersToRound: UIRectCorner = []
    private var destinationViewController: (() -> UIViewController)?

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
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        titleLabel.textColor = .darkGray
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        // 矢印アイコンの設定
        arrowImageView.image = UIImage(systemName: "chevron.right") // SF Symbols を使用
        arrowImageView.contentMode = .scaleAspectFit
        arrowImageView.tintColor = .darkGray
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false

        // タップジェスチャーを追加
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        containerView.addGestureRecognizer(tapGesture)
        containerView.isUserInteractionEnabled = true

        // コンテナビューとラベル、アイコンを追加
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(arrowImageView)

        // Auto Layout 制約を設定
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 48),

            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),

            arrowImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            arrowImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 16),
            arrowImageView.heightAnchor.constraint(equalToConstant: 16),

            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: arrowImageView.leadingAnchor, constant: -8)
        ])
    }

    // Configureメソッドに遷移先の設定を追加
    func configure(title: String, topRadius: Bool = true, bottomRadius: Bool = true, parentView: UIView, destinationVC: @escaping () -> UIViewController) {
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
        destinationViewController = destinationVC

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

    // タップイベント処理
    @objc private func handleTap() {
        guard let viewController = destinationViewController?() else { return }
        
        if let parentVC = findParentViewController() {
            parentVC.navigationController?.pushViewController(viewController, animated: true)
        }
    }

    // 親ビューのUIViewControllerを見つけるヘルパーメソッド
    private func findParentViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while let nextResponder = responder?.next {
            responder = nextResponder
            if let viewController = responder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
