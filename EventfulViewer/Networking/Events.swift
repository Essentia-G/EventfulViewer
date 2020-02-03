//
//  Events.swift
//  EventfulViewer
//
//  Created by Станислава on 25/10/2019.
//  Copyright © 2019 Stminchuk. All rights reserved.
//

import Foundation

struct Events: Codable {
    let events: Event?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.events = (try? container.decode(Event.self, forKey: .events))
    }
}
