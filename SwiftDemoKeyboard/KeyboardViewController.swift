import UIKit
import SnapKit

class KeyboardViewController: UIInputViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("his偶有、\(self.hasFullAccess)")
        
        // 设置键盘背景颜色
        view.backgroundColor = UIColor.lightGray
        
        // 创建一个简单的按键
        let button = createButton(title: "Add")
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        
        // 添加按键到键盘视图
        view.addSubview(button)
        
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        let button1 = createButton(title: "跳到原生页面")
        button1.addTarget(self, action: #selector(didClickOriginPage), for: .touchUpInside)
        view.addSubview(button1)
        button1.snp.makeConstraints { make in
            make.top.equalTo(button.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc func didClickOriginPage() {
        if let url = URL(string: "loveapp://openWishView") {
            self.extensionContext?.open(url, completionHandler: { result in
                print("可以跳可以跳可以跳可以跳\(result)----")
            })
        }
    }
    
    // 创建按键
    func createButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        return button
    }
    
    // 按键点击事件
    @objc func didTapButton(_ sender: UIButton) {
        let proxy = textDocumentProxy as UITextDocumentProxy
        proxy.insertText(sender.currentTitle!)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.updateKeyboardHeight(to: 500)
        
    }
    
    func updateKeyboardHeight(to height: CGFloat) {
        for constraint in self.view.constraints {
            if constraint.firstAttribute == .height {
                constraint.constant = height
                break
            }
        }
    }
}
