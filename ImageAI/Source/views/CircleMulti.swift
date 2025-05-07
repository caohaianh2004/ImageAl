//
//  CircleMulti.swift
//  ImageAI
//
//  Created by Boss on 06/05/2025.
//

import SwiftUI

struct CircleMulti: View {
    @State var beforeImage: UIImage?
    @State var styleId: Int = 0
    let croppingOptions = CroppedPhotosPickerOptions(doneButtonTitle: "Select",doneButtonColor: .orange)
    

    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                CroppedPhotosPicker(style: .default, options: croppingOptions, selection: $beforeImage) { rect in
                    Logger.success("Did crop to rect: \(rect)")
                } didCancel: {
                    Logger.success("Did cancel")
                } label: {
                    if let newImage = beforeImage {
                        Image(uiImage: newImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80)
                            .clipShape(Circle())
                    } else {
                        buttonCricle()
                    }
                }
                .overlay {
                    if beforeImage != nil {
                        ZStack{
                            if let newImage = beforeImage {
                                Image(uiImage: newImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100)
                                    .clipShape(Circle())
                            }
                        }
                        
                        VStack {
                            HStack {
                                Spacer()
                                Button {
                                    beforeImage = nil
                                    styleId = 0
                                } label: {
                                    Image("ic_close")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundStyle(Color.white)
                                        .frame(width: 10, height: 10)
                                        .bold()
                                        .padding(UIConstants.Padding.large)
                                }
                                .frame(width: UIConstants.actionBarSize, height: UIConstants.actionBarSize)
                                .padding()
                                .offset(x: 8, y: -15)
                            }
                            Spacer()
                        }
                    }
                }
            }
        }
    }
    
    func buttonCricle() -> some View {
        ZStack {
            VStack {
                Image(systemName: "sparkles")
                    .foregroundColor(.blue)
                    .font(.system(size: 25))
            }
            Circle()
                .stroke(style: StrokeStyle(lineWidth: 2, dash: [9]))
                .frame(width: 50)
        }
    }
}

#Preview {
    CircleMulti()
}
