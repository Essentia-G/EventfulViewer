//
//  Event.swift
//  EventfulViewer
//
//  Created by Станислава on 25/10/2019.
//  Copyright © 2019 Stminchuk. All rights reserved.
//

import Foundation

struct EventDetail: Codable {
    
    var id: String
    var title: String
    var latitude: String
    var longitude: String
    var url: String
    var venueAddress: String
    var regionName: String
    var image: Image?
    var description: String
    var startTime: String
    
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = (try? container.decode(String.self, forKey: .id)) ?? ""
            self.title = (try? container.decode(String.self, forKey: .title)) ?? ""
            self.latitude = (try? container.decode(String.self, forKey: .latitude)) ?? ""
            self.longitude = (try? container.decode(String.self, forKey: .longitude)) ?? ""
            self.venueAddress = (try? container.decode(String.self, forKey: .venueAddress)) ?? ""
            self.regionName = (try? container.decode(String.self, forKey: .regionName)) ?? ""
            self.description = (try? container.decode(String.self, forKey: .description)) ?? ""
            self.startTime = (try? container.decode(String.self, forKey: .startTime)) ?? ""
            self.url = (try? container.decode(String.self, forKey: .url)) ?? ""
            self.image = (try? container.decode(Image?.self, forKey: .image)) 
        }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case latitude
        case longitude
        case url
        case venueAddress = "venue_address"
        case regionName = "region_name"
        case description
        case startTime = "start_time"
        case image
        
    }
    
    
}
