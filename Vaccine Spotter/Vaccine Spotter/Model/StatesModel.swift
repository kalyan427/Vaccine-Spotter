//
//  StatesModel.swift
//  Vaccine Spotter
//
//  Created by kalyan  on 5/8/21.
//

import Foundation

struct stateModel: Decodable {
    let features: [Feature]
}

struct Feature: Decodable {
    let properties: Properties
    let geometry: Geometry
}

struct Geometry: Decodable{
    let coordinates: [Double]
}


struct Properties: Decodable {
    let name: String
    let provider_brand: String
    let appointments_available: Bool?
}


// MARK: - States Name List

struct StateNameList: Decodable{
    let name: String
    let abbreviation: String
}
