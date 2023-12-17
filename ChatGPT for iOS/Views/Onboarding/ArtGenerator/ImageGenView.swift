//
//  ImageGenView.swift
//  ChatGPT for iOS
//
//  Created by JAESOON on 12/16/23.
//

import SwiftUI

struct ImageGenView: View {
    @StateObject var vm = ViewModel()
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    if !vm.urls.isEmpty {
                        ViewThatFits {
                            PreviewImage(vm: vm)
                                .padding()
                            ScrollView(.horizontal) {
                                PreviewImage(vm: vm)
                                    .padding()
                            }
                        }
                    }
                    if !vm.fetching {
                        if !vm.urls.isEmpty {
                            Text("Selcet an image")
                        }
                        if let selectedImage = vm.selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 256, height: 256)
                        }
                        if vm.urls.isEmpty {
                            Text("The more descriptive you can be, the better")
                            TextField("Image Description....",
                                      text: $vm.prompt,
                                      axis: .vertical)
                            .showClearButton($vm.prompt)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal)
                            Form {
                                Picker("Style", selection: $vm.imageStyle) {
                                    ForEach(ImageStyle.allCases, id: \.self) { imageStyle in
                                        Text(imageStyle.rawValue)
                                    }
                                }
                                Picker("Image Medium", selection: $vm.imageMedium) {
                                    ForEach(ImageMedium.allCases, id: \.self) { imageMedium in
                                        Text(imageMedium.rawValue)
                                    }
                                }
                                Picker("Artist", selection: $vm.artist) {
                                    ForEach(Artist.allCases, id: \.self) { artist in
                                        Text(artist.rawValue)
                                    }
                                }
                                HStack {
                                    Spacer()
                                    Button("Fetch") {
                                        vm.fetchImages()
                                    }
                                    .disabled(vm.prompt.isEmpty)
                                    .buttonStyle(.borderedProminent)
                                }
                                HStack {
                                    Spacer()
                                    if vm.urls.isEmpty || vm.selectedImage == nil {
                                        Image("Impressionism").resizable()
                                    }
                                    Spacer()
                                }
                            }
                        } else {
                            Text(vm.description)
                                .padding() //
                            HStack {
                                if vm.selectedImage != nil {
                                    Button("Get Variation") {
                                        vm.fetchVariations()
                                    }
                                }
                                Button("Try another") {
                                    vm.reset()
                                }
                            }
                            .buttonStyle(.borderedProminent) //
                        }
                    }
                        else {
                            Spacer()
                            FetchingView()
                            Spacer()
                        }
                        if vm.selectedImage == nil && !vm.urls.isEmpty {
                            Image("Impressionism").resizable()
                        }
                        Spacer()
                    }
                        .navigationTitle("Art Generator")
                        .edgesIgnoringSafeArea(.bottom)
                        .toolbar {
                            if let selectedImage = vm.selectedImage {
                                ToolbarItem {
                                    ShareLink(item: Image(uiImage: selectedImage),
                                              subject: Text("Generated Image"),
                                              message: Text(vm.description),
                                              preview: SharePreview(Text("Generated Image"),
                                                                    image: Image(uiImage: selectedImage)))
                                }
                            }
                        }
                        .alert("Processing Error", isPresented: $vm.showAlert) {
                            Button("OK") {}
                        } message: {
                            Text("Unable to process this request. Your image description cannot be interpreted.")
                        }
                }
            }
        }
    
    
    struct PreviewImage: View {
        @ObservedObject var vm = ViewModel()
        @Environment(\.horizontalSizeClass) var hsc
        var body: some View {
            HStack {
                ForEach(vm.dallEImages) { dalleimage in
                    if let uiImage = dalleimage.uiImage {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width:hsc == .compact ? 80 : 120,       height:hsc == .compact ? 80 : 120)
                            .onTapGesture {
                                vm.selectedImage = uiImage
                            }
                    } //if
                    else {
                        ProgressView()
                            .frame(width: hsc == .compact ? 80 : 120,
                                   height: hsc == .compact ? 80 : 120)
                        
                    }
                }
                
            }
        }
    }
}

    


struct ImageGenView_Previews: PreviewProvider {
    static var previews: some View {
        ImageGenView()
    }
}
