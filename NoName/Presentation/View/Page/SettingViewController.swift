import UIKit

class SettingViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "bgColor") ?? .white
        
        // 上部のカスタムビュー
        let labelContainerView1 = LabelContainer()
        labelContainerView1.configure(title: "広告を非表示にする", parentView: view)
        
        // 中央のカスタムビュー
        let labelContainerView2 = LabelContainer()
        labelContainerView2.configure(title: "アレルギー", bottomRadius: false, parentView: view)
        
        // 下部のカスタムビュー
        let labelContainerView3 = LabelContainer()
        labelContainerView3.configure(title: "嫌いな食べ物", topRadius: false, parentView: view)

        // Auto Layout 制約を設定
        NSLayoutConstraint.activate([
            labelContainerView1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            labelContainerView2.topAnchor.constraint(equalTo: labelContainerView1.bottomAnchor, constant: 16),
            labelContainerView3.topAnchor.constraint(equalTo: labelContainerView2.bottomAnchor, constant: 0)
        ])
    }
}
