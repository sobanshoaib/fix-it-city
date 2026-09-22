//
//  FormView.swift
//  FixItCity
//
//  Created by Soban Shoaib on 2026-09-15.
//



//name, email, phone, location, additional comments. click submit

import SwiftUI

struct FormView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var formVM: FormViewModel
    
    @State private var userName = ""
    @State private var userEmail = ""
    @State private var userPhone = ""
    @State private var didSubmit = false

    init(photo: CapturedPhoto) {
        _formVM = State(initialValue: FormViewModel(photo: photo))
    }
    var body: some View {
        TextField("Name", text: $userName)
        TextField("Email", text: $userEmail)
        TextField("Phone", text: $userPhone)
        Text(formVM.photo.location?.address ?? "No address yet")
        Text(formVM.photo.location?.city ?? "No city yet")
        if let city = formVM.photo.location?.city {
            if let email = cityEmails[city] {
                Text(email)
            } else {
                Text("Not found")
            }
        }
        
        Button("Submit") {
            if formVM.submitReport(context: viewContext, name: userName, email: userEmail, phone: userPhone) {
                didSubmit = true
            }
        }
        .navigationDestination(isPresented: $didSubmit) {
            ReportListView()
        }
    }
}

#Preview {
    if let cgImage = UIImage(systemName: "photo")?.cgImage {
        PhotoDetailView(photo: CapturedPhoto(capturedPhoto: cgImage, location: nil))
    }
}

