import SwiftUI
import CoreGraphics
import Accelerate

#if canImport(UIKit)
import UIKit
public typealias HistogramImage = UIImage
#endif

#if canImport(AppKit)
import AppKit
public typealias HistogramImage = NSImage
#endif


/// A SwiftUI Image Histogram View (for RGB channels)
public struct HistogramView: View {

    /// The image from which the histogram will be calculated
    public let image: CGImage

    /// The opacity of each channel layer. Default is `1`
    public let channelOpacity: CGFloat

    /// The blend mode for the channel layers. Default is `.screen`
    public let blendMode: BlendMode

    /// The scale of each layer. Default is `1`
    public let scale: CGFloat

    public init(image: HistogramImage, channelOpacity: CGFloat = 1, blendMode: BlendMode = .screen, scale: CGFloat = 1) {
        self.image          = image.cgImage!
        self.channelOpacity = channelOpacity
        self.blendMode      = blendMode
        self.scale          = scale
    }

    public var body: some View {
        if let data = image.histogram() {
            ZStack {
                Group {
                    HistogramChannel(data: data.red, scale: scale).foregroundColor(.red)
                    HistogramChannel(data: data.green, scale: scale).foregroundColor(.green)
                    HistogramChannel(data: data.blue, scale: scale).foregroundColor(.blue)
                }
                .opacity(channelOpacity)
                .blendMode(blendMode)
            }
            .id(image)
            .drawingGroup()
        }
    }
}



