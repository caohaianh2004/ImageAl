//
//  HistoryScreen.swift
//  ImageAI
//
//  Created by DoanhMac on 7/3/25.
//

import SwiftUI
import Kingfisher


struct HistoryScreen: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var router: Router
    @State var currentData:String  = ""
  
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack(alignment: .leading, spacing: UIConstants.Padding.medium) {
                SettingTopbar()
                if userViewModel.userState.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .foregroundColor(.white)
                } else if let error = userViewModel.userState.error {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                } else {
                    ScrollView {
                        LazyVStack(spacing: UIConstants.Padding.medium) {
                            ForEach(userViewModel.userState.users, id: \.id) { user in
        
//                                let user = userViewModel.userState.users[index]
                                Button(action: {
                                   
                                    if user.type == 1 {
                                        let easeItem = EaseItem(index: -1, nsfw: false, origin: user.imageUrl, thumb: user.imageUrl)
                                        let easeRequest = EaseCreateRequest(prompt: user.prompt, size: user.sizeCanvas, style: user.styleId)
                                        router.currentDate = user.date
                                        router.navigateTo(.result_image([easeItem], easeRequest, true, false))
                                        
                                    } else if user.type == 2 {
                                        let request = EnhanceCreateRequest(
                                            mode: user.sizeCanvas,
                                            size: user.styleId,
                                            images: []
                                        )
                                        router.currentDate = user.date
                                        if let beforeImage = loadImageFromDocuments(path: user.prompt) {
                                            router.navigateTo(.result_enhance(beforeImage, nil, request, false, user.imageUrl, true))
                                        }
                                        
                                    } else if user.type == 3 {
                                        let request = RestoreCreateRequest(
                                            restore_type: user.sizeCanvas,
                                            images: []
                                        )
                                        router.currentDate = user.date
                                        if let beforeImage = loadImageFromDocuments(path: user.prompt) {
                                            router.navigateTo(.result_restore(beforeImage, nil, request,user.imageUrl, true))
                                        }
                                        
                                    } else if user.type == 5  {
                                        let request = HeadShort(
                                            size: user.sizeCanvas,
                                            style: user.styleId,
                                            images: []
                                        )
                                        router.currentDate = user.date
                                        if let beforeImage = loadImageFromDocuments(path: user.prompt) {
                                            router.navigateTo(.result_headshot(beforeImage, nil, request, false, user.imageUrl, true))
                                        }
                                    } else if user.type == 6  {
                                        let request = SwapFace(
                                            originals: [],
                                            faces: []
                                        )
                                        router.currentDate = user.date
                                        if let beforeImage = loadImageFromDocuments(path: user.prompt) {
                                            router.navigateTo(.result_swapface(beforeImage, nil, request, false, user.imageUrl, true))
                                        }
                                    } else {
                                        let request = MultiSFace(
                                            original: "",
                                            images: []
                                        )
                                        router.currentDate = user.date
                                        if let beforeImage = loadImageFromDocuments(path: user.prompt) {
                                            router.navigateTo(.result_multiface(beforeImage, nil, request, false, user.imageUrl, true))
                                        }
                                    }
                                    
                                }) {
                                    HStack(spacing: UIConstants.Padding.medium) {
                                        KFImage.url(URL(string: user.imageUrl))
                                            .placeholder {
                                                ShimmerEffect().cornerRadius(UIConstants.CornerRadius.large)
                                            }
                                            .loadDiskFileSynchronously()
                                            .cacheMemoryOnly()
                                            .resizable()
                                            .frame(width: UIConstants.sizeCardItem - UIConstants.Padding.small, height: UIConstants.sizeCardItem)
                                            .clipShape(RoundedCorner(radius: UIConstants.CornerRadius.medium,
                                                                     corners: [.topLeft, .topRight]))
                                        
                                        VStack(alignment: .leading, spacing: UIConstants.Padding.small) {
                                            if user.type == 1 {
                                                Text(user.prompt)
                                                    .bold()
                                                    .multilineTextAlignment(.leading)
                                                    .lineLimit(2)
                                                    .font(.system(size: UIConstants.TextSize.largeBody))
                                                    .foregroundColor(.white)
                                            } else if user.type == 2 {
                                                Text(localizedKey: "abc_tab_echance")
                                                    .bold()
                                                    .multilineTextAlignment(.leading)
                                                    .lineLimit(1)
                                                    .font(.system(size: UIConstants.TextSize.largeBody))
                                                    .foregroundColor(.white)
                                            } else {
                                                Text(localizedKey: "abc_tab_restore")
                                                    .bold()
                                                    .multilineTextAlignment(.leading)
                                                    .lineLimit(1)
                                                    .font(.system(size: UIConstants.TextSize.largeBody))
                                                    .foregroundColor(.white)
                                            }
                                            
                                            Text(user.date)
                                                .font(.system(size: UIConstants.TextSize.body))
                                                .lineLimit(2)
                                                .multilineTextAlignment(.leading)
                                                .foregroundColor(.gray)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            Spacer()
                                            
                                            
                                            Text(
                                                String(
                                                    format: LocalizationSystem.sharedInstance.localizedStringForKey(key: "abc_note_history", comment: ""),
                                                    user.currentDay
                                                )
                                            )
                                            
                                            
                                            .font(.system(size: UIConstants.TextSize.cardTitle))
                                            .lineLimit(1)
                                            .multilineTextAlignment(.leading)
                                            .foregroundColor(.red)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                        }.padding(12)
                                        
                                        VStack {
                                            Spacer()
                                            Button {
                                                
                                             Task {
                                                 await userViewModel.removeImage(id: user.id ?? 1)
                                            }
                                                
                                            } label: {
                                                Rectangle()
                                                    .cornerRadius(UIConstants.Padding.medium, corners: [.topLeft, .bottomRight]).overlay {
                                                        Image(systemName: "trash")
                                                            .resizable()
                                                            .foregroundColor(.white)
                                                            .frame(width: UIConstants.sizeIconSmall, height: UIConstants.sizeIconSmall)
                                                        
                                                    }
                                                    .frame(width: 34, height: 34)
                                            }
                                            
                                        }
                                    }
                                    
                                    .background(Color(.Color.colorAccent))
                                    .cornerRadius(UIConstants.CornerRadius.large)
                                   
                                    
                                } .frame(height: 120,alignment: .leading)
                            }
                        }
                        .padding()
                    }
                }
            }
           
        }
        .onAppear {
            Task {
                await userViewModel.fetchAllImages()
            }
        }
    }
  

    @ViewBuilder
    func SettingTopbar() -> some View{
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
                    .frame(height: UIConstants.actionBarSize )
                
            }
            
            Spacer()
            Text(localizedKey: "abc_history")
                .font(.system(size: UIConstants.TextSize.title, design: .default))
                .fontWeight(.bold)
            
                .foregroundColor(.Color.colorPrimary)
            Spacer()
          Rectangle().frame(width: UIConstants.actionBarSize, height: UIConstants.actionBarSize).opacity(0)
        }
    }
}


//#Preview {
//    HistoryScreen()
//}
