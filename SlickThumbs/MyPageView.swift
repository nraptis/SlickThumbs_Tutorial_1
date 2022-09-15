//
//  MyPageView.swift
//  SlickThumbs
//
//  Created by Nick Raptis on 9/15/22.
//

import SwiftUI

struct MyPageView: View {
    
    @ObservedObject var viewModel: MyPageViewModel
    var body: some View {
        GeometryReader { containerGeometry in
            list(containerGeometry)
        }
    }
    
    func grid() -> some View {
        
        let visibleCells = viewModel.layout.getAllVisibleCellModels()
        
        return ThumbGrid(items: visibleCells, layout: viewModel.layout) { cellModel in
            ZStack {
                Text("\(cellModel.index)")
                    .foregroundColor(.black)
                    .font(.system(size: 44))
            }
            .frame(width: viewModel.layout.getWidth(cellModel.index),
                   height: viewModel.layout.getHeight(cellModel.index))
            .background(RoundedRectangle(cornerRadius: 12).fill().foregroundColor(.orange))
        }
    }
    
    func list(_ containerGeometry: GeometryProxy) -> some View {
        
        viewModel.layout.registerList(containerGeometry, numberOfThumbCells())
        
        
        return List {
            GeometryReader { scrollContentGeometry in
                grid()
            }
            .frame(width: viewModel.layout.width,
                   height: viewModel.layout.height)
            .listRowInsets(EdgeInsets())
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
    
    func numberOfThumbCells() -> Int {
        return 118
    }
    
}

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView(viewModel: MyPageViewModel.mock())
    }
}
