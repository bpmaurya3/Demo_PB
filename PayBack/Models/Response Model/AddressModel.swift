//
//  AddressModel.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 3/6/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import Foundation

struct AddressSplitCellModel: Codable {
    var name: String?
    var address1: String?
    var address2: String?
    var ExtraAddress1: String?
    var city: String?
    var state: String?
    var pin: String?
    var mobile: String?
    var emailid: String?
    var id: String?
    var defaultaddress: String?
    var tempDefaultaddress: String?
    
    init(name: String?, address1: String?, address2: String?, ExtraAddress1: String = "", city: String?, state: String?, pin: String?, mobile: String?, emailid: String?, defaultaddress: String?, id: String?) {
        
        self.name = name
        self.address1 = address1
        self.address2 = address2
        self.ExtraAddress1 = ExtraAddress1
        self.city = city
        self.state = state
        self.pin = pin
        self.mobile = mobile
        self.emailid = emailid
        self.defaultaddress = defaultaddress
        self.tempDefaultaddress = defaultaddress
        if let id = id, !id.isEmpty {
            self.id = id
        }
    }
    
    init(withAddressDetails result: DeliveryAddress.Address) {
        
        if let name = result.name {
            self.name = name
        }
        if let email = result.emailid {
            self.emailid = email
        }
        if let mobileno = result.mobile {
            self.mobile = mobileno
        }
        if let address1 = result.address1 {
            self.address1 = address1
        }
        if let address2 = result.address2 {
            self.address2 = address2
        }
        if let city = result.city {
            self.city = city
        }
        if let state = result.state {
            self.state = state
        }
        if let pincode = result.pin {
            self.pin = pincode
        }
        if let id = result.id {
            self.id = id
        }
        if let isDefault = result.defaultaddress {
            self.defaultaddress = isDefault
            self.tempDefaultaddress = isDefault
        }
    }
}
