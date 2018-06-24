//
//  HelpCenter.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 11/6/17.
//  Copyright © 2017 Valtech. All rights reserved.
//

import Foundation

struct HelpCenter: Decodable {
    let errorCode: String?
    let errorMessage: String?
    
    let accordionDetails: [AccordionDetails]?
    
    struct AccordionDetails: Decodable {
        let title: String?
        let imagePath: String?
        let quesAnsValues: [QuesAnsValues]?
        
        struct QuesAnsValues: Decodable {
            let quest: String?
            let ans: String?
        }
    }
}
