//
//  LoginViewController.swift
//  Bookme5IOS
//
//  Created by Remi Robert on 25/01/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {

    private var loginViewModel: LoginViewModel!
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var buttonLoginGoogle: UIButton!
    @IBOutlet weak var buttonLoginEmail: UIButton!
    @IBOutlet weak var buttonLoginFacebook: UIButton!
    
    @IBAction func closeLoginController(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private lazy var observerEmail: Observable<Provider>! = {
        return Observable.create({ observer in
            self.buttonLoginEmail.rx_controlEvent(.TouchUpInside).subscribeNext {
                self.displayPrompt().subscribeNext { provider in
                    observer.onNext(provider)
                    observer.onCompleted()
                }.addDisposableTo(self.disposeBag)
            }.addDisposableTo(self.disposeBag)
            
            return NopDisposable.instance
        })
    }()
    
    private lazy var observerGoogle: Observable<NetworkRequest>! = {
        return self.buttonLoginGoogle.rx_controlEvent(.TouchUpInside).flatMap { () -> Observable<NetworkRequest> in
            return self.loginViewModel.observableLoginGoogle
        }
    }()

    private lazy var observerFacebook: Observable<NetworkRequest>! = {
        return self.buttonLoginFacebook.rx_controlEvent(.TouchUpInside).flatMap { () -> Observable<NetworkRequest> in
            return self.loginViewModel.observableLoginFacebook
        }
    }()
    
    private func displayPrompt() -> Observable<Provider> {
        return Observable.create({ observer in
            
            let alertController = UIAlertController(title: "Connection", message: "Utilisez votre email et password utilisé lors de l'inscription.", preferredStyle: .Alert)
            
            let loginAction = UIAlertAction(title: "Login", style: .Default) { (_) in
                let loginTextField = alertController.textFields![0] as UITextField
                let passwordTextField = alertController.textFields![1] as UITextField
                
                
                let provider = EmailProvider(email: loginTextField.text!, password: passwordTextField.text!)
                observer.onNext(provider)
                observer.onCompleted()
            }
            loginAction.enabled = false
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in
                observer.onCompleted()
            }
            
            alertController.addTextFieldWithConfigurationHandler { (textField) in
                textField.placeholder = "Login"
            }
            
            alertController.addTextFieldWithConfigurationHandler { (textField) in
                textField.placeholder = "Password"
                textField.secureTextEntry = true
            }

            guard let loginTextField = alertController.textFields?.first, let passwordTextField = alertController.textFields?.last else {
                observer.onCompleted()
                return NopDisposable.instance
            }
            
            Observable.combineLatest(
                loginTextField.rx_text.map({ return $0.characters.count > 0 }),
                passwordTextField.rx_text.map({ return $0.characters.count > 0 }),
                resultSelector: { (login, password) -> Bool in
                    return login && password
            }).subscribeNext({
                loginAction.enabled = $0
            }).addDisposableTo(self.disposeBag)
            
            alertController.addAction(loginAction)
            alertController.addAction(cancelAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
            return NopDisposable.instance
        })
    }
    
    @IBAction func connection(sender: AnyObject) {
        self.displayPrompt().asObservable().subscribe { (event) in

        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red:0.97, green:0.97, blue:0.97, alpha:1)
        
        self.loginViewModel = LoginViewModel(parentController: self)
        
        
        Observable.of(self.observerFacebook, self.observerGoogle).merge().flatMap { (request: NetworkRequest) -> Observable<TokenAccess?> in
            return self.loginViewModel.loginWithProvider(request)
        }.subscribe { (event) in
            switch event {
            case .Next(let tokenAccess):
                if let _ = tokenAccess {
                    self.dismissViewControllerAnimated(true, completion: nil)
                    print("connected : ")
                }
                else {
                    print("error connection")
                }
            case .Error(let error):
                print("error : \(error)")
            default: break
            }
        }.addDisposableTo(self.disposeBag)
    }
}
