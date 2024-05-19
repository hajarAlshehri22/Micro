//
//  ViewModel.swift
//  Micro
//
//  Created by Hajar Alshehri on 07/11/1445 AH.
//

import SwiftUI

final class ViewModel: ObservableObject{
    @Published var jamaah : [Jamaah] = []
    @Published var shouldShowTabView: Bool = true
    
}

final class PeopleViewModel: ObservableObject {
    @Published var peopleInfo: [peopleInfo] = []
}

