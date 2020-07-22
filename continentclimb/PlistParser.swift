//
//  PlistParser.swift
//  continentclimb
//
//  Created by Brian Limaye on 7/20/20.
//  Copyright © 2020 Brian Limaye. All rights reserved.
//

import Foundation

struct PlistParser {
    
    static func getKeyFromValue(forKey key: String) -> String {
        
        guard let value = Bundle.main.infoDictionary?[key] as? [String] else
        {
            fatalError("Could not find key...")
        }
        return value[1]
    }
}
