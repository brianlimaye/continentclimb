//
//  PlistParser.swift
//  continentclimb
//
//  Created by Brian Limaye on 7/20/20.
//  Copyright © 2020 Brian Limaye. All rights reserved.
//

import Foundation

struct PlistParser {
    
    static func getLayoutPackage(forKey key: String, property1: String, property2: String) -> (String, String, [String]) {
        
        var platName: String = String()
        var backgName: String = String()
        var cityNames: [String] = [String]()
        
        guard let value = Bundle.main.infoDictionary?[key] as? [String] else
        {
            fatalError("Could not find key...")
        }
        
        if(property1 == "platform")
        {
            platName = value[0]
        }
        
        if(property2 == "background")
        {
            backgName = value[1]
        }
        
        cityNames.append(value[2])
        cityNames.append(value[3])
        cityNames.append(value[4])

        return (platName, backgName, cityNames)
    }
}
