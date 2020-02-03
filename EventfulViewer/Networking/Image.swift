//
//  Image.swift
//  EventfulViewer
//
//  Created by Станислава on 25/10/2019.
//  Copyright © 2019 Stminchuk. All rights reserved.
//

import Foundation

struct Image: Codable {
    let width: String
    let height: String
    let url: String
    let venueId: String

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.width = (try? container.decode(String.self, forKey: .width)) ?? ""
        self.height = (try? container.decode(String.self, forKey: .height)) ?? ""
        self.url = (try? container.decode(String.self, forKey: .url)) ?? ""
        self.venueId = (try? container.decode(String.self, forKey: .venueId)) ?? ""
    }
}
