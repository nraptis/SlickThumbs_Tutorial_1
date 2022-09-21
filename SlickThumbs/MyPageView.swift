//
//  MyPageView.swift
//  SlickThumbs
//
//  Created by Nick Raptis on 9/20/22.
//

import SwiftUI

struct MyPageView: View {
    @ObservedObject var viewModel: MyPageViewModel
    var body: some View {
        GeometryReader { containerGeometry in
            list(containerGeometry)
        }
    }
    
    private func grid(_ containerGeometry: GeometryProxy, _ scrollContentGeometry: GeometryProxy) -> some View {
        
        let layout = viewModel.layout
        let visibleCells = layout.getAllVisibleCellModels()
        
        return ThumbGrid(items: visibleCells, layout: layout) { item in
            ZStack {
                Text("\(item.index)")
                    .foregroundColor(.black)
                    .font(.system(size: 44))
            }
            .frame(width: layout.getWidth(item.index),
                   height: layout.getHeight(item.index))
            .background(RoundedRectangle(cornerRadius: 12).fill().foregroundColor(.orange))
        }
    }
    
    private func list(_ containerGeometry: GeometryProxy) -> some View {
        let layout = viewModel.layout
        layout.registerContainer(containerGeometry, viewModel.numberOfThumbCells())
        return List {
            GeometryReader { scrollContentGeometry in
                grid(containerGeometry, scrollContentGeometry)
            }
            .frame(width: layout.width,
                   height: layout.height)
            .listRowInsets(EdgeInsets())
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
    
}

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView(viewModel: MyPageViewModel.mock())
    }
}
