//
//  CGImage+Histogram.swift
//  
//
//  Created by Vasilis Akoinoglou on 20/10/21.
//

import Foundation
import Accelerate

extension CGImage {

    /// The function calculates the histogram for each channel completely separately from the others.
    /// - Returns: A tuple contain the three histograms for the corresponding channels. Each of the three histograms will be an array with 256 elements.
    func histogram() -> (red: [UInt], green: [UInt], blue: [UInt])? {
        let format = vImage_CGImageFormat(
            bitsPerComponent: 8,
            bitsPerPixel: 32,
            colorSpace: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue),
            renderingIntent: .defaultIntent)!

        guard var sourceBuffer = try? vImage_Buffer(cgImage: self, format: format) else {
            return nil
        }

        defer {
            sourceBuffer.free()
        }

        var histogramBinZero  = [vImagePixelCount](repeating: 0, count: 256)
        var histogramBinOne   = [vImagePixelCount](repeating: 0, count: 256)
        var histogramBinTwo   = [vImagePixelCount](repeating: 0, count: 256)
        var histogramBinThree = [vImagePixelCount](repeating: 0, count: 256)

        histogramBinZero.withUnsafeMutableBufferPointer { zeroPtr in
            histogramBinOne.withUnsafeMutableBufferPointer { onePtr in
                histogramBinTwo.withUnsafeMutableBufferPointer { twoPtr in
                    histogramBinThree.withUnsafeMutableBufferPointer { threePtr in

                        var histogramBins = [zeroPtr.baseAddress, onePtr.baseAddress,
                                             twoPtr.baseAddress, threePtr.baseAddress]

                        histogramBins.withUnsafeMutableBufferPointer { histogramBinsPtr in
                            let error = vImageHistogramCalculation_ARGB8888(&sourceBuffer,
                                                                            histogramBinsPtr.baseAddress!,
                                                                            vImage_Flags(kvImageNoFlags))

                            guard error == kvImageNoError else {
                                fatalError("Error calculating histogram: \(error)")
                            }
                        }
                    }
                }
            }
        }

        return (histogramBinZero, histogramBinOne, histogramBinTwo)
    }

}

#if os(macOS)
import AppKit
public extension NSImage {
    var cgImage: CGImage? {
        guard let imageData = tiffRepresentation else { return nil }
        guard let sourceData = CGImageSourceCreateWithData(imageData as CFData, nil) else { return nil }
        return CGImageSourceCreateImageAtIndex(sourceData, 0, nil)
    }
}
#endif
