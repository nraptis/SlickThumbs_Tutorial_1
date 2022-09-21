//
//  MyPageViewModel.swift
//  SlickThumbs
//
//  Created by Nick Raptis on 9/20/22.
//

import SwiftUI

class MyPageViewModel: ObservableObject {
    
    static func mock() -> MyPageViewModel {
        return MyPageViewModel()
    }
    
    let layout = GridLayout()
    private let model = MyPageModel()
    
    
    func numberOfThumbCells() -> Int {
        return 118
    }
    
}
