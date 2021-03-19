//
//  IndexPath.swift
//  SDNS Actions
//
//  Created by Corey Werner on 05/01/2021.
//

import Foundation

extension IndexPath {
    private static let max = 1000

    init(tag: Int) {
        self.init(row: tag % Self.max, section: tag / Self.max)
    }

    var tag: Int {
        return (section * Self.max) + row
    }
}
