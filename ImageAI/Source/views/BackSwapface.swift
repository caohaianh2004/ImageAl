
import SwiftUI

struct BackSwapface: View {
    
    @Binding var beforeImage: UIImage?
    let croppingOptions = CroppedPhotosPickerOptions(doneButtonTitle: "Select", doneButtonColor: .orange)
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                CroppedPhotosPicker(style: .default, options: croppingOptions, selection: $beforeImage) { rect in
                    Logger.success("Did crop to rect: \(rect)")
                } didCancel: {
                    Logger.success("Did cancel")
                } label: {
                    ZStack {
                        backImage()
                    }
                    .overlay {
                        if let newImage = beforeImage {
                            Image(uiImage: newImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 130, height: 140)
                                .cornerRadius(UIConstants.CornerRadius.extraLarge)
                                .clipped()
                            
                            VStack {
                                HStack {
                                    Spacer()
                                    Button {
                                        beforeImage = nil
                                    } label: {
                                        Image("ic_close")
                                            .resizable()
                                            .renderingMode(.template)
                                            .foregroundColor(.white)
                                            .fontWeight(.regular)
                                            .frame(width: UIConstants.sizeIconSmall)
                                            .padding(UIConstants.Padding.large)
                                            .background(
                                                RoundedRectangle(cornerRadius: UIConstants.CornerRadius.extraLarge).fill(Color.gray.opacity(0.3))
                                            )
                                    }
                                    .padding(UIConstants.Padding.superSmall)
                                    .frame(width: UIConstants.actionBarSize, height: UIConstants.actionBarSize)
                                    
                                }
                                Spacer()
                            }
                        }
                    }
                }
                Spacer()
            }
        }
    }
    
    func backImage() -> some View  {
        ZStack {
            Image(systemName: "person.badge.plus")
                .font(.system(size: 30))
            Rectangle()
                .stroke(style: StrokeStyle(lineWidth: 5, dash: [10]))
                .frame(width: 130, height: 140)
                .foregroundStyle(Color.blue)
                .cornerRadius(UIConstants.CornerRadius.extraLarge)
        }
    }
}
