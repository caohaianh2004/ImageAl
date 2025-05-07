import SwiftUI

enum AppTheme {
    // 👉 Đặt thành true nếu bạn muốn dùng hình ảnh làm nền
    static var useImageBackground = true

    // 👉 View trả về background phù hợp
    static var backgroundView: some View {
        Group {
            if useImageBackground {
                Image("img_tutorial_risewoman") // <-- Thay bằng tên ảnh trong Assets
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            } else {
                Color("BackgroundColor") // <-- Màu trong Assets nếu không dùng hình ảnh
                    .ignoresSafeArea()
            }
        }
    }
}
