import Foundation

//
//  XMLParser.swift
//  SaveFile
//
//  Created by Anthony Levings on 31/03/2015.
//

public class EPUBContainerParser:NSObject, NSXMLParserDelegate {
    var isManifest = false
    var isSpine = false
    // manifest dictionary links ids to urls
    var manifestDictionary = [String:String]()
    // spine array provides order of chapters
    var spineArray = [String]()
    var fontArray = [String]()
    var imageArray = [String]()
    var contentPath = ""
    var contentPaths = [String]()
    var parentFolder = ""
    var parentFolders = [String]()
    
    // returns ordered list of NSURLs for contents
    public func parseXML(xml:NSURL) -> [NSURL] {
        contentPath = xml.path! + "/"
        if let container = NSXMLParser(contentsOfURL: xml.URLByAppendingPathComponent("META-INF/container.xml")) {
            container.delegate = self
            container.parse()
        }
        // takes account of multiple rootfiles and will return every NSURL in order for multiple versions contained in the rootfile
        while contentPaths.isEmpty == false {
        if let path = contentPaths.first,
            url = NSURL(fileURLWithPath: path),
            xml = NSXMLParser(contentsOfURL: url) {
                parentFolder = parentFolders.first!
                contentPaths.removeAtIndex(0)
                parentFolders.removeAtIndex(0)
                xml.delegate = self
                xml.parse()
                
        }
        }
        let urlArray = map(spineArray, {NSURL(fileURLWithPath: self.manifestDictionary[$0]!)!})
        let returnArray = filter(urlArray, {$0 != nil})
        // TODO: build an array of incorrect URLs for missing items
        return returnArray
    }
    
    public func parserDidStartDocument(parser: NSXMLParser) {
        
    }
    
    public func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject]) {
        
        if elementName == "rootfile" {
            let content = contentPath + (attributeDict["full-path"] as! String)
            contentPaths.append(content)
            let parent = contentPath.stringByDeletingLastPathComponent + "/"
            parentFolders.append(parent)
            
        }
        
        if elementName == "manifest" {
            isManifest = true
        }
        else if isManifest == true && elementName == "item" {
            
            // array of everything, if any NSURLs return nil when constructed then item is missing
            manifestDictionary[attributeDict["id"] as! String] = parentFolder + (attributeDict["href"] as! String)
            
            if attributeDict["media-type"] as! String == "application/vnd.ms-opentype" {
                fontArray.append(attributeDict["href"] as! String)
            }
            
            else if attributeDict["media-type"] as! String == "image/png"  || attributeDict["media-type"] as! String == "image/jpeg" || attributeDict["media-type"] as! String == "image/jpg" {
                imageArray.append(attributeDict["href"] as! String)
            }
        }
        else if elementName == "spine" {
            isSpine = true
        }
        else if isSpine == true && elementName == "itemref" {
            
            spineArray.append(attributeDict["idref"] as! String)
        }
    }
    
    public func parser(parser: NSXMLParser, foundCharacters string: String?) {
        if let str = string {
            
            
            
            
        }
    }
    
    public func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "manifest" {
            isManifest = false
        }
        else if elementName == "spine" {
            isSpine = false
        }
        
        
    }
    
    public func parserDidEndDocument(parser: NSXMLParser) {
        
        
    }
    
}