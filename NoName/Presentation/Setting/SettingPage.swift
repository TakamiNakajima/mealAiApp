import UIKit

class SettingPage: UIViewController {
    let scrollView = UIScrollView()
    let contentView = UIView()
    let settingLabel = HeaderLabel(title: "課金")
    let labelContainerView1 = SettingComponent()
    let mySettingLabel = HeaderLabel(title: "My設定")
    let labelContainerView2 = SettingComponent()
    let labelContainerView3 = SettingComponent()
    let accountLabel = HeaderLabel(title: "アカウント")
    let logoutContainer = SettingComponent()
    let deleteAccountContainer = SettingComponent()
    let aboutAppLabel = HeaderLabel(title: "アプリについて")
    let formContainer = SettingComponent()
    let termContainer = SettingComponent()
    let privacyContainer = SettingComponent()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // スクロールビューの制約
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // 各ラベルとコンテナを追加
        contentView.addSubview(settingLabel)
        labelContainerView1.configure(title: "広告を非表示にする", parentView: contentView, destinationVC: {
            return BillingPage()
        })
        contentView.addSubview(mySettingLabel)
        labelContainerView2.configure(title: "アレルギー", bottomRadius: false, parentView: contentView, destinationVC: {
            return BillingPage()
        })
        labelContainerView3.configure(title: "嫌いな食べ物", topRadius: false, parentView: contentView, destinationVC: {
            return BillingPage()
        })
        contentView.addSubview(accountLabel)
        logoutContainer.configure(title: "ログアウト", bottomRadius: false, parentView: contentView, destinationVC: {
            return LogoutPage()
        })
        deleteAccountContainer.configure(title: "退会", topRadius: false, parentView: contentView, destinationVC: {
            return BillingPage()
        })
        contentView.addSubview(aboutAppLabel)
        formContainer.configure(title: "お問い合わせ", bottomRadius: false, parentView: contentView, destinationVC: {
            return BillingPage()
        })
        termContainer.configure(title: "利用規約", topRadius: false, bottomRadius: false, parentView: contentView, destinationVC: {
            return BillingPage()
        })
        privacyContainer.configure(title: "プライバシーポリシー", topRadius: false, parentView: contentView, destinationVC: {
            return BillingPage()
        })
        
        // コンテントビュー内の制約を設定
        NSLayoutConstraint.activate([
            settingLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 50),
            labelContainerView1.topAnchor.constraint(equalTo: settingLabel.bottomAnchor, constant: 8),
            mySettingLabel.topAnchor.constraint(equalTo: labelContainerView1.bottomAnchor, constant: 24),
            labelContainerView2.topAnchor.constraint(equalTo: mySettingLabel.bottomAnchor, constant: 8),
            labelContainerView3.topAnchor.constraint(equalTo: labelContainerView2.bottomAnchor, constant: 0),
            accountLabel.topAnchor.constraint(equalTo: labelContainerView3.bottomAnchor, constant: 24),
            logoutContainer.topAnchor.constraint(equalTo: accountLabel.bottomAnchor, constant: 8),
            deleteAccountContainer.topAnchor.constraint(equalTo: logoutContainer.bottomAnchor, constant: 0),
            aboutAppLabel.topAnchor.constraint(equalTo: deleteAccountContainer.bottomAnchor, constant: 24),
            formContainer.topAnchor.constraint(equalTo: aboutAppLabel.bottomAnchor, constant: 8),
            termContainer.topAnchor.constraint(equalTo: formContainer.bottomAnchor, constant: 0),
            privacyContainer.topAnchor.constraint(equalTo: termContainer.bottomAnchor, constant: 0),
            privacyContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}
