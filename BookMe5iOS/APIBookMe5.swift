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
    case GetVisit(id: String)
    case PostBookMark(id: String)
    case GetBookMark(id: String)
    case GetReviews(id: String)
    case PostStatsVisit(id: String)
    case PostStatsBook(id: String)
    case GetProBusinesses(id: String)
    case GetBookings(id: String)
    case GetStatisticChart
    case GetGroupeMessage
    case Comment
    case CancelBooking(id: String)
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
        case .GetVisit(let id):
            return "\(self.baseUrl())/statistics/\(id)/visit"
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
        case .GetReviews(let id):
            return "\(self.baseUrl())/reviews/\(id)"
        case .PostStatsBook(let id):
            return "\(self.baseUrl())/statistics/\(id)/booking"
        case .PostStatsVisit(let id):
            return "\(self.baseUrl())/statistics/\(id)/visit"
        case .GetGroupeMessage:
            return "\(self.baseUrl())/users/group"
        case .GetProBusinesses(let id):
            return "\(self.baseUrl())/businesses/owner/\(id)"
        case .GetBookings(let id):
            return "\(self.baseUrl())/businesses/\(id)/bookings"
        case .GetStatisticChart:
            return "\(self.baseUrl())/statistics"
        case .Comment:
            return "http://private-117ddb-bookme1.apiary-mock.com/1/comments"
        case .CancelBooking(let id):
            return "\(self.baseUrl())/booking/\(id)"
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
             .GetVisit,
             .GetReservations,
             .GetReviews,
             .GetStatisticChart,
             .Comment,
             .GetBookings,
             .GetProBusinesses,
             .GetGroupeMessage,
             .FeedBusinesses:
            return .GET
        case .CancelBooking:
            return .DELETE
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
             .GetStatisticChart,
             .GetBookMarks,
             .GetBookMark,
             .PostBookMark,
             .GetVisit,
             .GetProBusinesses,
             .GetReservations,
             .PostStatsBook,
             .GetGroupeMessage,
             .CancelBooking,
             .FeedBusinesses:
            return authHeader
        default:
            return nil
        }
    }
}
