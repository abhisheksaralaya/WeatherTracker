//
//  ViewModel.swift
//  WeatherTracker
//
//  Created by Apple on 11/11/20.
//

import Foundation
import Network
import UIKit
import CoreData

class WeatherViewModel: NSObject {
    @IBOutlet var apiClient: APIClient!
    
    var weatherData: WeatherData?
    
    func getData(latitude: String, longitude: String, completion: @escaping () -> Void) {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [self] path in
            if path.status == .satisfied {
                self.apiClient.fetchWeatherList(latitude:latitude, longitude: longitude, completion: { (weatherData) in
                    DispatchQueue.main.async {
                        self.weatherData = weatherData
                        monitor.cancel()
                        completion()
                    }
                })
            } else {
                let data = self.retrieve().data(using: .utf8)
                DispatchQueue.main.async {
                    do {
                        weatherData = try JSONDecoder().decode(WeatherData.self, from: data!)
                        monitor.cancel()
                        completion()
                    } catch let err {
                        print("zdsdsa",err)
                    }
                }
            }
        }
    }
    
    func tempCity()-> String {
        if let weatherData = weatherData, let city = weatherData.city, let name = city.name {
            return name
        } else {
            return ""
        }
    }
    
    func temperature(indexPath: IndexPath) -> String {
        var sentence = ""
        if let weatherData = weatherData, let lists = weatherData.list, let temp = lists[indexPath.row].temp, let morn = temp.morn {
            sentence.append("Morning " + String(morn) + "°C\n")
        }
        if let weatherData = weatherData, let lists = weatherData.list, let temp = lists[indexPath.row].temp, let day = temp.day {
            sentence.append("Day           " + String(day) + "°C\n")
        }
        if let weatherData = weatherData, let lists = weatherData.list, let temp = lists[indexPath.row].temp, let eve = temp.eve {
            sentence.append("Evening  " + String(eve) + "°C\n")
        }
        if let weatherData = weatherData, let lists = weatherData.list, let temp = lists[indexPath.row].temp, let night = temp.night {
            sentence.append("Night        " + String(night) + "°C\n")
        }
        if let weatherData = weatherData, let lists = weatherData.list, let temp = lists[indexPath.row].temp, let max = temp.max {
            sentence.append("Max           " + String(max) + "°C\n")
        }
        if let weatherData = weatherData, let lists = weatherData.list, let temp = lists[indexPath.row].temp, let min = temp.min {
            sentence.append("Min            " + String(min) + "°C")
        }
        return sentence
    }
    
    func tempDate(indexPath: IndexPath)-> String {
        if let weatherData = weatherData, let lists = weatherData.list, let dt = lists[indexPath.row].dt {
            let date = Date(timeIntervalSince1970: TimeInterval(dt))
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "EEE, dd-MM-yyyy"
            return dateFormat.string(from: date)
        } else {
            return ""
        }
    }
    
    func tempDescription(indexPath: IndexPath)-> String {
        if let weatherData = weatherData, let lists = weatherData.list, let weather = lists[indexPath.row].weather, let description = weather[0].description {
            return description
        } else {
            return ""
        }
    }
    
    private func retrieve () -> String {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return "" }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WeatherDB")
        
        fetchRequest.predicate = nil
        
        do {
            let results = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            if results.count > 0{
                let result = results[0]
                let resultString = result.value(forKey: "json") as! String
                return resultString
            }else {
                return ""
            }
            
        } catch {
            
            return ""
        }
    }
}
