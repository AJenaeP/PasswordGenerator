//
//  ContentView.swift
//  PasswordGenerator
//
//  Created by A'Jenae Pompey on 9/18/23.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @State private var includeNumbers = true
    @State private var includeSpecialCharacters = true
    @State private var password = ""
    @State private var numberOfCharacters = 8.0
    @State private var isEditing = false
    @State private var hiddenPass = true;
    @State private var copied = false;
    private let pasteboard = UIPasteboard.general
    @FocusState var inFocus: Field?

    
    enum Field {
        case secure, plain
    }
    
    //custom Switch toggle style that changes color
    struct ColoredToggleStyle: ToggleStyle {
        var label = ""
        var onColor = Color(.systemBlue)
        var offColor = Color(.systemRed)
        var thumbColor = Color.white
        
        func makeBody(configuration: Self.Configuration) -> some View {
            HStack {
                Text(label)
                    .font(.system(size: 20, weight: .medium))
                Spacer()
                Button(action: { configuration.isOn.toggle() } )
                {
                    RoundedRectangle(cornerRadius: 16, style: .circular)
                        .fill(configuration.isOn ? onColor : offColor)
                        .frame(width: 50, height: 29)
                        .overlay(
                            Circle()
                                .fill(thumbColor)
                                .shadow(radius: 1, x: 0, y: 1)
                                .padding(1.5)
                                .offset(x: configuration.isOn ? 10 : -10))
                }
            }
            .font(.title)
        }
    }
    
    //used to generate the password
    func generatePassword(){
        password = ""
        var counter = 0
        let letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
        let numbers = ["1","2","3","4","5","6","7","8","9","0"]
        let specialCharacters = ["!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "+", "-", ".", "<", ">", "=", "_"]
        var combination = [String]()
        
        //creates password based on selected conditions
        if(includeNumbers && !includeSpecialCharacters){
            combination = letters + numbers
        } else if(!includeNumbers && includeSpecialCharacters){
            combination = letters + specialCharacters
        } else if(includeNumbers && includeSpecialCharacters){
            combination = letters + numbers + specialCharacters
        } else {
            combination = letters
        }

        while counter < Int(numberOfCharacters) {
            password.append(combination.randomElement()!)
            counter += 1
        }
    }
    
    //copies passowrd if password field is not empty
    func copyPass() {
        if(password != ""){
            pasteboard.string = password;
            copied = true;
            
            //assist in changing image contition after specified time frame
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.copied = false
            }
        }
    }
    
    //hides or shows password
    func hidePass() {
        hiddenPass = !hiddenPass
    }
    
    var body: some View {
        VStack() { //vertical stack of app
            //logo
            Image("pglogo2")
                .opacity(0.5)
                .frame(alignment: .top)
                .padding(50)
            
            Toggle(isOn: $includeNumbers){} //custom toggle for includes number
                .toggleStyle(ColoredToggleStyle(
                    label: "Include Numbers"
                ))
                .padding(20)
        
            Toggle(isOn: $includeSpecialCharacters){} //custom toggle for include special charac.
                .toggleStyle(ColoredToggleStyle(
                    label: "Include Special Characters"
                ))
                .padding(20)
            
            Slider( //slider for user to choose passwrod length
                value: $numberOfCharacters,
                in: 8...16,
                step: 1
            )
                .padding([.top], 20)
                .padding([.bottom],5)
            
            Text("\(Int(numberOfCharacters))") //visual text of slider
                .foregroundColor(isEditing ? .red : .blue)
                .padding(10)
                .font(.system(size: 25))
            
            Button("Generate Password", action: generatePassword) //runs generate password function
                .padding(10)
                .padding([.bottom],25)
                .font(.system(size: 25))
            
            HStack { //horizontal stack of password line
                if (!hiddenPass) {
                    TextField("Password", text: $password).disabled(true)
                        .font(.system(size: 25))
                        .focused($inFocus, equals: .plain)
                } else {
                    SecureField("Password", text: $password)
                        .font(.system(size: 25))
                        .focused($inFocus, equals: .secure)
                }

                Button { //button with image to hide or show password
                    hidePass()
                } label: {
                    Image(systemName: hiddenPass ? "eye.slash" : "eye")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 37, height: 37)
                }
                
                Button { // button with image for copy, if copy successful 'checkmark' is shown for a few seconds
                    copyPass()
                } label: {
                    if copied {
                        Image(systemName: "checkmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35, height: 25)
                    } else {
                        Image(systemName: "doc.on.doc")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35, height: 35)
                    }
                }
            }
        }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding()
    }
}
   
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
