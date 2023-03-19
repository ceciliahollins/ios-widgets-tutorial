//
//  NatureTheme.swift
//  WidgetKit_NatureTime
//
//  Created by Hollins, Cecilia on 31/10/2022.
//

import SwiftUI

enum NatureTheme: String, CaseIterable {    
    case beach
    case park
    case city
    
    var sunriseImage: Image {
        switch self {
        case .beach:
            return Image("beachSunrise")
        case .park:
            return Image("parkSunrise")
        case .city:
            return Image("citySunrise")
        }
    }
    
    var morningImage: Image {
        switch self {
        case .beach:
            return Image("beachMorning")
        case .park:
            return Image("parkMorning")
        case .city:
            return Image("cityMorning")
        }
    }
    
    var afternoonImage: Image {
        switch self {
        case .beach:
            return Image("beachAfternoon")
        case .park:
            return Image("parkAfternoon")
        case .city:
            return Image("cityAfternoon")
        }
    }
    
    var sunsetImage: Image {
        switch self {
        case .beach:
            return Image("beachSunset")
        case .park:
            return Image("parkSunset")
        case .city:
            return Image("citySunset")
        }
    }
    
    var nightImage: Image {
        switch self {
        case .beach:
            return Image("beachNight")
        case .park:
            return Image("parkNight")
        case .city:
            return Image("cityNight")
        }
    }
}
