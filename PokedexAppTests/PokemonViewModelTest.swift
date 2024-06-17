//
//  PokemonViewModelTest.swift
//  PokedexAppTests
//
//  Created by Javier Alejandro Lopez Ramirez on 14/6/24.
//

import XCTest
@testable import PokedexApp
import CoreData

class PokemonViewModelTests: XCTestCase{
    var pokemonviewModel: HomeViewModel!
    lazy var persistentContainer: NSPersistentContainer = {
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        let container = NSPersistentContainer(name: "PokedexApp")
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            if let error = error as NSError?{
                fatalError("Error \(error)")
            }
        }
        return container
    }()
    
    override func setUp() {
        super.setUp()
        pokemonviewModel = HomeViewModel()
    }
    
    
    func testGetDataFromAPI(){
        //Creamos los datos de prueba.
        let pokemonData = [
            PokemonApi(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/", imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png"),
            PokemonApi(name: "charmander", url: "https://pokeapi.co/api/v2/pokemon/4/", imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/4.png")
                        
        ]
        
        //Se agregan los datos de prueba al viewmodel.
        pokemonviewModel.listPokemon = pokemonData
        
        //Guardar los datos en CoreData.
        let context = persistentContainer.viewContext
        pokemonviewModel.saveData(context: context)
        
        //Realiza una consulta para verificar si se guardo correctamente.
        let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        
        do{
            //obtenemos los datos y los guardamos en pokemonList
            let pokemonList = try context.fetch(fetchRequest)
            
            //Se compara el numero de pokemon guardados.
            XCTAssertEqual(pokemonList.count, pokemonData.count)
            
            //Compara los nombres y la url de las imagenes
            for(index, pokemon) in pokemonList.enumerated(){
                XCTAssertEqual(pokemon.name, pokemonData[index].name)
                XCTAssertEqual(pokemon.url, pokemonData[index].url)
                XCTAssertEqual(pokemon.imageUrl, pokemonData[index].imageUrl)
            }
            
        }catch{
            XCTFail("Error al obtener los datos de Core Data: \(error.localizedDescription)")
        }
        
    }
    
}
