//
//  Plants.swift
//  nature-logger
//
//  Created by Frederik Helth on 15/12/2020.
//  Copyright © 2020 Syddansk Universitet. All rights reserved.
//

import Foundation

struct Plants:Decodable {
    let data: [Result]
    struct Result:Decodable {
        let common_name: String!
        let image_url: String!
    }
    
}
