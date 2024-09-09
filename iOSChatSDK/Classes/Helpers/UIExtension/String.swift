//
//  String.swift
//  Dynasas
//
//  Created by Dynasas on 22/08/23.
//

import Foundation
import UIKit


extension String {
    var modifiedString: String {
        return self.replacingOccurrences(of: "mxc://", with: "http://chat.sqrcle.co/_matrix/media/v3/download/")
    }
    
    var mediaURL: URL? {
        return URL(string: self.modifiedString)
    }
    
}


public extension CaseIterable where Self: Equatable {

    func ordinal() -> Self.AllCases.Index {
        return Self.allCases.firstIndex(of: self)!
    }
    

}
