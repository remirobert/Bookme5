//
//  SignupViewController.swift
//  BookMe5iOS
//
//  Created by Remi Robert on 28/01/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import RxSwift

class SignupViewController: UIViewController {

    let signupViewModel = SignupViewModel()
    //let loginViewModel = LoginViewModel()
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldFirstName: UITextField!
    @IBOutlet weak var textFieldLastName: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var buttonSignup: UIButton!
    
    @IBAction func cancelSignup(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    var observableValidation: Observable<Bool> {
        return Observable.combineLatest(self.textFieldEmail.rx_text,
            self.textFieldFirstName.rx_text,
            self.textFieldLastName.rx_text,
            self.textFieldPassword.rx_text,
            resultSelector: { (s1: String, s2: String, s3: String, s4: String) -> Bool in
            return s1.characters.count > 0 && s2.characters.count > 0 && s3.characters.count > 0 && s4.characters.count > 0
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.buttonSignup.hidden = true
        
        self.textFieldEmail.text = "sarah@gmail.com"
        self.textFieldFirstName.text = "gmail"
        self.textFieldLastName.text = "box"
        self.textFieldPassword.text = "8907689"
        
        self.observableValidation.subscribeNext { validated in
            self.buttonSignup.hidden = !validated
        }.addDisposableTo(self.disposeBag)
        
        self.buttonSignup.rx_tap.flatMap { (_) -> Observable<Bool> in
            return self.signupViewModel.signupUser(self.textFieldEmail.text!,
                firstName: self.textFieldFirstName.text!,
                lastName: self.textFieldLastName.text!,
                password: self.textFieldPassword.text!)
        }.subscribeNext { success in
            if success {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            else {
                print("fail create user")
            }
            
        }.addDisposableTo(self.disposeBag)
    }
}
