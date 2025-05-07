//
//  ContentView.swift
//  ImageAI
//
//  Created by DoanhMac on 7/3/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        RouterView {
            SplashScreen()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch)"))
    }
}
