import SwiftUI
import Kingfisher

struct ChosseStyle: View {
    @Binding var styleId: Int
    @StateObject var generate = HeadShots(Dataheadshot: dsheadshot)
    @EnvironmentObject var router: Router
    @Environment(\.dismiss) var dismiss
    @State private var selectedGender: String = "👥 All"
    @State private var selectedStyle: String = ""
    let items = ["👥All", "♂️Man", "♀️Woman"]
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var filteredByGender: [StyleHeadShot] {
        switch selectedGender {
        case "♂️Man":
            return dsheadshot.filter { $0.gender == "Man" }
        case "♀️Woman":
            return dsheadshot.filter { $0.gender == "Woman" }
        default:
            return dsheadshot
        }
    }

    var uniqueStyles: [String] {
        Array(Set(filteredByGender.map { $0.style })).sorted()
    }

    var groupedByStyle: [String: [StyleHeadShot]] {
        Dictionary(grouping: filteredByGender, by: { $0.style })
    }

    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                SettingTopbar()
                ScrollViewReader { scrollProxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            Button(action: {
                                withAnimation {
                                    selectedStyle = ""
                                    scrollProxy.scrollTo("All", anchor: .center)
                                }
                            }) {
                                Text("ALL")
                                    .id("All")
                                    .padding(10)
                                    .foregroundStyle(selectedStyle.isEmpty ? .white : .gray)
                                    .font(.system(size: UIConstants.TextSize.sizeall))
                                    .cornerRadius(10)
                                    .bold()
                                    .overlay(
                                        Rectangle()
                                            .fill(Color.white)
                                            .frame(height: selectedStyle.isEmpty ? 4 : 0)
                                            .offset(y: 1),
                                        alignment: .bottom
                                    )
                            }

                            ForEach(uniqueStyles, id: \.self) { style in
                                Button(action: {
                                    withAnimation {
                                        selectedStyle = style
                                        scrollProxy.scrollTo(style, anchor: .center)
                                    }
                                }) {
                                    Text(style.uppercased())
                                        .id(style)
                                        .padding(10)
                                        .foregroundStyle(selectedStyle == style ? Color.white : Color.gray)
                                        .font(.system(size: UIConstants.TextSize.sizeall))
                                        .cornerRadius(10)
                                        .bold()
                                        .overlay(
                                            Rectangle()
                                                .fill(Color.white)
                                                .frame(height: selectedStyle == style ? 4 : 0)
                                                .offset(y: 1),
                                            alignment: .bottom
                                        )
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }

                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(filteredImages(), id: \.id) { item in
                            Button(action: {
                                styleId = item.id
                                router.createHeadShot = item
                                dismiss()
                            }) {
                                ZStack {
                                    KFImage.url(URL(string: item.avatar))
                                        .placeholder {
                                            ShimmerEffect().cornerRadius(UIConstants.CornerRadius.large)
                                        }
                                        .loadDiskFileSynchronously()
                                        .cacheMemoryOnly()
                                        .resizable()
                                        .frame(width: 100, height: 120)
                                        .cornerRadius(UIConstants.CornerRadius.large)
                                    
                                    if styleId == item.id {
                                        RoundedRectangle(cornerRadius: UIConstants.CornerRadius.large)
                                            .strokeBorder(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [
                                                        .Color.colorBlueStart,
                                                        .Color.colorControlSelected
                                                    ]),
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                ),
                                                lineWidth: 3
                                            )
                                            .frame(width: 100, height: 120)
                                    }
                                }
                                .overlay(
                                    VStack {
                                        Spacer()
                                        HStack {
                                            Spacer()
                                            Text(localizedKey: "abc_try")
                                                .font(.system(size: UIConstants.Padding.medium, weight: .bold))
                                                .foregroundColor(.white)
                                                .frame(width: UIConstants.sizeCardTry,
                                                       height: UIConstants.sizeCardTry)
                                                .background(Circle()
                                                    .fill(Color(.Color.colorTextSelected)))
                                        }
                                        .padding(UIConstants.Padding.superSmall)
                                    }
                                )
                            }
                        }
                        .onAppear {}
                    }
                    .padding()
                }
            }
        }
    }

    func filteredImages() -> [StyleHeadShot] {
        if selectedStyle.isEmpty {
            return filteredByGender
        } else {
            return groupedByStyle[selectedStyle] ?? []
        }
    }

    @ViewBuilder
    func SettingTopbar() -> some View {
        HStack {
            Button {
                router.navigateBack()
            } label: {
                Image("ic_back")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(1, contentMode: .fit)
                    .bold()
                    .padding(UIConstants.Padding.medium)
                    .foregroundColor(.Color.colorPrimary)
                    .frame(height: UIConstants.actionBarSize)
            }

            Spacer()

            Text(localizedKey: "abc_choose_style")
                .font(.system(size: UIConstants.TextSize.avatarStyle, weight: .bold, design: .default))
                .fontWeight(.bold)
                .foregroundColor(.Color.colorPrimary)
                .padding(.leading, 25)

            Spacer()

            Menu {
                ForEach(items, id: \.self) { gender in
                    Button {
                        selectedGender = gender
                    } label: {
                        Text(gender)
                    }
                }
            } label: {
                Text(selectedGender)
                    .foregroundColor(.white)
                    .frame(width: 90, height: 40)
                    .font(.system(size: UIConstants.TextSize.sizeall))
                    .background(
                        RoundedRectangle(cornerRadius: UIConstants.CornerRadius.large)
                            .strokeBorder(
                                LinearGradient(
                                    gradient: Gradient(colors: [.Color.colorBlueStart, .Color.colorControlSelected]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                lineWidth: 3
                            )
                    )
            }
        }
    }
}

//#Preview {
//    ChosseStyle()
//}
