//
//  AppColors.swift
//  SQRCLE
//
//  Created by Dynasas on 22/12/23.
//

import Foundation
import UIKit

enum Circle : Int{
    
    case Red = 0
    case Orange = 1
    case Yellow = 2
    case Green = 3
    case Blue = 4
    case Indigo = 5
    case Violet = 6
    
    var color : UIColor{
        switch self{
        case .Violet : return Colors.Circles.violet
        case .Indigo : return Colors.Circles.indigo
        case .Blue   : return Colors.Circles.blue
        case .Green  : return Colors.Circles.green
        case .Yellow : return Colors.Circles.yellow
        case .Orange : return Colors.Circles.orange
        case .Red    : return Colors.Circles.red
        }
    }
}

struct Colors{
    static let inputBorder = UIColor(hex: "747474")
    static let border = UIColor(hex: "4F4545")
    static let homeRound = UIColor(hex: "1E1B1B")
    static let home = UIColor(hex: "1D1C1C")
    static let search = UIColor(red: 135/255, green: 135/255, blue: 135/255, alpha: 1.0)
    static let error = UIColor(red: 217/255, green: 83/255, blue: 69/255, alpha: 1.0)
    static let success = UIColor(red: 0/255, green: 151/255, blue: 60/255, alpha: 1.0)
    static let transactionSuccess = UIColor(hex: "00973C")
    static let transactionFailure = UIColor(hex: "B50000")
    static let transactionPending = UIColor(hex: "EEAB00")
    
    
    struct Circles{
        static let violet = UIColor(hex: "#520093")
        static let indigo = UIColor(hex: "#300194")
        static let blue = UIColor(hex: "#004D95")
        static let green = UIColor(hex: "#00973C")
        static let yellow = UIColor(hex: "#F4C11A")
        static let orange = UIColor(hex: "#B76300")
        static let red = UIColor(hex: "#B50000")
        static let grey = UIColor(hex: "#5D5D5D")
        static let black = UIColor.init(hex: "#000000")
    }
    
    struct borders{
        static let violet = UIColor(hex: "#8D30D6")
        static let indigo = UIColor(hex: "#424B99")
        static let blue = UIColor(hex: "#0345C3")
        static let green = UIColor(hex: "#4E9942")
        static let yellow = UIColor(hex: "#CACE00")
        static let orange = UIColor(hex: "#FF9900")
        static let red = UIColor(hex: "#BE0909")
        static let grey = UIColor(hex: "#5D5D5D")
    }
    
}

extension String{
    func getColor() -> UIColor{
        switch self{
        case "violet" : return Colors.Circles.violet
        case "indigo" : return Colors.Circles.indigo
        case "blue"   : return Colors.Circles.blue
        case "green"  : return Colors.Circles.green
        case "yellow" : return Colors.Circles.yellow
        case "orange" : return Colors.Circles.orange
        case "red"    : return Colors.Circles.red
        case "grey"    : return Colors.Circles.grey
        case "black" : return Colors.Circles.black
        default       : return Colors.Circles.violet
        }
    }
    
    func getBorderColor() -> CGColor{
        switch self{
        case "violet" : return Colors.borders.violet.cgColor
        case "indigo" : return Colors.borders.indigo.cgColor
        case "blue"   : return Colors.borders.blue.cgColor
        case "green"  : return Colors.borders.green.cgColor
        case "yellow" : return Colors.borders.yellow.cgColor
        case "orange" : return Colors.borders.orange.cgColor
        case "red"    : return Colors.borders.red.cgColor
        case "grey"   : return Colors.borders.grey.cgColor
        default       : return Colors.borders.violet.cgColor
        }
    }
    
    func getBorderUIColor() -> UIColor{
        switch self{
        case "violet" : return Colors.borders.violet
        case "indigo" : return Colors.borders.indigo
        case "blue"   : return Colors.borders.blue
        case "green"  : return Colors.borders.green
        case "yellow" : return Colors.borders.yellow
        case "orange" : return Colors.borders.orange
        case "red"    : return Colors.borders.red
        case "grey"   : return Colors.borders.grey
        default       : return Colors.borders.violet
        }
    }
    
    
    //static let circles = "https://d24p0kf6wpiidw.cloudfront.net/Sqrcle-Hero/SQRCLES Hero Videos/Circle changing/4.mp4",
                
                
    
    func getColorVideo() -> String{
        switch self{
        case "violet" : return "https://d24p0kf6wpiidw.cloudfront.net/Sqrcle-Hero/SQRCLES%20Hero%20Videos/Circle%20changing/3.mp4"
        case "indigo" : return "https://d24p0kf6wpiidw.cloudfront.net/Sqrcle-Hero/SQRCLES%20Hero%20Videos/Circle%20changing/2.mp4"
        case "blue"   : return "https://d24p0kf6wpiidw.cloudfront.net/Sqrcle-Hero/SQRCLES%20Hero%20Videos/Circle%20changing/1.mp4"
        case "green"  : return "https://d24p0kf6wpiidw.cloudfront.net/Sqrcle-Hero/SQRCLES Hero Videos/Circle changing/4.mp4"
        case "yellow" : return "https://d24p0kf6wpiidw.cloudfront.net/Sqrcle-Hero/SQRCLES Hero Videos/Circle changing/7.mp4"
        case "orange" : return "https://d24p0kf6wpiidw.cloudfront.net/Sqrcle-Hero/SQRCLES Hero Videos/Circle changing/6.mp4"
        case "red"    : return "https://d24p0kf6wpiidw.cloudfront.net/Sqrcle-Hero/SQRCLES Hero Videos/Circle changing/5.mp4"
        default       : return "https://d24p0kf6wpiidw.cloudfront.net/Sqrcle-Hero/SQRCLES%20Hero%20Videos/Circle%20changing/3.mp4"
        }
    }
    
}

extension UIColor {
    
    func getBorderColor() -> CGColor{
        switch self{
        case Colors.borders.violet : return Colors.borders.violet.cgColor
        case Colors.borders.indigo : return Colors.borders.indigo.cgColor
        case Colors.borders.blue   : return Colors.borders.blue.cgColor
        case Colors.borders.green  : return Colors.borders.green.cgColor
        case Colors.borders.yellow : return Colors.borders.yellow.cgColor
        case Colors.borders.orange : return Colors.borders.orange.cgColor
        case Colors.borders.red    : return Colors.borders.red.cgColor
        case Colors.borders.grey   : return Colors.borders.grey.cgColor
        default                    : return Colors.borders.violet.cgColor
        }
    }
    
    func initial() -> String{
        switch self{
        case Colors.Circles.violet : return "v"
        case Colors.Circles.indigo : return "i"
        case Colors.Circles.blue   : return "b"
        case Colors.Circles.green  : return "g"
        case Colors.Circles.yellow : return "y"
        case Colors.Circles.orange : return "o"
        case Colors.Circles.red    : return "r"
        default                    : return "v"
        }
    }
}

