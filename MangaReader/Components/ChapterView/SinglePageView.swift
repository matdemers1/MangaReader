import Foundation
import SwiftUI

struct SinglePageView: View {
    var orderedImages: () -> [UIImage]
    var navigateToNextPage: () -> Void
    var isIpad: Bool

  @Binding var currentPage: Int
    @State private var isZoomed = false
    @State private var startingScale: CGFloat = 1.0
    @State private var currentScale: CGFloat = 1.0
    @State private var currentOffset: CGSize = .zero
    @GestureState private var dragState = DragState.inactive
    private var images: [UIImage] { orderedImages() }

    var body: some View {
        ZStack(alignment: .center) {
            // Manga Pages
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
                .navigationBarHidden(isZoomed || isIpad)

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
                                    // Apply the gesture scale to the starting scale
                                    let newScale = startingScale * value
                                    self.currentScale = max(1.0, newScale)
                                }
                                .onEnded { _ in
                                    // Store the ending scale
                                    self.startingScale = self.currentScale
                                }
                        )
                        .simultaneousGesture(
                            DragGesture()
                                .updating($dragState, body: { (value, state, _) in
                                    state = .dragging(translation: value.translation)
                                })
                                .onEnded { value in
                                    self.currentOffset = self.adjustOffset(newOffset: CGSize(
                                        width: currentOffset.width + value.translation.width,
                                        height: currentOffset.height + value.translation.height
                                    ), geometry: geometry.size)
                                }
                        )
                        .simultaneousGesture(
                            TapGesture()
                                .onEnded {
                                    withAnimation {
                                        self.isZoomed = false
                                        self.currentScale = 1.0
                                        self.currentOffset = .zero
                                        self.startingScale = 1.0
                                    }
                                }
                        )
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)

                    // Close Button
                    Button(action: {
                        withAnimation {
                            self.isZoomed = false
                            self.currentScale = 1.0
                            self.currentOffset = .zero
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    }
                        .padding(.top, 44)
                        .padding(.leading, 20)
                        .position(x: 30, y: 30) // Adjust position as needed
                }
                    .background(Color.black.edgesIgnoringSafeArea(.all))
            }
        }
    }

    private func adjustOffset(newOffset: CGSize, geometry: CGSize) -> CGSize {
        let imageSize = CGSize(width: geometry.width * currentScale, height: geometry.height * currentScale)
        let horizontalLimit = max((imageSize.width - geometry.width) / 2, 0)
        let verticalLimit = max((imageSize.height - geometry.height) / 2, 0)

        let adjustedOffset = CGSize(
            width: min(max(newOffset.width, -horizontalLimit), horizontalLimit),
            height: min(max(newOffset.height, -verticalLimit), verticalLimit)
        )
        return adjustedOffset
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
