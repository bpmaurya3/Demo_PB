//
//  HomeModel.swift
//  PayBack
//
//  Created by Bhuvanendra Pratap Maurya on 5/17/18.
//  Copyright © 2018 Valtech. All rights reserved.
//

import Foundation

class HomeModel: NSObject, Decodable {
    var appHome: AppHome?
    override init() {
        super.init()
    }
}

struct AppHome: Decodable {
    let headerInfo: HeaderInfo?
    let navigationSections: [NavigationSections]?
    let showcaseList: [ShowcaseList]?
}
struct HeaderInfo: Decodable {
    let headerTextColor: String?
    let headerBGColor: String?
    let headerBarCodeIcon: String?
    let headerNonLogInTxt: String?
    let headerNonLogInDescTxt: String?
}
struct NavigationSections: Decodable {
    let title: String?
    let imagePath: String?
    let iconImagePath: String?
    let allowBgLayout: Bool?
    let uniqueKey: String?
}
struct ShowcaseList: Decodable {
    let title: String?
    let channelType: String?
    let id: String?
    let showcaseCarousel: [ShowcaseCarousel]?
    let showcaseGrid: [ShowcaseGrid]?
}
struct ShowcaseCarousel: Decodable {
    let imagePath: String?
    let redirectionURL: String?
}
struct ShowcaseGrid: Decodable {
    let logoPath: String?
    let redirectionURL: String?
    let ctaLabel: String?
    let title: String?
}
