//
//  Event.swift
//  EventfulViewer
//
//  Created by Станислава on 25/10/2019.
//  Copyright © 2019 Stminchuk. All rights reserved.
//

import Foundation

struct EventDetail: Codable {

    let id: String
    let title: String
    let latitude: String
    let longitude: String
    let url: String
    let venueAddress: String
    let regionName: String
    let image: Image?
    let description: String
    let startTime: String

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
}
