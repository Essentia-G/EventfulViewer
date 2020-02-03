//
//  Event.swift
//  EventfulViewer
//
//  Created by Станислава on 28/10/2019.
//  Copyright © 2019 Stminchuk. All rights reserved.
//

import Foundation

struct Event: Codable {
    let event: [EventDetail]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.event = (try? container.decode([EventDetail].self, forKey: .event)) ?? []
    }
}
