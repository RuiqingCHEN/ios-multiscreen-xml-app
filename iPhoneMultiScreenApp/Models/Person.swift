//
//  Person.swift
//  iPhoneApp
//
//  Created by Ruiqing CHEN on 11/02/2025.
//

import Foundation
class Person{
    // properties
    var name, intro, habitat, lifespan, feeding, tsn, url : String
    var images: [String]
    // init
    init(name: String, intro: String, habitat: String, lifespan: String, feeding: String, tsn: String, url: String, images: [String]) {
        self.name = name
        self.intro = intro
        self.habitat = habitat
        self.lifespan = lifespan
        self.feeding = feeding
        self.tsn = tsn
        self.url = url
        self.images = images
    }
}
