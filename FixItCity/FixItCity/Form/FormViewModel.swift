//
//  FormViewModel.swift
//  FixItCity
//
//  Created by Soban Shoaib on 2026-09-17.
//

import Foundation
import CoreData
import UIKit

@Observable
class FormViewModel {
    var photo: CapturedPhoto
    var name: String = ""
    var date: Date = Date()
    
    init(photo: CapturedPhoto) {
        self.photo = photo
    }
    
    func submitReport(context: NSManagedObjectContext, name: String, email: String, phone: String, details: String) async -> Bool {
        let report = Report(context: context)
        report.id = UUID()
        report.name = name
        report.email = email
        report.phone = phone
        report.address = photo.location?.address
        report.city = photo.location?.city
        report.details = details
        report.dateSubmitted = Date()
        
        let key = "\(report.id!.uuidString).jpg"
        let uiImage = UIImage(cgImage: photo.capturedPhoto)
        if let imageData = uiImage.jpegData(compressionQuality: 0.8) {
            do {
                try await S3Service.uploadPhoto(data: imageData, key: key)
                report.photoKey = key
            } catch {
                print("Photo upload failed: \(error)")
            }
        }
        
        do {
            try context.save()
            return true
        } catch {
            print("Failed to save report: \(error)")
            return false
        }
    }
    
    
}
