import SwiftUI

struct CircleMulti: View {
    @Binding var beforeImage: UIImage?
    let croppingOptions = CroppedPhotosPickerOptions(doneButtonTitle: "Select", doneButtonColor: .orange)
    var onImageChanged: (UIImage?) -> Void
    @State private var listImage: [UIImage] = []

    var body: some View {
        ZStack {
            BackgroundView()
            VStack(spacing: 20) {
                CroppedPhotosPicker(style: .default, options: croppingOptions, selection: $beforeImage) { rect in
                    Logger.success("Did crop to rect: \(rect)")
                    if let image = beforeImage {
                        addImage(image)
                    }
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
                                removeImage(image)
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

    private func addImage(_ image: UIImage) {
//        if !listImage.contains(where: { $0.pngData() == image.pngData() }) {
            listImage.append(image)
//        }
//        print("\(listImage.count)")
        onImageChanged(image)
    }

    private func removeImage(_ image: UIImage) {
        listImage.removeAll(where: { $0.pngData() == image.pngData() })
        beforeImage = nil
        onImageChanged(nil)
    }
}
