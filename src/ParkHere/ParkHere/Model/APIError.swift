//
//  APIError.swift
//  ParkHere
//
//  Created by Nguyen Quang Ngoc Tan on 3/23/17.
//  Copyright © 2017 Nguyen Quang Ngoc Tan. All rights reserved.
//

import Foundation

enum APIError: Error {
    case failedRequest
    case wrongFormattedResponse
    case responseStatusNOK
    case emptyResult
}
