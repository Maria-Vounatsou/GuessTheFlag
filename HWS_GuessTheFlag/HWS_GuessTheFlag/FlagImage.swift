//
//  FlagImage.swift
//  HWS_GuessTheFlag
//
//  Created by Maria Vounatsou on 19/4/24.
//

import SwiftUI

struct FlagImage: View {
    let name: String
    
    var body: some View {
        Image(name)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

struct FlagImage_Previews: PreviewProvider {
    static var previews: some View {
        FlagImage(name: "")
    }
}
