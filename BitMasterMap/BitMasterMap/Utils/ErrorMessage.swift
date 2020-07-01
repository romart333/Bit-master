//
//  ErrorMessage.swift
//  BitMasterMap
//
//  Created by user167101 on 7/1/20.
//  Copyright © 2020 user167101. All rights reserved.
//

import Foundation

enum ErrorMessage: String, Error {

    case invalidData = "Sorry. Something went wrong, try again"

    case invalidResponse = "Server error. Please modify your search and try again"
}
