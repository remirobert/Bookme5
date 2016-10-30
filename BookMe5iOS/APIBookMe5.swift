//
//  NetworkAuth.swift
//  YooplessIOS
//
//  Created by Remi Robert on 10/03/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import SwiftMoment

enum APIBookMe5 {
    case LoginFacebook(token: String)
    case LoginGoogle(token: String)
    case LoginWithEmail(email: String, password: String)
    case User
    case UpdateUserInfo(params: JSON)
    case FeedBusinesses
    case SearchBuisiness(input: String)
    case GetServices
    case BookService(id: String, service: String, date: String)
    case ServiceIndisponibilities(id: String, date: NSDate)
    case GetReservations
    case GetService(id: String)
    case GetBookMarks
    case PostBookMark(id: String)
    case GetBookMark(id: String)
    case PostStatsVisit(id: String)
    case PostStatsBook(id: String)
    case Comment
}

extension APIBookMe5: NetworkRequest {
    
    func baseUrl() -> String {
        return "https://api.bookme5.com/api"
    }
    
    func parameters() -> [String: AnyObject]? {
        switch self {
        case .LoginFacebook(let token):
            return ["access_token": token]
        case .LoginGoogle(let token):
            return ["access_token": token]
        case .LoginWithEmail(let email, let password):
            return ["username": email, "password": password]
        case .UpdateUserInfo(let params):
            return params
        case .SearchBuisiness(let input):
            return ["input": input]
        case .BookService(let id, let service, let date):
            return [
                "businessId": id,
                "serviceId": service,
                "date": date
            ]
        default:
            return nil
        }
    }
    
    func path() -> String {
        switch self {
        case .LoginFacebook:
            return "\(self.baseUrl())/login/facebook/token"
        case .LoginGoogle:
            return "\(self.baseUrl())/login/google/token"
        case .LoginWithEmail:
            return "\(self.baseUrl())/login/email"
        case .User:
            return "\(self.baseUrl())/users/info"
        case .UpdateUserInfo:
            return "\(self.baseUrl())/users/profile"
        case .FeedBusinesses:
            return "\(self.baseUrl())/businesses"
        case .SearchBuisiness:
            return "\(self.baseUrl())/businesses/search"
        case .GetServices:
            return "\(self.baseUrl())/services"
        case .GetService(let id):
            return "\(self.baseUrl())/services/\(id)"
        case .BookService:
            return "\(self.baseUrl())/booking"
        case .ServiceIndisponibilities(let id, let date):
            return "\(self.baseUrl())/services/\(id)/unavailability/\(moment(date).format("yyyy-MM-dd'T'HH:mm:ssZZZZZ"))"
        case .GetReservations:
            return "\(self.baseUrl())/users/reservations2"
        case .GetBookMarks:
            return "\(self.baseUrl())/bookmarks/get2"
        case .GetBookMark(let id):
            return "\(self.baseUrl())/bookmarks/\(id)/get"
        case .PostBookMark(let id):
            return "\(self.baseUrl())/bookmarks/\(id)"
        case .PostStatsBook(let id):
            return "\(self.baseUrl())/statistics/\(id)/booking"
        case .PostStatsVisit(let id):
            return "\(self.baseUrl())/statistics/\(id)/visit"
        case .Comment:
            return "http://private-117ddb-bookme1.apiary-mock.com/1/comments"
        }
    }
    
    func method() -> NetworkMethod {
        switch self {
        case .User,
             .GetServices,
             .GetService,
             .ServiceIndisponibilities,
             .GetBookMark,
             .GetBookMarks,
             .GetReservations,
             .Comment,
             .FeedBusinesses:
            return .GET
        default:
            return .POST
        }
    }
    
    func headers() -> [String: String]? {
        var authHeader: [String: String]?
        if let token = TokenAccess.accessToken {
            authHeader = ["Authorization": "Bearer \(token)"]
        }
        
        switch self {
        case .User,
             .UpdateUserInfo,
             .BookService,
             .GetService,
             .ServiceIndisponibilities,
             .GetBookMarks,
             .GetBookMark,
             .PostBookMark,
             .GetReservations,
             .PostStatsBook,
             .FeedBusinesses:
            return authHeader
        default:
            return nil
        }
    }
}