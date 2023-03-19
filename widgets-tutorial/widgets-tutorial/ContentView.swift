//
//  ContentView.swift
//  WidgetKit_NatureTime
//
//  Created by Hollins, Cecilia on 31/10/2022.
//

import SwiftUI

struct ContentView: View {
    
    @State var currentDate = Date()
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    
    var body: some View {
        TimeView(theme: .beach, imageSize: 250, time: currentDate)
            .padding()
            .onReceive(timer) { input in
                currentDate = input
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
