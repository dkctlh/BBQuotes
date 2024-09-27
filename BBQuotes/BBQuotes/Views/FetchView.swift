//
//  QuoteView.swift
//  BBQuotes
//
//  Created by Talha Dikici on 20.09.2024.
//

import SwiftUI

struct FetchView: View {
    let vm = ViewModel()
    let show: String
    
    @State var showCharaterInfo = false
    @State var showQuote = true
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image(show.removeCaseAndSpace())
                    .resizable()
                    .frame(width: geo.size.width * 2.7, height: geo.size.height * 1.2)
                    .onAppear {
                        Task {
                            await vm.getQuoteData(for: show)
                        }
                    }
                
                VStack {
                    
                    switch  vm.status {
                    case .notStarted:
                        EmptyView()
                    case .fetching:
                        ProgressView()
                    case .successQuote:
                        Text("\" \(vm.quote.quote)\"")
                            .minimumScaleFactor(0.5)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .padding()
                            .background(.black.opacity(0.5))
                            .clipShape(.rect(cornerRadius: 25))
                            .padding(.horizontal)
                            .opacity(showQuote ? 1 : 0)
                        
                        ZStack(alignment: .bottom) {
                            AsyncImage(url: vm.character.images.randomElement()) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: geo.size.width / 1.1, height: geo.size.height / 1.8)
                            
                            Text(vm.character.name)
                                .foregroundStyle(.white)
                                .padding(10)
                                .frame(maxWidth: .infinity)
                                .background(.ultraThinMaterial)
                            
                        }
                        .frame(width: geo.size.width / 1.1, height: geo.size.height / 1.8)
                        .clipShape(.rect(cornerRadius: 50))
                        .onTapGesture {
                            showCharaterInfo.toggle()
                        }
                    case .successEpisode:
                        EpisodeView(episode: vm.episode)
                            .frame(height: geo.size.height * 0.6)
                        
                    case .failed(let error):
                        Text(error.localizedDescription)
                   
                    }
      
                    Spacer()
                        .frame(height: 20)
                    
                    HStack {
                        Button {
                            Task {
                                await vm.getQuoteData(for: show)
                            }
                            showQuote = true
                        } label: {
                            Text("Get Random Quote")
                                .font(.title3)
                                .foregroundStyle(.white)
                                .padding()
                                .background(Color("\(show.removeSpaces())Button"))
                                .clipShape(.rect(cornerRadius: 7))
                                .shadow(color: Color("\(show.removeSpaces())Shadow"), radius: 2)
                            
                    }
                        
                        Spacer()
                        
                        Button {
                            Task {
                                await vm.getEpisode(for: show)
                            }
                        } label: {
                            Text("Get Random Episode")
                                .font(.title3)
                                .foregroundStyle(.white)
                                .padding()
                                .background(Color("\(show.removeSpaces())Button"))
                                .clipShape(.rect(cornerRadius: 7))
                                .shadow(color: Color("\(show.removeSpaces())Shadow"), radius: 2)
                    }
                    }
                    .padding(.horizontal, 30)
                    
                    Button {
                        Task {
                            await vm.getRandomCharacter(for: show)
                        }
                        showQuote = false
                    } label: {
                        Text("Get Random Character")
                            .font(.title3)
                            .foregroundStyle(.white)
                            .padding()
                            .background(Color("\(show.removeSpaces())Button"))
                            .clipShape(.rect(cornerRadius: 7))
                            .shadow(color: Color("\(show.removeSpaces())Shadow"), radius: 2)
                }
                    
                    Spacer()
                        .frame(height: 30)
                }
                .frame(width: geo.size.width)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea()
        .sheet(isPresented: $showCharaterInfo) {
            CharacterView(character: vm.character, show: show)
            }
        
    }
}

#Preview {
    FetchView(show: "Breaking Bad")
        .preferredColorScheme(.dark)
}
