//
//  ProfileViewController.swift
//  BookMe5iOS
//
//  Created by Remi Robert on 10/12/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import PINRemoteImage
import Hakuba
import RealmSwift
import SwiftMoment

class ProfileViewController: UIViewController {
    
    private let profileViewModel = ProfileViewModel()
    private let disposeBag = DisposeBag()
    private var hakuba: Hakuba!
    private var models = [ProfileReservationModel]()
    
    private lazy var joinLoginView: JoinLoginProfileView! = {
        let joinLoginView = UINib(nibName: "JoinLoginProfileView", bundle: nil).instantiateWithOwner(self, options: nil).first as! JoinLoginProfileView
        joinLoginView.hidden = true
        return joinLoginView
    }()
    
    @IBOutlet weak var buttonProSpace: UIButton!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var buttonEditProfile: UIBarButtonItem!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var segmentReservations: UISegmentedControl!
    @IBOutlet weak var imageBackgound: UIImageView!
    
    @IBAction func displayProSpace(sender: AnyObject) {
        
    }

    private func displayEditionProfile(property: ProfileProperty, content: String?) -> Observable<String> {
        return Observable.create({ observer in
            
            let alertController = UIAlertController(title: "edit :\(property.rawValue)", message: nil, preferredStyle: .Alert)
            
            let actionLogin = UIAlertAction(title: "Login", style: .Default) { (_) in
                let loginTextField = alertController.textFields![0] as UITextField
                if let text = loginTextField.text {
                    observer.onNext(text)
                }
                observer.onCompleted()
            }
            
            let actionCancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (_) -> Void in
                observer.onCompleted()
            })
            
            alertController.addTextFieldWithConfigurationHandler { (textField) in
                if let content = content {
                    textField.text = content
                }
                else {
                    textField.placeholder = property.rawValue
                }
                textField.rx_text.subscribeOn(MainScheduler.instance).subscribeNext({ text in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        actionLogin.enabled = text != ""
                    })
                }).addDisposableTo(self.disposeBag)
            }
            
            alertController.addAction(actionLogin)
            alertController.addAction(actionCancel)
            alertController.view.setNeedsLayout()
            
            self.presentViewController(alertController, animated: true, completion: nil)
            return AnonymousDisposable {
                alertController.dismissViewControllerAnimated(true, completion: nil)
            }
        })
    }
    
    private func editProfileProperty(property: ProfileProperty, content: String?) {
        self.displayEditionProfile(property, content: content).subscribeNext { newValue in
            
            self.profileViewModel.updateProfileInfos(property, content: newValue).subscribeNext({ success in
                if success {
                    print("update okay")
                }
                else {
                    print("update failed")
                }
            }).addDisposableTo(self.disposeBag)
            
            }.addDisposableTo(self.disposeBag)
    }
    
    private func displayProfileOption() {
        let actionController = UIAlertController(title: "Option Profile", message: nil, preferredStyle: .ActionSheet)
        
        actionController.addAction(UIAlertAction(title: "Change firstname", style: .Default, handler: { (_) -> Void in
            //self.editProfileProperty(.FirstName, content: self.labelUsername.text)
        }))
        actionController.addAction(UIAlertAction(title: "Logout", style: .Destructive, handler: { (_) -> Void in
            self.profileViewModel.logout().subscribeNext({ success in
                if success == false {
                    print("Error logout")
                }
            }).addDisposableTo(self.disposeBag)
        }))
        actionController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        self.presentViewController(actionController, animated: true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.hakuba.deselectAllCells(animated: false)
        self.view.bringSubviewToFront(self.joinLoginView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.profileViewModel.getReservationsUser()
        self.hakuba.reset()
        self.hakuba.append(Section())
        self.tableview.reloadData()
        self.bindInterface()
    }

    func optionReservation(booking: Reservation) {
        let alertController = UIAlertController(title: "Options: ", message: nil, preferredStyle: .ActionSheet)

        alertController.addAction(UIAlertAction(title: "Détail", style: .Default, handler: { _ in
            self.performSegueWithIdentifier("detailService", sender: booking)
        }))

        alertController.addAction(UIAlertAction(title: "Annuler la reservation", style: .Destructive, handler: { _ in
            self.profileViewModel.cancelReservation(booking)
        }))
        alertController.addAction(UIAlertAction(title: "Annuler", style: .Cancel, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.buttonProSpace.hidden = true
        self.imageBackgound.clipsToBounds = true
        self.tableview.tableFooterView = UIView()
        self.tableview.separatorStyle = .None
        self.hakuba = Hakuba(tableView: self.tableview)
        self.hakuba.registerCellsByNib(ProfileReservationTableViewCell)
        self.hakuba.append(Section())
        
        self.view.insertSubview(self.joinLoginView, atIndex: 0)
        self.joinLoginView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }
        self.view.bringSubviewToFront(self.joinLoginView)
        
        self.joinLoginView.observableLogin.subscribeOn(MainScheduler.instance).subscribeNext {
            self.presentViewController(Storyboards.Main.instantiateLoginController(), animated: true, completion: nil)
            }.addDisposableTo(self.disposeBag)
        
        self.buttonEditProfile.rx_tap.subscribeNext {
            self.displayProfileOption()
            }.addDisposableTo(self.disposeBag)
        
        self.profileViewModel.reservations
            .asObservable()
            .subscribeOn(MainScheduler.instance)
            .subscribeNext { reservations in
                let models = reservations.map({ reservation -> ProfileReservationModel in
                    let model = ProfileReservationModel(reservation: reservation)
                    model.selectionHandler = { _ in
                        self.performSegueWithIdentifier("detailService", sender: reservation)
                    }
                    model.selectionHandler = { _ in
                        if self.segmentReservations.selectedSegmentIndex == 1 {
                            return
                        }
                        self.optionReservation(model.reservation)
                    }
                    return model
                })
                self.models = models
                
                self.hakuba[0].reset()
                self.hakuba[0].append(self.eventState(ProfileStateEvent(rawValue: self.segmentReservations.selectedSegmentIndex)!, events: models))
                self.tableview.reloadData()
        }.addDisposableTo(self.disposeBag)
        
        self.segmentReservations.rx_value.subscribeNext({ value in
            self.hakuba[0].reset()
            if value == 0 {
                let models = self.eventState(ProfileStateEvent.Comming, events: self.models)
                self.hakuba[0].append(models)
            }
            else {
                let models = self.eventState(ProfileStateEvent.Past, events: self.models)
                self.hakuba[0].append(models)
            }
            self.tableview.reloadData()
        }).addDisposableTo(self.disposeBag)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let controller = segue.destinationViewController as? DetailReservationViewController else {
            return
        }
        controller.reservation = sender as? Reservation
    }
}

//bind state UI connected and not connected user
extension ProfileViewController {
    
    private func bindInterface() {
        TokenAccess.observableTokenAccess.subscribeOn(MainScheduler.instance).subscribeNext { token in
            if let _ = token {
                self.bindConnectedView()
            }
            else {
                self.bindNotConnectedView()
            }
            }.addDisposableTo(self.disposeBag)
    }
    
    private func eventState(state: ProfileStateEvent, events: [ProfileReservationModel]) -> [ProfileReservationModel] {
        return events.filter({ (reservation: ProfileReservationModel) -> Bool in
            guard let date = reservation.reservation.start else {
                return false
            }
            switch state {
            case .Comming:
                return moment() < moment(date)
            case .Past:
                return moment() > moment(date)
            }
        })
    }
    
    private func bindConnectedView() {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.joinLoginView.hidden = true
        }
        
        self.profileViewModel.fetchUserInfos()
        self.profileViewModel.login.subscribeNext { _ in
            self.tableview.reloadData()
            }.addDisposableTo(self.disposeBag)

        let model = ProfileInfoModel(user: User.sharedInstance)
        if User.sharedInstance.pro {
            self.buttonProSpace.hidden = false
            self.tableview.contentInset = UIEdgeInsetsMake(0, 0, 50, 0)
        }
        self.labelName.text = "\(model.user.firstName) \(model.user.lastName)"
        self.labelEmail.text = model.user.email
        self.imageViewProfile.pin_setImageFromURL(NSURL(string: model.user.pictureProfileUrl ?? ""))
        self.imageBackgound.pin_setImageFromURL(NSURL(string: model.user.pictureProfileUrl ?? ""))


        self.tableview.reloadData()
    }
    
    private func bindNotConnectedView() {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.joinLoginView.hidden = false
        }
    }
}
