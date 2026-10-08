//
//  String+Double.swift
//  RigidBoxQuoter
//
//  Created by Bill Morfonidis on 8/10/26.
//

import Foundation

extension String {
    var asDouble: Double? {
        Double(self.replacingOccurrences(of: ",", with: "."))
    }
}
