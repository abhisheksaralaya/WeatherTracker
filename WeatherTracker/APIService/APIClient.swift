//
//  APIClient.swift
//  WeatherTracker
//
//  Created by Apple on 11/11/20.
//

import Foundation
import CoreData
import UIKit

class APIClient: NSObject {
    func fetchWeatherList(latitude: String, longitude: String, completion: @escaping (WeatherData?) -> Void) {
        let headers = [
            "x-rapidapi-key": "806fac30a1msh1da67104c366681p1aaa74jsn3e94521e002f",
            "x-rapidapi-host": "community-open-weather-map.p.rapidapi.com"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://community-open-weather-map.p.rapidapi.com/forecast/daily?lat=\(latitude)&lon=\(longitude)&cnt=16&units=metric")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { [self] (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                do {
                    let jsonData = try  JSONDecoder().decode(WeatherData.self
                                                             , from: data!)
                    DispatchQueue.main.async {
                        self.insertData(json: String(data: data!, encoding: .utf8)!)
                    }
                    completion(jsonData)
                    
                } catch let error {
                    print(error)
                }
            }
        })

        dataTask.resume()
    }
        
    private func insertData(json: String) {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            let context = delegate.persistentContainer.viewContext
            do {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WeatherDB")
                
                let objects = try(context.fetch(fetchRequest)) as? [NSManagedObject]
                
                for object in objects! {
                    context.delete(object)
                }
                try(context.save())
            } catch let err {
                print(err)
            }
            let resource = NSEntityDescription.insertNewObject(forEntityName: "WeatherDB", into: context) as! WeatherDB
            resource.json = json
            do {
                try(context.save())
            } catch let err {
                print(err)
            }
            
        }
    }
}
