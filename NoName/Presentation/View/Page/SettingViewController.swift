import UIKit

class SettingViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // 上部のカスタムビューを作成
        let labelContainerView1 = LabelContainerView()
        labelContainerView1.translatesAutoresizingMaskIntoConstraints = false
        labelContainerView1.configure(labelText: "課金", containerColor: .systemGray5)
        
        // 下部のカスタムビューを作成
        let labelContainerView2 = LabelContainerView()
        labelContainerView2.translatesAutoresizingMaskIntoConstraints = false
        labelContainerView2.configure(labelText: "My設定", containerColor: .systemGray5)
        
        // カスタムビューを親ビューに追加
        view.addSubview(labelContainerView1)
        view.addSubview(labelContainerView2)
        
        // Auto Layout 制約を設定
        NSLayoutConstraint.activate([
            // 上部のカスタムビューの制約
            labelContainerView1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            labelContainerView1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            labelContainerView1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            
            // 下部のカスタムビューの制約
            labelContainerView2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            labelContainerView2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            labelContainerView2.topAnchor.constraint(equalTo: labelContainerView1.bottomAnchor, constant: 16)
        ])
    }
}
