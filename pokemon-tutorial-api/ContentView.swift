//
//  ContentView.swift
//  pokemon-tutorial-api
//
//  Created by Maegan Wilson on 5/3/21.
//

import SwiftUI

struct ContentView: View {
    @State private var pokemonResults: PokeCallResult = PokeCallResult(count: 0, next: nil, previous: nil, results: [])
    
    var body: some View {
        
        List(pokemonResults.results, id: \.name){ result in
            Text("Pokemon: \(result.name)")
        }.onAppear{
            PokeAPIService.shared.fetchPokes(from: .pokemon){ (result: Result<PokeCallResult, PokeAPIService.PokeApiServiceError>) in
                
                switch result {
                case .success(let results):
                    pokemonResults = results
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            }
            
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
