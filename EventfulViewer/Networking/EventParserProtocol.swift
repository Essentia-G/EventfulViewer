//
//  IEventParser.swift
//  EventfulViewer
//
//  Created by Станислава on 08/11/2019.
//  Copyright © 2019 Stminchuk. All rights reserved.
//

import Foundation

protocol EventParserProtocol {

   func jsonFromUrlGetter(url: URL, completion: @escaping (Event?, Error?) -> Void)

}
