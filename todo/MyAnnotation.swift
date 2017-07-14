//
//  MyAnnotation.swift
//  PinTask
//
//  Created by Placoderm on 7/13/17.
//  Copyright © 2017 Placoderm. All rights reserved.
//

import UIKit
import MapKit

class MyAnnotation: NSObject, MKAnnotation {
    
    var title: String?
    var subtitle: String?
    
    var coordinate: CLLocationCoordinate2D
    
    init(title: String?, coordinate: CLLocationCoordinate2D, subtitle: String?) {
        
        self.title = title
        self.coordinate = coordinate
        self.subtitle = subtitle
    }
}
