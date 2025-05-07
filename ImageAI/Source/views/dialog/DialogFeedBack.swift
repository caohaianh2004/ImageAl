//
//  DialogFeedBackl.swift
//  ImageAI
//
//  Created by DoanhMac on 24/3/25.
//

import SwiftUI
struct DialogFeedBack: View {
    @State private var inputText = ""
    @State private var selectedButtons: Set<Int> = []
    let onDismissDilog:() -> ()
    let onSubmitDialog:(String) -> ()
    
    let buttonTexts = [
        1: LocalizationSystem.sharedInstance.localizedStringForKey(key: "feedback_sexual_content", comment: ""),
        2: LocalizationSystem.sharedInstance.localizedStringForKey(key: "feedback_realistic_violence", comment: ""),
        3: LocalizationSystem.sharedInstance.localizedStringForKey(key: "feedback_vulgar_jokes", comment: ""),
        4: LocalizationSystem.sharedInstance.localizedStringForKey(key: "feedback_racism", comment: ""),
        5: LocalizationSystem.sharedInstance.localizedStringForKey(key: "feedback_other", comment: "")
    ]
    var body: some View {
        ZStack {
            
            Color.black.opacity(0.5)
              
            VStack(spacing: UIConstants.Padding.large) {
                Text("abc_feedback")
                    .font(.system(size: UIConstants.TextSize.title))
                    .bold()
                    .foregroundColor(.white)
                
                Text("feedback_please_tell_us")
                    .font(.system(size: UIConstants.TextSize.body))
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.white)
                
                TextEditor(text: $inputText)
                    .placeholder(when: inputText.isEmpty) {
                        Text(localizedKey: "feedback_hint")
                            .font(.system(size: UIConstants.TextSize.caption))
                            .foregroundColor(.Color.colorTextItemSettingDim)
                    }
                    .font(.system(size: UIConstants.TextSize.caption))
                    .frame(width: .infinity, height: 140)
                    .foregroundColor(.Color.colorPrimary)
                    .fixedSize(horizontal: false, vertical: true)
                    .fontWeight(.medium)
                    .scrollContentBackground(.hidden)
                    .padding(UIConstants.Padding.small)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .onChange(of: inputText) { _,newValue in
                        updateSelectedButtons(from: newValue)
                    }
                
                Text("feedback_what_you_dont")
                    .font(.system(size: UIConstants.TextSize.body))
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.white)
                    .padding(.top, 10)
                
                VStack(alignment: .leading) {
                    HStack {
                        buttonWithText(2)
                        buttonWithText(3)
                        buttonWithText(4)
                        Spacer()
                    }
                    HStack {
                        buttonWithText(1)
                        buttonWithText(5)
                        Spacer()
                    }
                }
                
                Button("feedback_submit") {
                    onSubmitDialog(inputText)
                    onDismissDilog()
                }
                .padding(UIConstants.Padding.large)
                .bold()
                .font(.system(size: UIConstants.TextSize.body))
                .frame(maxWidth: .infinity)
                .background(inputText.isEmpty ? Color.gray : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(UIConstants.CornerRadius.medium)
                .disabled(inputText.isEmpty)
                
            }
            .padding(.vertical, UIConstants.Padding.large)
            .padding(UIConstants.Padding.medium)
            .background(Color(.Color.colorAccent))
            .clipShape(RoundedCorner(radius: 12))
            .padding(UIConstants.Padding.medium)
        }.onTapGesture {
            onDismissDilog()
        }
    }
    

    func buttonWithText(_ index: Int) -> some View {
        Button(action: {
            withAnimation {
                if selectedButtons.contains(index) {
                 
                    selectedButtons.remove(index)
                    inputText = inputText.replacingOccurrences(of: buttonTexts[index] ?? "", with: "").trimmingCharacters(in: .whitespaces)
                } else {
                 
                    selectedButtons.insert(index)
                    inputText += (inputText.isEmpty ? "" : " ") + (buttonTexts[index] ?? "")
                }
            }
        }) {
            Text(localizedKey: buttonTexts[index] ?? "")
                .padding()
                .foregroundColor(.white)
                .font(.system(size: UIConstants.TextSize.caption))
                .background(Color.gray.opacity(0.2))
                .cornerRadius(UIConstants.CornerRadius.medium)
               
        }
    }
    
    private func updateSelectedButtons(from newValue: String) {
        let currentTexts = Set(newValue.components(separatedBy: " "))
        for (index, text) in buttonTexts {
            if !currentTexts.contains(text) {
                selectedButtons.remove(index)
            }
        }
    }
}


#Preview {
    DialogFeedBack {
        
    } onSubmitDialog: { a in
        
    }

}
