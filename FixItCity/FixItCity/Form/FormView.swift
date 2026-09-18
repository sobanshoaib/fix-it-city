//
//  FormView.swift
//  FixItCity
//
//  Created by Soban Shoaib on 2026-09-15.
//



//name, email, phone, location, additional comments. click submit

import SwiftUI

struct FormView: View {
    @State private var formVM: FormViewModel
    
    @State private var userName = ""
    @State private var userEmail = ""
    @State private var userPhone = ""
    
    init(photo: CapturedPhoto) {
        _formVM = State(initialValue: FormViewModel(photo: photo))
    }
    var body: some View {
        TextField("Name", text: $userName)
        TextField("Email", text: $userEmail)
        TextField("Phone", text: $userPhone)
        Text(formVM.photo.location?.address ?? "No address yet")
        
        Button("Submit") {
            //
        }
    }
}

#Preview {
    if let cgImage = UIImage(systemName: "photo")?.cgImage {
        PhotoDetailView(photo: CapturedPhoto(capturedPhoto: cgImage, location: nil))
    }
}

