//
//  AddProfileSheet.swift
//  RunUs
//
//  Created by byeoungjik on 10/14/24.
//

import SwiftUI
import PhotosUI

struct AddProfileSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var showAddProfile: Bool
    @State var selectedProfile: [PhotosPickerItem] = []
    @Binding var selectedImages: [UIImage]
    @Binding var isPresentedError: Bool
    private let maxSelectedCount: Int = 1
    private var disabledAddPhotos: Bool {
        selectedImages.count >= maxSelectedCount
    }
    private var availableSelectedCount: Int {
        maxSelectedCount - selectedImages.count
    }
    
    var body: some View {
        GeometryReader { geomtry in
            
            VStack(alignment: .leading, spacing: 34) {
                Text("프로필 사진 추가")
                    .font(.title5_bold)
                    .foregroundColor(.gray900)
                    .padding(.top, 16)
                
                PhotosPicker(selection: $selectedProfile, maxSelectionCount: availableSelectedCount, matching: .images) {
                    HStack {
                        Image("imageIcon")
                        Text("갤러리에서 추가하기")
                            .font(.body2_medium)
                            .foregroundColor(.gray700)
                    }
                }
                .disabled(disabledAddPhotos)
                .onChange(of: selectedProfile) { _, newValue in
                    handleSelectedPhotos(newValue)
                }
            }
            .padding()
            
        }
        .onTapGesture {
            dismiss()
        }
        .onDisappear(perform: {
            print("selectedProfile: \(selectedProfile)")
            showAddProfile = false
        })
    }
    
    func handleSelectedPhotos(_ newPhotos: [PhotosPickerItem]) {
        for newPhoto in newPhotos {
            newPhoto.loadTransferable(type: Data.self) { result in
                switch result {
                case .success(let data):
                    if let data = data, let newImage = UIImage(data: data) {
                        if !selectedImages.contains(where: { $0.pngData() == newImage.pngData() }) {
                            DispatchQueue.main.async {
                                selectedImages.append(newImage)
                            }
                        }
                    }
                case .failure:
                    isPresentedError = true
                }
            }
        }
        
        selectedProfile.removeAll()
    }
}
