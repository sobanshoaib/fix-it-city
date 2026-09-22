//
//  ReportListView.swift
//  FixItCity
//
//  Created by Soban Shoaib on 2026-09-21.
//

import SwiftUI
import CoreData

struct ReportListView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Report.dateSubmitted, ascending: false)]
    )
    private var reports: FetchedResults<Report>
    
    var body: some View {
        List(reports) {report in
            VStack (alignment: .leading) {
                Text(report.name ?? "unknown")
                Text(report.address ?? "unknown")
                Text(report.email ?? "unknown")
            }
        }
        .navigationTitle("Reports")
    }
}

#Preview {
    ReportListView()
}
