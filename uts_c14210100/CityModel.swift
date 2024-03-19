//
//  CityModel.swift
//  uts_c14210100
//
//  Created by Catherine Rosalind on 09/10/23.
//

struct CityModel: Decodable {
    let rajaongkir: cityRajaOngkir
}

struct cityRajaOngkir: Decodable {
    let results: [cityResults]
}

struct cityResults: Decodable {
    let city_name: String
}

