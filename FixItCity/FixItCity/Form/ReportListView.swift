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
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("My reports")
                        .font(.system(size: 32, weight: .heavy).width(.expanded))
                        .foregroundStyle(Color.formInk)
                    Text("\(reports.count) \(reports.count == 1 ? "report" : "reports")")
                        .font(.system(size: 15))
                        .foregroundStyle(Color.reportsMuted)
                }
                
                if reports.isEmpty {
                    emptyState
                } else {
                    LazyVStack(spacing: 12) {
                        ForEach(reports) { report in
                            ReportRow(report: report)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 24)
        }
        .background(Color.formBg.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
    }
    
    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "camera")
                .font(.system(size: 30, weight: .medium))
                .foregroundStyle(Color.fixRed)
                .frame(width: 72, height: 72)
                .background(Color.fixRed.opacity(0.1), in: Circle())
            Text("No reports yet")
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(Color.formInk)
            Text("Snap a problem and it will show up here.")
                .font(.system(size: 15))
                .foregroundStyle(Color.reportsMuted)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 80)
    }
}

struct ReportRow: View {
    @ObservedObject var report: Report
    
    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: "mappin.and.ellipse")
                .font(.system(size: 22, weight: .medium))
                .foregroundStyle(Color.fixRed)
                .frame(width: 52, height: 52)
                .background(Color.fixRed.opacity(0.1),
                            in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(report.address ?? "Unknown location")
                    .font(.system(size: 16, weight: .heavy))
                    .foregroundStyle(Color.formInk)
                    .lineLimit(2)
                Text(report.name ?? "Unknown")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.reportsMuted)
                Text(report.email ?? "Unknown")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.reportsMuted)
                    .lineLimit(1)
            }
            
            Spacer(minLength: 0)
            
            Text(dateText)
                .font(.system(size: 12, weight: .semibold, design: .monospaced))
                .foregroundStyle(Color.reportsMuted)
        }
        .padding(12)
        .background(.white, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.formInk.opacity(0.05), radius: 1, y: 1)
    }
    
    private var dateText: String {
        guard let date = report.dateSubmitted else { return "" }
        return Calendar.current.isDateInToday(date) ? "Today" : date.formatted(.dateTime.month(.abbreviated).day())
    }
}

extension Color {
    static let reportsMuted = Color(red: 110/255, green: 86/255, blue: 84/255)  // #6E5654
}

    
#Preview {
    ReportListView()
}
