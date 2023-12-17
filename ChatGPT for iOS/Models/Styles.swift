//
// Created for Art Generator
// by Stewart Lynch on 2022-11-21
// Using Swift 5.0
//
// Follow me on Twitter: @StewartLynch
// Subscribe on YouTube: https://youTube.com/StewartLynch
//

import Foundation

enum ImageStyle: String, CaseIterable {
    case none
    case abstract = "abstract"
    case cartoon
    case comic
    case expressionism
    case impressionism
    case popArt = "pop art"
    case realism
    case renaissance
    case surrealism
    
    var description: String {
        self != .none ? "an image in the style of " + self.rawValue + " " : ""
    }
}

enum ImageMedium: String, CaseIterable {
    case none
    case digital = "digital art"
    case oil = "oil painting"
    case pastel
    case photo
    case spray = "spray paint"
    case watercolor
    
    var description: String {
        self != .none ? "using the medium of " + self.rawValue + " " : ""
    }
}

enum Artist: String, CaseIterable {
    case none
    case dali = "Savador Dali"
    case davinci = "Leonardo da Vinci"
    case matisse = "Henri Matisse"
    case monet = "Claud Monet"
    case picasso = "Pablo Picasso"
    case pollock = "Jackson Pollock"
    case vangogh = "Vincent van Gogh"
    case warhol = "Andy Warhol"
    
    var description: String {
        self != .none ? "similar to the works of " + self.rawValue + " " : ""
    }
}
