//
//  CakeStatusChartView.swift
//  CakeLandAdmin
//
//  Created by Dmitriy Permyakov on 15.05.2025.
//

import SwiftUI
import Charts

struct CakeStatusChartView: View {
    let data: [CakeStatus: Int]

    var body: some View {
        Chart {
            ForEach(CakeStatus.allCases, id: \.self) { status in
                let count = data[status] ?? 0
                if count > 0 {
                    BarMark(
                        x: .value("Количество", count),
                        y: .value("Статус", status.title)
                    )
                    .foregroundStyle(status.textColor)
                    .annotation(position: .overlay) {
                        Text("\(count)")
                            .font(.caption)
                    }
                }
            }
        }
        .chartLegend(.visible)
        .frame(height: 180)
        .padding()
    }
}

#Preview {
    CakeStatusChartView(data: [
        .approved: 10,
        .hidden: 20,
        .pending: 3,
        .rejected: 4
    ])
}
