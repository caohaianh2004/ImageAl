//
//  ManageSwapFace.swift
//  ImageAI
//
//  Created by Boss on 23/04/2025.
//

import SwiftUI

struct ManageSwapFace: View {
    @State private var selectedTab = 0
    @ObservedObject var enhanceViewModel: EnhanceRestoreViewModel
   
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                Picker("", selection: $selectedTab) {
                    Text("SWAP FACE").tag(0)
                    Text("MULTIPLE FACES").tag(1)
                }
                .pickerStyle(.segmented)
                .padding()
                
                Group {
                    if selectedTab == 0 {
                        Swapface(enhanceViewModel: enhanceViewModel)
                    } else if selectedTab == 1 {
                        MultiSwapFace(enhanceViewModel: enhanceViewModel)
                    }
                }
            }
        }
    }
}

#Preview {
    ManageSwapFace(enhanceViewModel: EnhanceRestoreViewModel(repository: AppDIContainer.shared.appRepository))
}
