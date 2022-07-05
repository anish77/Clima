//
//  WeatherData.swift
//  Clima
//
//  Created by Ana Cvasniuc on 04/07/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeaterData: Codable {
    let name: String
    let main: Main
    let weather : [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let id: Int
    //let description: String
    let main: String
}
