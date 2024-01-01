import Foundation
import SwiftUI

struct SinglePageView: View {
    var orderedImages: () -> [UIImage]
    var navigateToNextPage: () -> Void

    @State private var currentPage = 0
    @State private var isZoomed = false
    @State private var currentScale: CGFloat = 1.0
    @State private var currentOffset: CGSize = .zero
    @GestureState private var dragState = DragState.inactive
    private var images: [UIImage] { orderedImages() }

    var body: some View {
        ZStack(alignment: .center) {
            VStack {
                // Page Indicator
                if !images.isEmpty && !isZoomed {
                    Text("Page \(currentPage + 1) of \(images.count + 1)")
                        .font(.headline)
                        .padding(.top)
                }

                // Manga Pages
                if !images.isEmpty {
                    TabView(selection: $currentPage) {
                        ForEach(0...(images.count), id: \.self) { index in
                            if index < images.count {
                                Image(uiImage: images[index])
                                    .resizable()
                                    .scaledToFit()
                                    .onTapGesture {
                                        self.isZoomed = true
                                    }
                                    .tag(index)
                            } else {
                                // Final Page
                                Button("Go to Next Chapter", action: navigateToNextPage)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(RadialGradient(
                                        gradient: Gradient(colors: [.purple, .black]),
                                        center: .trailing,
                                        startRadius: 0,
                                        endRadius: 500
                                    ))
                                    .foregroundColor(.white)
                                    .font(.headline)
                                    .tag(index)
                            }
                        }
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .navigationBarHidden(isZoomed)
                }
            }

            if isZoomed {
                // Overlay Zoom View
                GeometryReader { geometry in
                    Image(uiImage: images[currentPage])
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(currentScale)
                        .offset(x: currentOffset.width + dragState.translation.width, y: currentOffset.height + dragState.translation.height)
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    currentScale = value
                                }
                        )
                        .simultaneousGesture(
                            DragGesture()
                                .updating($dragState, body: { (value, state, _) in
                                    state = .dragging(translation: value.translation)
                                })
                                .onEnded { value in
                                    currentOffset = CGSize(
                                        width: currentOffset.width + value.translation.width,
                                        height: currentOffset.height + value.translation.height
                                    )
                                }
                        )
                        .onTapGesture {
                            withAnimation {
                                self.isZoomed = false
                                self.currentScale = 1.0
                                self.currentOffset = .zero
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                }
                .background(Color.black.edgesIgnoringSafeArea(.all))
            }
        }
    }

    // Extension to hide TabBar (assuming you have a TabBar in your SwiftUI application)
    func tabBarHidden(_ hidden: Bool) -> some View {
        self.onAppear {
            UITabBar.appearance().isHidden = hidden
        }
    }

    enum DragState {
        case inactive
        case dragging(translation: CGSize)

        var translation: CGSize {
            switch self {
                case .inactive:
                    return .zero
                case .dragging(let translation):
                    return translation
            }
        }

        var isActive: Bool {
            switch self {
                case .inactive:
                    return false
                case .dragging:
                    return true
            }
        }
    }
}
