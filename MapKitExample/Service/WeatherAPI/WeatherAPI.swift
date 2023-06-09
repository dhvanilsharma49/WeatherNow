//
//  WeatherAPI.swift
//  MapKitExample
//
//  Created by Daniel Carvalho on 10/03/22.
//

import Foundation
import UIKit


class WeatherAPI {
    
    static func weatherNow( city : String,
                            successHandler: @escaping (_ httpStatusCode : Int, _ response : [String: Any]) -> Void,
                            failHandler : @escaping (_ httpStatusCode : Int, _ errorMessage: String) -> Void) {
        
        /*
         San_Francisco
         Montreal
         */
        var formattedCity = city.replacingOccurrences(of: " ", with: "_")
        formattedCity = formattedCity.applyingTransform(.stripDiacritics, reverse: false)!
        
        let baseURL = "https://weatherapi-com.p.rapidapi.com/"
        
        let parameters = "q=\(formattedCity)"
        
        let endPoint = "current.json"
        
        let method = "GET"
        
        let header : [String:String] = ["x-rapidapi-host" : "weatherapi-com.p.rapidapi.com",
                                        "x-rapidapi-key" : "66fe353c83msha1dd838675bd333p1851bdjsna0c8c459dcba"]
        let payload : [String:Any] = [:]
        
    
        API.call(baseURL: baseURL, endPoint: "\(endPoint)?\(parameters)", method: method, header: header, payload: payload, successHandler: successHandler, failHandler: failHandler)
    
        
    }
    
}


struct WeatherAPICurrent : Codable {
    
    var temp_c : Double
    var condition : Condition
    var feelslike_c : Double
    var temp_f : Double
    var feelslike_f : Double
    
    
    struct Condition : Codable {
        var text : String
        var icon : String
    }

    
    static func decode( json : [String:Any] ) -> WeatherAPICurrent? {
        
        let decoder = JSONDecoder()
        do{
            let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            let object = try decoder.decode(WeatherAPICurrent.self, from: data)
            return object
        }catch{
            
        }
        return nil
        
    }
    
}

