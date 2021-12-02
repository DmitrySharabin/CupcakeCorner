//
//  Order.swift
//  CupcakeCorner
//
//  Created by Dmitry Sharabin on 30.11.2021.
//

import SwiftUI

class Order: ObservableObject, Codable {
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    struct Model: Codable {
        var type = 0
        var quantity = 3
        
        var specialRequestEnabled = false {
            didSet {
                if  specialRequestEnabled == false {
                    extraFrosting = false
                    addSprinkles = false
                }
            }
        }
        
        var extraFrosting = false
        var addSprinkles = false
        
        var name = ""
        var streetAddress = ""
        var city = ""
        var zip = ""
        
        var hasValidAddress: Bool {
            let trimmedName = name.trimmingCharacters(in: .whitespaces)
            let trimmedStreetAddress = streetAddress.trimmingCharacters(in: .whitespaces)
            let trimmedCity = city.trimmingCharacters(in: .whitespaces)
            let trimmedZip = zip.trimmingCharacters(in: .whitespaces)
            
            if trimmedName.isEmpty || trimmedStreetAddress.isEmpty || trimmedCity.isEmpty || trimmedZip.isEmpty {
                return false
            }
            
            return true
        }
        
        var cost: Double {
            // $2 per cake
            var cost = Double(quantity) * 2
            
            // complicated cakes cost more
            cost += Double(type) / 2
            
            // $1/cake for extra frosting
            if extraFrosting {
                cost += Double(quantity)
            }
            
            // $0.50/cake for sprinkles
            if addSprinkles {
                cost += Double(quantity) / 2
            }
            
            return cost
        }
    }
    
    enum CodingKeys: CodingKey {
        case data
    }
    
    @Published var data = Model()
    
    init() {}
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(data, forKey: .data)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        data = try container.decode(Model.self, forKey: .data)
    }
}
