//
//  ContentView.swift
//  WidgetKit_NatureTime
//
//  Created by Hollins, Cecilia on 31/10/2022.
//

import SwiftUI

struct ContentView: View {
    
    @State var currentTheme: NatureTheme = .beach
    @State var currentDate = Date()
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    
    @State var modal: Bool = false
    
    var body: some View {
        VStack {
            Text("Preview your widget")
                .font(.title)
                .padding()
            
            Text("This app creates a time widget that will display the current time on the device home screen in a more asthetically pleasing way. Click on the button below to see other themes.")
                .padding()
                .multilineTextAlignment(.center)
            
            TimeView(theme: currentTheme, imageSize: 250, time: currentDate)
                .padding()
                .onReceive(timer) { input in
                    currentDate = input
                }
            
            Button("Change widget settings") {
                modal.toggle()
            }

        }
        .sheet(isPresented: $modal) {
            List {
                ForEach(NatureTheme.allCases, id: \.rawValue) { theme in
                    HStack {
                        Image(systemName: "checkmark")
                            .foregroundColor(theme == currentTheme ? .gray : .white)
                        
                        Button(theme.rawValue) {
                            self.currentTheme = theme
                        }
                        .foregroundColor(.black)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
