//
//  HeroStats.swift
//  TableViewTest
//
//  Created by Frederik Helth on 25/10/2020.
//  Copyright © 2020 Frederik Helth. All rights reserved.
//

import Foundation

struct Plants:Decodable {
    let data: [Result]
    struct Result:Decodable {
        let common_name: String!
        let image_url: String!
    }
    
}

/*
struct HeroStats:Decodable {
    let localized_name: String
    let primary_attr: String
    let attack_type: String
    let legs: Int
    let img: String
    
}*/
