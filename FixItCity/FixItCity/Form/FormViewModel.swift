//
//  FormViewModel.swift
//  FixItCity
//
//  Created by Soban Shoaib on 2026-09-17.
//

import Foundation
import CoreData


@Observable
class FormViewModel {
    var photo: CapturedPhoto
    var name: String = ""
    var date: Date = Date()
    
    init(photo: CapturedPhoto) {
        self.photo = photo
    }
    
    func submitReport(context: NSManagedObjectContext, name: String, email: String, phone: String) -> Bool {
        let report = Report(context: context)
        report.name = name
        report.email = email
        report.phone = phone
        report.address = photo.location?.address
        report.city = photo.location?.city
        report.dateSubmitted = Date()

        do {
            try context.save()
            return true
        } catch {
            print("Failed to save report: \(error)")
            return false
        }
    }
    
    
}
