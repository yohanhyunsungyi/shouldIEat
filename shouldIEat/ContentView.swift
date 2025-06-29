//
//  ContentView.swift
//  shouldIEat
//
//  Created by Yohan Yi on 6/17/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ServiceIntroViewModel()
    
    var body: some View {
        SplashView(viewModel: viewModel)
    }
}

#Preview {
    ContentView()
}
