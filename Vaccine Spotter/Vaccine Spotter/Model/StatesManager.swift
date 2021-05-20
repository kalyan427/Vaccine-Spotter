//
//  StatesManager.swift
//  Vaccine Spotter
//
//  Created by kalyan  on 5/8/21.
//

import Foundation

struct StatesManager {
    
    typealias onStatesReceived = (([StateNameList]) -> Void)
    
    
    func performRequest(urlString: String, completion: @escaping (_ isSuccess: Bool,_ data: Data) -> Void) {
        let url = URL(string: urlString)!
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, urlResponse, error in
            if error != nil {
                print(error!)
                
                return
            }
            
            if let safeData = data {
                //parseJSON(states: safeData)
                completion(true, safeData)
            }
        }
        task.resume()
    }
    
    func getListOfStates(completion: @escaping onStatesReceived){
        if let path = Bundle.main.path(forResource: "states", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                do {
                    let returnData = try decoder.decode([StateNameList].self, from: data)
                    completion(returnData)
                } catch {
                    // returnData = ""
                }
            } catch {
                // handle error
            }
        }
    }
}
