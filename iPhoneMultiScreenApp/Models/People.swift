//
//  People.swift
//  iPhoneApp
//
//  Created by Ruiqing CHEN on 11/02/2025.
//

import Foundation
class People: NSObject, XMLParserDelegate{
    // properties
    var people : [Person]
    var aerial: [Person] = []
    var aquatic: [Person] = []
    var terrestrial: [Person] = []
    // init
    init(people : [Person]) {
        self.people = people
    }
    init(xmlFile : String) {
        // make an XMLPeopleParser and start parsing
        let peopleParser = XMLPeopleParser(filename: xmlFile)
        peopleParser.startParsing()
        // get the parsed data
        self.people = peopleParser.peopleData
        self.aerial = peopleParser.aerialPeople
        self.aquatic = peopleParser.aquaticPeople
        self.terrestrial = peopleParser.terrestrialPeople
    }
    // methods
    func count()->Int{return self.people.count}
    func person(index:Int)->Person{return self.people[index]}
}
