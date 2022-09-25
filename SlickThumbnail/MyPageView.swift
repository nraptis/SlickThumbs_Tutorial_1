//
//  MyPageView.swift
//  SlickThumbnail
//
//  Created by Nick Raptis on 9/23/22.
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
        let allVisibleCellModels = layout.getAllVisibleCellModels()
        return ThumbGrid(list: allVisibleCellModels, layout: layout) { cellModel in
            
            ZStack {
                Text("\(cellModel.index)")
                    .foregroundColor(.black)
                    .font(.system(size: 44))
            }
            .frame(width: layout.getWidth(cellModel.index),
                   height: layout.getHeight(cellModel.index))
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
