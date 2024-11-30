//
//  JoinPage.swift
//  RunUs
//
//  Created by byeoungjik on 10/1/24.
//

import SwiftUI
import PhotosUI

struct JoinPage: View {
    @ObservedObject var joinService = AuthService()
    @Environment(\.dismiss) var dismiss
    @Binding var loginSuccess: Bool
    @State var selectedProfile: [UIImage] = []
    @State private var nickname: String = ""
    @State private var nicknameIsValid: Bool = true
    @State var gender = "성별을 선택해주세요"
    @State var showGenderPicker = false
    @State var showAddProfile = false
    @FocusState private var isTextFieldFocused: Bool
    @State var isPresentedError: Bool = false
    @State var genderType: GenderType = .none
    let userDefaults = UserDefaults.standard
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.primaryBG)
                    .onTapGesture {
                        if isTextFieldFocused {
                            isTextFieldFocused = false
                        }
                    }
                VStack(alignment:.center) {
                    
                    Text("만나서 반가워요!")
                        .font(.title4_semibold)
                        .foregroundStyle(.primaryGray)
                        .padding(.top, 64)
                    Text("러너 프로필을 만들어 볼까요?")
                        .font(.body2_medium)
                        .foregroundColor(.quaternaryGray)
                        .padding(8)
                    
                    Button(action: {
                        showAddProfile = true
                    }, label: {
                        profileImage
                            .overlay(alignment: .bottomTrailing) {
                                Image("plus_profile_button")
                            }
                            .padding(36)
                    })
                    .sheet(isPresented: $showAddProfile, content: {
                        AddProfileSheet(selectedImages: $selectedProfile, isPresentedError: $isPresentedError)
                            .presentationDetents([.fraction(0.21)])
                    })
                    
                    VStack(alignment: .leading) {
                        Text("닉네임")
                            .font(.body1_bold)
                            .foregroundColor(nicknameIsValid ? .secondaryGray : .error)
                        
                        TextField("한글, 영어, 숫자만 입력 가능해요", text: $nickname)
                            .onChange(of: nickname) { _,newValue in
                                nicknameIsValid = newValue.count <= 8 && !containsSpecialCharacters(text: newValue)
                            }
                            .focused($isTextFieldFocused)
                            .autocapitalization(.none)
                            .disableAutocorrection(false)
                            .foregroundColor(nickname.count > 0 ? .primaryGray : .quaternaryGray)
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(!nicknameIsValid ? .error :
                                                nickname.count > 0 ? .secondaryGray : .quaternaryGray, lineWidth: 1)
                            )
                            .padding(.vertical, 8)
                        
                        HStack {
                            Text(errorText())
                            Spacer()
                            Text("\(nickname.count)/8")
                        }
                        .foregroundColor(nicknameIsValid ? .gray400 : .error)
                        .font(.caption_regular)
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        Text("성별")
                            .font(.body1_bold)
                            .foregroundColor(.secondaryGray)
                        Spacer()
                        Button(action: {
                            showGenderPicker = true
                        }, label: {
                            Text("\(gender)")
                                .font(.body1_medium)
                                .foregroundColor(gender == "성별을 선택해주세요" ? .quaternaryGray : .secondaryGray)
                        })
                        .sheet(isPresented: $showGenderPicker, content: {
                            GenderPickerSheet(gender: $gender, showGenderPicker: $showGenderPicker, genderType: $genderType)
                                .presentationDetents([.fraction(0.25)])
                        })
                    }
                    .padding()
                    
                    Spacer()
                    
                    Divider()
                        .foregroundStyle(.secondaryFill)
                        .padding(.vertical)
                    Button(action: {
                        joinService.signup(nickName: nickname, provider: "KAKAO", gender: genderType.rawValue) { result in
                            if result {
                                loginSuccess = true
                                dismiss()
                            }
                        }
                    }, label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .frame(height: 56)
                                .padding(.horizontal)
                                .foregroundColor(nickname.isEmpty || gender == "성별을 선택해주세요" || !nicknameIsValid ? .secondaryFill : .primary400)
                            Text("시작하기")
                                .font(.title5_bold)
                                .foregroundColor(nickname.isEmpty || gender == "성별을 선택해주세요" || !nicknameIsValid ? .primaryFill : .white)
                        }
                    })
                    .disabled(nickname.count <= 2 || gender == "성별을 선택해주세요" || !nicknameIsValid)
                }
                .padding(.vertical, 40)
            }
            .ignoresSafeArea()
        }
        .navigationBarItems(leading: Button(action: {
            dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.primaryGray)
            Text("프로필 설정")
                .font(.body1_medium)
                .foregroundColor(.primaryGray)
            
        })
    }
    
    var profileImage: some View {
        Group {
            if let lastImage = selectedProfile.last {
                Image(uiImage: lastImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 52))
            } else {
                Image("default_user_profile")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 52))
            }
        }
    }
    
    func containsSpecialCharacters(text: String) -> Bool {
        let range = NSRange(location: 0, length: text.utf16.count)
        let regex = try! NSRegularExpression(pattern: "[^A-Za-z0-9가-힣]")
        return regex.firstMatch(in: text, options: [], range: range) != nil
    }
    
    func errorText() -> String {
        if containsSpecialCharacters(text: nickname) {
            return "사용할 수 없는 문자가 포함되어 있어요"
        }
        
        if nickname.count > 8 {
            return "닉네임은 8자 이내로 설정할 수 있어요"
        }
        return ""
    }
}


#Preview {
    JoinPage(loginSuccess: .constant(false))
}
