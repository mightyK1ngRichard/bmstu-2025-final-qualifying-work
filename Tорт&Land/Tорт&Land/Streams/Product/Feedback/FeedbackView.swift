//
//  FeedbackView.swift
//  Tорт&Land
//
//  Created by Dmitriy Permyakov on 24.12.2024.
//  Copyright © 2024 https://github.com/mightyK1ngRichard. All rights reserved.
//

import SwiftUI

struct FeedbackView: View {
    @State var viewModel: FeedbackDisplayLogic & FeedbackViewModelOutput

    var body: some View {
        mainContainer
    }
}

#Preview {
    FeedbackView(viewModel: FeedbackViewModelMock())
}
