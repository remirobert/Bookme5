
//
//  SignupViewModel.swift
//  BookMe5iOS
//
//  Created by Remi Robert on 28/01/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import Alamofire
import RxSwift

class SignupViewModel: NSObject {

    let disposeBag = DisposeBag()
    
    private func loginUserObservable(email: String, password: String) -> Observable<TokenAccess?> {
        let request = APILogin.loginWithEmail(email, password: password)

        return Observable.just(nil)
//        return API.responseFrom(request).flatMap({ (response: APIResponse) -> Observable<TokenAccess?> in
//            switch response {
//            case .JSON(let data): return TokenAccess.instanceToken(data as? NSDictionary)
//            case .Error(_, _): return TokenAccess.instanceToken(nil)
//            }
//        })
    }
    
    private func signupUserObservable(email: String, firstName: String, lastName: String, password: String) -> Observable<Bool> {
        return Observable.create({ observer in
            
            let request = APIUser.signupUser(email, firstName: firstName, lastName: lastName, password: password)
            
            API.responseFrom(request).subscribeNext({ response in
                switch response {
                case .JSON(_) : observer.onNext(true)
                case .Error(_, _): observer.onNext(false)
                }
                observer.onCompleted()
            }).addDisposableTo(self.disposeBag)
            return NopDisposable.instance
        })
    }

    func signupUser(email: String, firstName: String, lastName: String, password: String) -> Observable<Bool> {
        return self.signupUserObservable(email, firstName: firstName, lastName: lastName, password: password).flatMap { (success: Bool) -> Observable<TokenAccess?> in
            return (success) ? self.loginUserObservable(email, password: password) : Observable.just(nil)
            }.flatMap({ (token: TokenAccess?) -> Observable<Bool> in
                return Observable.just((token != nil) ? true : false)
        })
    }
}
