//
//  ViewController.swift
//  WeatherTracker
//
//  Created by Apple on 11/11/20.
//

import UIKit
import CoreLocation

class ViewController: UIViewController,UITableViewDataSource, CLLocationManagerDelegate {

    @IBOutlet var weatherViewModel: WeatherViewModel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var tblWeatherList: UITableView!
    
    // Used to start getting the users location
    let locationManager = CLLocationManager()
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        location()
    }
    
    // Print out the location to the console
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    // If we have been deined access give the user the option to change it
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.denied) {
            showLocationDisabledPopUp()
        }
        if status == CLAuthorizationStatus.authorizedWhenInUse || status == CLAuthorizationStatus.authorizedAlways {
            location()
        }
        
    }
    
    @IBAction func location() {
        // For use when the app is open & in the background
        locationManager.requestAlwaysAuthorization()
        
        // For use when the app is open
        //locationManager.requestWhenInUseAuthorization()
        
        // If location services is enabled get the users location
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest // You can change the locaiton accuary here.
            locationManager.startUpdatingLocation()
        }
        if locationManager.authorizationStatus.rawValue == 2 {
            showLocationDisabledPopUp()
        }
        if let location = self.locationManager.location {
            self.tblWeatherList.dataSource = self
            // Creatiing ViewModel
            let alertController = UIAlertController(title: "Loading ..",
                                                    message: "Please wait",
                                                    preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
            weatherViewModel.getData(latitude: String(location.coordinate.latitude),longitude: String(location.coordinate.longitude), completion:  {
                self.lblCity.text = self.weatherViewModel.tempCity()
                if self.lblCity.text == "" {
                    self.lblCity.text = "Latitude : " + String(location.coordinate.latitude) + "\nLongitude : " + String(location.coordinate.longitude)
                }
                self.tblWeatherList.reloadData()
                alertController.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    // Show the popup to the user if we have been deined access
    func showLocationDisabledPopUp() {
        let alertController = UIAlertController(title: "Background Location Access Disabled",
                                                message: "In order to show weather we need your location",
                                                preferredStyle: .alert)
        
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(openAction)
        
        self.present(alertController, animated: true, completion: nil)
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 16
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as? WeatherListCell
        // labels are created using view model
        cell?.lblTemperature.text = weatherViewModel.temperature(indexPath: indexPath)
        cell?.lblDate.text = weatherViewModel.tempDate(indexPath: indexPath)
        cell?.lblDescription.text = weatherViewModel.tempDescription(indexPath: indexPath)
        return cell!
    }

}

class WeatherListCell : UITableViewCell {
    @IBOutlet weak var lblTemperature: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    override func awakeFromNib() {
        layoutIfNeeded()
    }
}

