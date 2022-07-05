//
//  WheatherManager.swift
//  Clima
//
//  Created by Ana Cvasniuc on 01/07/21.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}


struct WeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=eaa5b37a62753a0596cb087fd45cbb38&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
   
    func fetchWheather (cityName: String){
        
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
        //print(urlString)
    }
    func fetchWheather (latitude: Double, longitude: Double){
        
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
      
    }
    
    func performRequest(with urlString: String){
        //1. Create a URL
        if let url = URL(string: urlString){
            
            //2.Create a URLSession
            let session = URLSession(configuration: .default)
            
            //3. Give the session a task
            //let task = session.dataTask(with: url, completionHandler: handle(data:urlResponse:error:))
            
            //usando i closure
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(safeData){
                        
                            self.delegate?.didUpdateWather(self, weather: weather)
                        
//                        let weatherVC = WeatherViewController()
//                        weatherVC.didUpdateWather(weather: weather)
                       
                    }
                }
            }
            //4.Start the task
            task.resume()
        }
        
    }
    func parseJSON(_ weatherData: Data) -> WeatherModel?{
        
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeaterData.self, from: weatherData)
            print(decodedData.name)
            print(decodedData.main.temp)
            //print(decodedData.weather[0].description)
            //print(decodedData.weather[0].main)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
         
            let weather = WeatherModel(conditionID: id, cityName: name, temperature: temp)
           
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
   
    }
    //    func handle(data: Data?, urlResponse: URLResponse?, error: Error?){
    //        if error != nil{
    //            print(error!)
    //            return
    //        }
    //
    //        if let safeData = data {
    //            let dataString = String(data: safeData, encoding: .utf8)
    //            print(dataString)
    //        }
    //    }

