//
//  LoginViewController.swift
//  NCMBiOS_User
//
//  Created by naokits on 6/23/15.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // ------------------------------------------------------------------------
    // MARK: - Lifecycle
    // ------------------------------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // ------------------------------------------------------------------------
    // MARK: - Navigation
    // ------------------------------------------------------------------------

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    /// ログイン or 新規登録が成功した場合の処理
    ///
    /// :param: user NCMBUserインスタンス
    /// :returns: None
    func successLoginOrSignupForUser(user: NCMBUser) {
        println("会員登録後の処理")
        // ACLを本人のみに設定
        let acl = NCMBACL(user: NCMBUser.currentUser())
        user.ACL = acl
        user.saveInBackgroundWithBlock({ (error: NSError!) -> Void in
            if error == nil {
                // TODO一覧画面に遷移
                self.performSegueWithIdentifier("unwindFromLogin", sender: self)
            } else {
                println("ACL設定の保存失敗: \(error)")
            }
        })
    }
    
    // ------------------------------------------------------------------------
    // MARK: - Login or Signup
    // ------------------------------------------------------------------------

    /// 未登録なのか、登録済みなのかを判断する方法がなさそう？なので、ログインを実行してみて、エラーなら新規登録を行います。
    ///
    /// :param: username ログイン時に指定するユーザ名
    /// :param: email ログイン時に指定するメールアドレス
    /// :param: password ログイン時に指定するパスワード
    /// :returns: None
    ///
    func loginWithUserName(username: String, password: String, mailaddress: String) {
        NCMBUser.logInWithUsernameInBackground(username, password: password) { (user: NCMBUser!, error: NSError!) -> Void in
            if error == nil {
                self.successLoginOrSignupForUser(user)
            } else {
                println("ログインが失敗しました: \(error)")
                let user = NCMBUser()
                user.userName = username
                user.password = password
                user.mailAddress = mailaddress
                user.signUpInBackgroundWithBlock { (error: NSError!) -> Void in
                    if error == nil {
                        self.successLoginOrSignupForUser(user)
                        return
                    }
                    println("新規会員登録が失敗しました: \(error)")
                }
            }
        }
    }

    // ------------------------------------------------------------------------
    // MARK: - Action
    // ------------------------------------------------------------------------
    
    /// ログインボタンをタップした時に実行されます。
    @IBAction func tappedLoginButton(sender: AnyObject) {
        let userName = self.userNameTextField.text
        let mail = self.mailTextField.text
        let password = self.passwordTextField.text

        self.loginWithUserName(userName, password: password, mailaddress: mail)
    }
}
