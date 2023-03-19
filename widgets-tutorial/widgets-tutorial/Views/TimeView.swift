//
//  TimeView.swift
//  WidgetKit_NatureTime
//
//  Created by Hollins, Cecilia on 31/10/2022.
//

import SwiftUI

struct TimeView: View {
    
    let theme: NatureTheme
    let imageSize: CGFloat
    let time: Date
    
    var body: some View {
        ZStack {
            getTimeImage
            getTime
        }
    }
    
    var getTimeImage: some View {
        let components = Calendar.current.dateComponents([.hour], from: Date())
        let hour = components.hour ?? 0
        
        if hour >= 6 && hour < 9 {
            return Group {
                theme.sunriseImage
                    .resizable()
                    .frame(width: imageSize, height: imageSize)
                    .cornerRadius(10)
            }
        } else if hour >= 9 && hour < 13 {
            return Group {
                theme.morningImage
                    .resizable()
                    .frame(width: imageSize, height: imageSize)
                    .cornerRadius(10)
            }
        } else if hour >= 13 && hour < 18 {
            return Group {
                theme.afternoonImage
                    .resizable()
                    .frame(width: imageSize, height: imageSize)
                    .cornerRadius(10)
            }
        } else if hour >= 18 && hour < 21 {
            return Group {
                theme.sunsetImage
                    .resizable()
                    .frame(width: imageSize, height: imageSize)
                    .cornerRadius(10)
            }
        } else {
            return Group {
                theme.nightImage
                    .resizable()
                    .frame(width: imageSize, height: imageSize)
                    .cornerRadius(10)
            }
        }
    }
    
    var getTime: some View {
        ZStack {
            Rectangle()
                .fill(Color.white.opacity(0.5))
                .frame(maxWidth: 150, maxHeight: 50)
                .cornerRadius(10)
            Text(time, format: .dateTime.hour().minute())
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.white)
        }
    }
}

struct TimeView_Previews: PreviewProvider {
    static var previews: some View {
        TimeView(theme: .beach, imageSize: 250, time: Date())
    }
}
