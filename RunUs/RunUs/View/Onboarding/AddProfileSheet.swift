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
    @State var selectedProfile: [PhotosPickerItem] = []
    @Binding var selectedImages: [UIImage]
    @Binding var isPresentedError: Bool
    private let maxSelectedCount: Int = 1
    private var availableSelectedCount: Int {
        maxSelectedCount - selectedImages.count
    }

    var body: some View {
        GeometryReader { _ in
            
            VStack(alignment: .leading, spacing: 34) {
                Text("프로필 사진 추가")
                    .font(.title5_bold)
                    .foregroundColor(.primaryGray)
                    .padding(.top, 16)
                
                PhotosPicker(selection: $selectedProfile, maxSelectionCount: availableSelectedCount, matching: .images) {
                    HStack {
                        Image("imageIcon")
                        Text("갤러리에서 추가하기")
                            .font(.body2_medium)
                            .foregroundColor(.secondaryGray)
                    }
                }
                .onChange(of: selectedProfile) { _, newValue in
                    handleSelectedPhotos(newValue)
                }
                
                Button {
                    selectedImages.removeAll()
                    selectedProfile.removeAll()
                    dismiss()
                } label: {
                    HStack {
                        Image("trash")
                        Text("사진 삭제하기")
                            .font(.body2_medium)
                            .foregroundColor(.error)
                    }
                }
            }
            .padding()
            
        }
        .onTapGesture {
            dismiss()
        }
    }
    
    func handleSelectedPhotos(_ newPhotos: [PhotosPickerItem]) {
        for newPhoto in newPhotos {
            newPhoto.loadTransferable(type: Data.self) { result in
                switch result {
                case .success(let data):
                    if let data = data, let newImage = UIImage(data: data) {
                        if !selectedImages.contains(where: { $0.pngData() == newImage.pngData() }) {
                            selectedImages.removeAll()
                            selectedProfile.removeAll()
                            DispatchQueue.main.async {
                                selectedImages.append(newImage)
                                dismiss()
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
