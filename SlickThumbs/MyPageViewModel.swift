//
//  MyPageViewModel.swift
//  SlickThumbs
//
//  Created by Nick Raptis on 9/15/22.
//

import SwiftUI

class MyPageViewModel: ObservableObject {
    
    static func mock() -> MyPageViewModel {
        return MyPageViewModel()
    }
    
    let layout = GridLayout()
    let model = MyPageModel()
    
}
