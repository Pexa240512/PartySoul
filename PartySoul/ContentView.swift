//
//  ContentView.swift
//  PartySoul
//
//  Created by Jorge Mayta Guillermo on 6/13/20.
//  Copyright © 2020 Cibertec. All rights reserved.
//

import SwiftUI

// Paso 1: Generar objetos de la clase URL
//let urlStringGeekJoke = "https://geek-jokes.sameerkumar.website/api"
let urlStringGeekJoke = "https://geek-jokes.sameerkumar.website/api?format=json"
let urlGeekJoke = URL(string: urlStringGeekJoke)!

let urlStringDadJoke = "https://icanhazdadjoke.com/"
let urlDadJoke = URL(string: urlStringDadJoke)!

// Paso 2: Establecer una sesión utilizando el patrón Singleton
let session = URLSession.shared

// Paso 3: Crear un struct que soporte la respuesta
struct Joke: Decodable {
    var joke: String
}

//Paso 4: Crear un ObservableObject
class JokeViewModel: ObservableObject{
    
    // Paso 4.1: Crear atributos con la @Published para indicar que sus cambios se actualizan en la vista
    @Published var joke = Joke(joke: "")
    
    // Paso 4.2: Crear el método para consumir el endpoint https://geek-jokes.sameerkumar.website/api
    func getGeekJoke() {
        
        // Paso 4.2.1: Traer la data en un tarea asincrónica
        session.dataTask(with: urlGeekJoke){
            (data, response, error) in
            DispatchQueue.main.async {
                //self.joke = Joke(joke: String(decoding: data!, as: UTF8.self))
                self.joke = try! JSONDecoder().decode(Joke.self, from: data!)
            }
            
        }.resume()
    }
    
    // Paso 4.3: Crear el método para consumir el endpoint https://icanhazdadjoke.com/
    func getDadJoke(){
        
        // Paso 4.3.1: Crear un URL para ingresar un valor en Accept
        var request = URLRequest(url: urlDadJoke)
        //request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("text/plain", forHTTPHeaderField: "Accept")
        
        session.dataTask(with: request){
            (data, response, error) in
            DispatchQueue.main.async {
                //self.joke = try! JSONDecoder().decode(Joke.self, from: data!)
                self.joke = Joke(joke: String(decoding: data!, as: UTF8.self))

            }
        }.resume()
        
        
    }
}



struct ContentView: View {
    
    @ObservedObject var jokeVM = JokeViewModel()
    
    var body: some View {
        NavigationView{
            Text(jokeVM.joke.joke)
            .navigationBarTitle("Jokes")
            .navigationBarItems(
                leading:
                Button(
                    action: {
                    self.jokeVM.getGeekJoke()
                        
                },
                    label: {Text("Geek Joke")}),
                trailing:
                Button(
                    action: {
                        self.jokeVM.getDadJoke()
                },
                    label: {Text("Dad Joke")})
            )
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
