//
//  ContentView.swift
//  PokedexApp
//
//  Created by Javier Alejandro Lopez Ramirez on 14/6/24.
//

import SwiftUI
import CoreData
import BackgroundTasks
import UserNotifications

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var pokeViewModel : HomeViewModel
    @State var cantidadPokemon = 5
    @State var refreshed = false
    @State var dataOnline = true
    @State private var searchText = ""
    //Obtener datos desde Core Data
    @FetchRequest(entity: Pokemon.entity(), sortDescriptors: [NSSortDescriptor(key: "id", ascending: true)]) var results : FetchedResults<Pokemon>
    
    var body: some View {
        
        //Confirmando si coreData existe.
        NavigationStack {
            VStack{
                if dataOnline{
                    if pokeViewModel.listPokemon.isEmpty{
                        ProgressView()
                            .onAppear{
                                deleteFromCoreData()
                                pokeViewModel.getListPokemon(context: viewContext,cantidad: cantidadPokemon)
                            }//:Onappear
                    } else{
                        List {
                            ForEach(searchResults, id: \.name) {  pokemon in
                                NavigationLink(destination: DetailView(pokemon: pokemon)) {
                                    PokemonRowView(pokemon: pokemon)
                                }
                                
                            }//ForEach
                        }//:List
                        
                    }//:Else
                }
                else{
                    if results.isEmpty{
                        Text("Los datos no se han guardado en la base de Datos")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.horizontal, 30)
                    }else{
                        List {
                            ForEach(results, id: \.name) {  pokemon in
                                NavigationLink(destination: DetailView(fetchedData: pokemon)) {
                                    PokemonRowView(fetchedData: pokemon)
                                }
                            }
                        }//:List
                    }
                }
            }.navigationTitle(dataOnline ? "Pokemon Api" : "Pokemon CoreData" )
                //Toolbar donde se agrega un boton para refrescar los datos.
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            refreshMethod()
                        } label: {
                            Image(systemName: "arrow.clockwise")
                                .font(.title)
                        }
                    }
                    //Este item cambia el origen de los datos, online o core data.
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button{
                            dataOnline.toggle()
                        }label: {
                            Image(systemName: dataOnline ? "externaldrive":"wifi")
                                .font(.title)
                        }
                    }
                }//:Toolbar
                //Alert para detectar un error al momento de traer la data.
                .alert(isPresented: $pokeViewModel.isError, content: {
                    Alert(title: Text("Atencion"), message: Text(pokeViewModel.error))
                })
                //Alert para notificar que se actualizaron los datos manualmente.
                .alert(isPresented: $refreshed, content: {
                    Alert(title: Text("Datos Actualizados"), message: Text("Se ha actualizado la lista de Pokemon"), dismissButton: Alert.Button.default(Text("Aceptar"), action: {
                        refreshed = false
                    }))
                })
                .onAppear{
                    permisos()
                }//:OnAppear
                .searchable(text: $searchText)
                .onChange(of: searchText) { search in
                    if searchText.isEmpty {
                        results.nsPredicate = NSPredicate(value: true)
                    } else {
                        results.nsPredicate = NSPredicate(format: "name CONTAINS[cd] %@", searchText.lowercased())
                    }
                }
        }
    }
    
    func deleteFromCoreData(){
        do{
            results.forEach { (pokemon) in
                viewContext.delete(pokemon)
            }
            
            try viewContext.save()
        }catch{
            print(error.localizedDescription)
        }
    }
    func refreshMethod(){
        deleteFromCoreData()
        cantidadPokemon += 5
        pokeViewModel.listPokemon.removeAll()
        refreshed = true
        
        sendNotification()
    }//RefreshMehod
    //Solicita el permiso al abrir la app para enviar notificaciones
    func requestPermissions(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Todo Listo!")
                scheduleTask()
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }//:RequestPermision
    
    //Comprobar que ya se tienen los permisos de Notificaciones.
    func permisos() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized{
               print("Authorized")
            }else{
                requestPermissions()
            }
        }
    }
    //Metodo para Agendar la backgroundTask una vez se tienen los permisos.
    func scheduleTask() {
        let request = BGAppRefreshTaskRequest(identifier: "Actualiza")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)
            do {
                try BGTaskScheduler.shared.submit(request)
                print("Background Task Scheduled!")
            } catch(let error) {
                print("Scheduling Error \(error.localizedDescription)")
            }
    }//:ScheduleTask
    
    //Metodo que agenda la notificacion y envia la peticion.
    func sendNotification(){
        let content = UNMutableNotificationContent()
        content.title = "Se actualizaron"
        content.subtitle = "Se actualizaron los Pokemon"
        content.sound = UNNotificationSound.default

        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
        
    }

    //Filtra los datos de la lista de la Api
    var searchResults: [PokemonApi] {
           if searchText.isEmpty {
               return pokeViewModel.listPokemon
           } else {
               return pokeViewModel.listPokemon.filter { $0.name.contains(searchText.lowercased()) }
           }
       }
    

    
}

    
