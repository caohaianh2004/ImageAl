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
    @State private var listImage: [UIImage] = []
    
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
                            .frame(width: 50)
                            .clipShape(Circle())
                    } else {
                        buttonCricle()
                    }
                }
                .onChange(of: beforeImage) { _, newValue in
                    if let image = newValue {
                        listImage.append(image)
                        beforeImage = nil
                    }
                }
                
                if !listImage.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(Array(listImage.enumerated()), id: \.offset) { index, image in
                                ZStack(alignment: .trailing) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 80, height: 80)
                                        .clipShape(Circle())
                                    
                                    Button {
                                        listImage.remove(at: index)
                                    } label: {
                                        Image("ic_close")
                                            .resizable()
                                            .renderingMode(.template)
                                            .foregroundStyle(Color.white)
                                            .frame(width: 10, height: 10)
                                            .bold()
                                            .padding(UIConstants.Padding.large)
                                    }
                                    .offset(x: 1, y: -15)
                                }
                            }
                        }

                    }
                }
                Spacer()
            }
            .padding()
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
