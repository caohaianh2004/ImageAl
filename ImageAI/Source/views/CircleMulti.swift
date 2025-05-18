import SwiftUI

struct CircleMulti: View {
    @Binding var beforeImage: UIImage?
    @State var styleId: Int = 0
    var onDelete: () -> Void = {}
    let croppingOptions = CroppedPhotosPickerOptions(doneButtonTitle: "Select", doneButtonColor: .orange)
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack(spacing: 20) {
                CroppedPhotosPicker(style: .default, options: croppingOptions, selection: $beforeImage) { rect in
                    Logger.success("Did crop to rect: \(rect)")
                } didCancel: {
                    Logger.success("Did cancel")
                } label: {
                    ZStack(alignment: .topTrailing) {
                        Circle()
                            .stroke(style: StrokeStyle(lineWidth: 2, dash: [30]))
                            .frame(width: 80, height: 80)
                        if let image = beforeImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                .shadow(radius: 4)

                            Button(action: {
                                beforeImage = nil
                                onDelete()
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.red)
                                    .background(Color.white.clipShape(Circle()))
                            }
                            .offset(x: 10, y: -10)
                        } else {
                            ZStack {
                                Circle()
                                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [6]))
                                    .frame(width: 80, height: 80)
                                Image(systemName: "sparkles")
                                    .font(.system(size: 25))
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
        }
    }
}
