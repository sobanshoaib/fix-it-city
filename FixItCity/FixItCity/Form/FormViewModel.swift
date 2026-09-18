//
//  FormViewModel.swift
//  FixItCity
//
//  Created by Soban Shoaib on 2026-09-17.
//

import Foundation


@Observable
class FormViewModel {
    var photo: CapturedPhoto
    var name: String = ""
    var date: Date = Date()
    
    init(photo: CapturedPhoto) {
        self.photo = photo
    }
    
    
}
