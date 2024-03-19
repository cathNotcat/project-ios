//
//  OngkirModel.swift
//  uts_c14210100
//
//  Created by Catherine Rosalind on 08/10/23.
//

struct OngkirModel: Decodable {
    let rajaongkir: ongkirRajaOngkir
}

struct ongkirRajaOngkir: Decodable {
    let results: [ongkirResults]
}

struct ongkirResults: Decodable {
    let code: String
    let name: String
    let costs: [Costs]
}

struct Costs: Decodable {
    let service: String
    let cost: [Cost]
}

struct Cost: Decodable {
    let value: Int
}


