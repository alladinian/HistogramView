![HistogramView](https://user-images.githubusercontent.com/156458/138126267-b1799ab2-87fe-4e7a-86bd-e36cdd9aa6bd.png)

# HistogramView

A SwiftUI view for displaying image histograms.

## How do I use it?

It's as simple as:
``` swift
HistogramView(image: myImage)
```

*Note:* Both `UIImage` & `NSImage` are supported (by the `HistogramImage` typealias, depending on the platform).

## What options do I have for configuration?

The initializer supports channel opacity, blendMode and scale for the final graph.

``` swift
/// The opacity of each channel layer. Default is `1`
public let channelOpacity: CGFloat

/// The blend mode for the channel layers. Default is `.screen`
public let blendMode: BlendMode

/// The scale of each layer. Default is `1`
public let scale: CGFloat
```

## How fast is this thing?

Under the hood the histogram calculation is performed by `Accelerate`'s `vImageHistogramCalculation_ARGB8888` for RGB channels, so it's pretty good actually.
Fast enough to be perfomed synchronously (although didn't test it on gigantic images).

## How is the graph curve produced?

Each channel is a `SwiftUI` `Path` that uses [Hermite interpolation](https://en.wikipedia.org/wiki/Hermite_interpolation) for generating a continous curve.
The actual implementation for the interpolator is taken from [@FlexMonkey's implementation](https://github.com/FlexMonkey/Filterpedia/blob/7a0d4a7070894eb77b9d1831f689f9d8765c12ca/Filterpedia/components/HistogramDisplay.swift#L228) (part of the [Filterpedia](https://github.com/FlexMonkey/Filterpedia) project) and adapted to be used on `Path` instead of `UIBezierPath`.


## Authors
Vasilis Akoinoglou, alladinian@gmail.com  
