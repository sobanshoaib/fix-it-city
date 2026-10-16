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
    @Environment(\.dismiss) private var dismiss
    @State private var formVM: FormViewModel
    
    @State private var userName = ""
    @State private var userEmail = ""
    @State private var userPhone = ""
    @State private var details = ""
    @State private var didSubmit = false
    
    private var canSubmit: Bool {
           [userName, userEmail, userPhone, details]
               .allSatisfy { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
}
    
    init(photo: CapturedPhoto) {
        _formVM = State(initialValue: FormViewModel(photo: photo))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                HStack(spacing: 12) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(Color.formInk)
                            .frame(width: 44, height: 44)
                            .background(.white, in: Circle())
                            .shadow(color: .black.opacity(0.08), radius: 6, y: 2)
                    }
                    
                    VStack(alignment: .leading, spacing: 3) {
                        Text("LAST STEP")
                            .font(.system(size: 11, weight: .semibold, design: .monospaced))
                            .tracking(1.5)
                            .foregroundStyle(Color.formRedText)
                        Text("Report it")
                            .font(.system(size: 26, weight: .heavy).width(.expanded))
                            .foregroundStyle(Color.formInk)
                    }
                }
                
                Image(decorative: formVM.photo.capturedPhoto, scale: 1, orientation: .right)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 190)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .shadow(color: .black.opacity(0.12), radius: 15, y: 12)
                
                VStack(spacing: 16) {
                    FormField(label: "Name", placeholder: "Your full name", text: $userName)
                        .textContentType(.name)
                    
                    FormField(label: "Email", placeholder: "you@example.com", text: $userEmail)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    
                    FormField(label: "Phone", placeholder: "(000) 000-0000", text: $userPhone)
                        .textContentType(.telephoneNumber)
                        .keyboardType(.phonePad)
                    
                    GeneratedField(label: "Address", field: formVM.photo.location?.address ?? "No address yet")
                    
                    GeneratedField(label: "City", field: formVM.photo.location?.city ?? "No city yet")
                    
                    if let city = formVM.photo.location?.city {
                        if let email = cityEmails[city] {
                            GeneratedField(label: "City Email", field: email)
                        } else {
                            GeneratedField(label: "City Email", field: "Not found")
                        }
                    }
                    
                    FormField(label: "What's wrong?", placeholder: "Describe the problem", text: $details, multiline: true)
                }
            
            Button {
                if formVM.submitReport(context: viewContext, name: userName, email: userEmail, phone: userPhone, details: details) {
                    didSubmit = true
                }
            } label: {
                HStack(spacing: 10) {
                Text("Send report")
                Image(systemName: "arrow.right")
            }
            .font(.system(size: 17, weight: .heavy))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 58)
            .background(Color.fixRed, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: Color.fixRed.opacity(canSubmit ? 0.32 : 0), radius: 14, y: 12)
            .opacity(canSubmit ? 1 : 0.4)
        }
        .disabled(!canSubmit)
        .padding(.top, 4)
    }
    .padding(.horizontal, 20)
    .padding(.top, 8)
    .padding(.bottom, 24)
    }
    .scrollDismissesKeyboard(.interactively)
    .background(Color.formBg.ignoresSafeArea())
    .navigationBarBackButtonHidden(true)
    .navigationDestination(isPresented: $didSubmit) {
        ReportListView()
                    
    }
}
}


struct FormField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var multiline = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(label)
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(Color.formInk)
            
            Group {
                if multiline {
                    TextField(placeholder, text: $text, axis: .vertical)
                        .lineLimit(4...6)
                        .padding(.vertical, 14)
                } else {
                    TextField(placeholder, text: $text)
                        .frame(height: 52)
                }
            }
            .font(.system(size: 16))
            .foregroundStyle(Color.formInk)
            .padding(.horizontal, 16)
            .background(.white, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous)
            .stroke(Color.formBorder, lineWidth: 1.5))
        }
    }
}

struct GeneratedField: View {
    let label: String
    let field: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(label)
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(Color.formInk)
            
            Text(field)
            .font(.system(size: 16))
            .foregroundStyle(Color.formInk)
            .frame(maxWidth: .infinity, minHeight: 52, alignment: .leading)
            .padding(.horizontal, 16)
            .background(.white, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous)
            .stroke(Color.formBorder, lineWidth: 1.5))
        }
    }
}


extension Color {
    static let formBg = Color(red: 255/255, green: 248/255, blue: 245/255)
    static let formInk = Color(red: 22/255, green: 9/255, blue: 10/255)
    static let formBorder = Color(red: 234/255, green: 218/255, blue: 213/255)
    static let formRedText = Color(red: 194/255, green: 15/255, blue: 24/255)   
}

#Preview {
    if let cgImage = UIImage(systemName: "photo")?.cgImage {
        NavigationStack {
            FormView(photo: CapturedPhoto(capturedPhoto: cgImage, location: nil))
        }
    }
}

