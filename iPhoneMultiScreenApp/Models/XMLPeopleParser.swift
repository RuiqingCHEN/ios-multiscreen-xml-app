//
//  XMLPeopleParser.swift
//  iPhoneMultiScreenApp
//
//  Created by Ruiqing CHEN on 25/02/2025.
//

import Foundation
class XMLPeopleParser: NSObject, XMLParserDelegate {
    var filename : String
    init(filename: String) {
        self.filename = filename
    }
    // MARK: - vars for parsing
    // p-vars to store data
    var pName, pIntro, pHabitat, pLifespan, pFeeding, pTsn, pUrl : String!
    var pImages : [String] = []
    var pCategory: String = ""
    // spy vars
    var passData : Bool = false
    var passElement : Int = -1
    var isParsingImages : Bool = false
    // data vars
    var personData : Person!
    var peopleData : [Person] = [Person]()
    var aerialPeople: [Person] = [Person]()
    var aquaticPeople: [Person] = [Person]()
    var terrestrialPeople: [Person] = [Person]()
    // parsing vars
    var parser : XMLParser!
    let tags = ["name", "intro", "habitat", "lifespan", "feeding", "tsn", "url", "image", "mname"]
    // MARK: - parsing delegate methods
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        // check the elementName tag and spy it
        if tags.contains(elementName) {
            // reset the spys
            passData = true
            passElement = tags.firstIndex(of: elementName)!
        }
        if elementName == "images" {
            isParsingImages = true
            pImages = []
        }
    }
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let trimmedString = string.trimmingCharacters(in: .whitespacesAndNewlines)
        // use the spys to store string in pvars
        if passData && !trimmedString.isEmpty {
            // check passElement to store string in a pvar
            switch passElement {
                case 0 : pName = trimmedString
                case 1 : pIntro = trimmedString
                case 2 : pHabitat = trimmedString
                case 3 : pLifespan = trimmedString
                case 4 : pFeeding = trimmedString
                case 5 : pTsn = trimmedString
                case 6 : pUrl = trimmedString
                case 7 :
                    if isParsingImages {
                        pImages.append(trimmedString)
                    }
                case 8 : pCategory = trimmedString
                default: break
            }
        }
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        // reset the spys
        if tags.contains(elementName) {
            passData = false
            passElement = -1
        }
        if elementName == "images" {
            isParsingImages = false
        }
        // check if elementName is person
        if elementName == "member" {
            personData = Person(name: pName, intro: pIntro, habitat: pHabitat, lifespan: pLifespan, feeding: pFeeding, tsn: pTsn, url: pUrl, images: pImages)
            peopleData.append(personData)
            switch pCategory.lowercased() {
                case "aerial":
                    aerialPeople.append(personData)
                case "aquatic":
                    aquaticPeople.append(personData)
                case "terrestrial":
                    terrestrialPeople.append(personData)
                default:break
            }
        }
    }
    func startParsing() {
        // get the URL of the filename
        let bundleURL = Bundle.main.bundleURL
        let fileURL   = URL(string: self.filename, relativeTo: bundleURL)
        // make the parse and delegate it
        parser = XMLParser(contentsOf: fileURL!)
        parser.delegate = self
        // parse
        parser.parse()
        print("Aerial: \(aerialPeople.count)")
                print("Aquatic: \(aquaticPeople.count)")
                print("Terrestrial: \(terrestrialPeople.count)")
    }
}
