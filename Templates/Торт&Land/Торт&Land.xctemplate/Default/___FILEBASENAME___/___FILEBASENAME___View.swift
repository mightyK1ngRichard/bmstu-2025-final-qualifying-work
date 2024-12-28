//
//  ___VARIABLE_productName:identifier___View.swift
//  Tорт&Land
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright © ___YEAR___ https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI

struct ___VARIABLE_productName:identifier___View: View {
    @State var viewModel: ___VARIABLE_productName:identifier___DisplayLogic & ___VARIABLE_productName:identifier___ViewModelOutput
//    @Environment(Coordinator.self) private var coordinator

    var body: some View {
        mainContainer.onFirstAppear {
            viewModel.setEnvironmentObjects(<#coordinator: coordinator#>)
        }
    }
}

// MARK: - Preview

#Preview {
    ___VARIABLE_productName:identifier___View(
        viewModel: ___VARIABLE_productName:identifier___ViewModelMock()
    )
    .environment(<#Coordinator()#>)
}
