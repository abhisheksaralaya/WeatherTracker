//
//  Temp.swift
//  WeatherTracker
//
//  Created by Apple on 11/11/20.
//

import Foundation


struct Temp : Codable {
    let day, eve, max, min, morn, night: Double?
    
    
    enum CodingKeys: String, CodingKey {
        case day, eve, max, min, morn, night
    }
}

struct Weather : Codable {
    let description, icon, main: String?
    let id: Int?
    
    
    enum CodingKeys: String, CodingKey {
        case description, icon, id, main
    }
}

struct FeelsLike : Codable {
    let day, eve, morn, night: String?
    
    
    enum CodingKeys: String, CodingKey {
        case day, eve, morn, night
    }
}

struct List : Codable {
    let clouds, deg, dt, humidity, pressure, sunrise, sunset: Int?
    let pop, speed, rain: Double?
    let feelsLike: FeelsLike?
    let weather: [Weather]?
    let temp: Temp?
    
    enum CodingKeys: String, CodingKey {
        case clouds, deg, dt, humidity, pop, pressure, rain, speed, sunrise, sunset, feelsLike, weather, temp
    }
}

struct Coord : Codable {
    let lat, lon: Double?
    
    
    enum CodingKeys: String, CodingKey {
        case lat, lon
    }
}

struct City : Codable {
    let country, name: String?
    let  id, population, timezone: Int
    let coord: Coord
    
    enum CodingKeys: String, CodingKey {
        case country, id, name, population, timezone, coord
    }
}

struct WeatherData: Codable {
    let list: [List]?
    let city:City?
    let cnt: Int?
    let message: Double?
    let cod: String?
    
    enum CodingKeys: String, CodingKey {
        case list, city, cnt, cod, message
    }
}
