//
//  Rocket.swift
//  Contur2
//
//  Created by Никита on 14/08/2022.
//  Copyright © 2022 com.example. All rights reserved.
//

import UIKit

struct racket{
    
    var iconsLabelNameFt: [String] = ["Высота, ft", "Диаметр, ft", "Масса, lb", "Нагрузка leo, lb"]
    var iconsLabelValueFt:[String]
    var InfoValueLabel: [String]
    
    init(iconsLabelValueFt:[String], InfoValueLabel: [String]) {
        self.iconsLabelValueFt = iconsLabelValueFt
        self.InfoValueLabel = InfoValueLabel
    }
    
}
