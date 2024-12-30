import UIKit

class LabelContainerView: UIView {
    
    // ラベルとコンテナビューを公開
    private let label = UILabel()
    private let containerView = UIView()
    
    // 初期化
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        // ラベルの設定
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // コンテナビューの設定
        containerView.backgroundColor = .systemGray5 // 任意の背景色
        containerView.layer.cornerRadius = 12
        containerView.layer.masksToBounds = true
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // サブビューに追加
        addSubview(label)
        addSubview(containerView)
        
        // Auto Layout 制約を設定
        NSLayoutConstraint.activate([
            // ラベルの制約
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.topAnchor.constraint(equalTo: topAnchor),
            
            // コンテナビューの制約
            containerView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 60),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // ラベルのテキストを変更できるメソッド
    func configure(labelText: String, containerColor: UIColor) {
        label.text = labelText
        containerView.backgroundColor = containerColor
    }
}
