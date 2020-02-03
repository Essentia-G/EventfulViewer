//
//  CoordinatesConverter.swift
//  EventfulViewer
//
//  Created by Станислава on 19/11/2019.
//  Copyright © 2019 Stminchuk. All rights reserved.
//

import Foundation

class CoordinatesConverter {

    func receiveAPICoordinates(from strCoordinates: String) -> Double? {
        let doubCoordinates = Double(strCoordinates)
        return doubCoordinates
    }
}
