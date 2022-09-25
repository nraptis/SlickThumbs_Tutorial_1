//
//  MyPageViewModel.swift
//  SlickThumbnail
//
//  Created by Nick Raptis on 9/23/22.
//

import SwiftUI

class MyPageViewModel: ObservableObject {
    
    static func mock() -> MyPageViewModel {
        return MyPageViewModel()
    }
    
    private let model = MyPageModel()
    let layout = GridLayout()
    
    func numberOfThumbCells() -> Int {
        return model.totalExpectedCount
    }
    
}
