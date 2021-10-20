//
//  HistogramChannel.swift
//  
//
//  Created by Vasilis Akoinoglou on 20/10/21.
//

import SwiftUI

struct HistogramChannel: Shape {

    let data: [UInt]
    let scale: CGFloat

    private var maximum: UInt { data.max() ?? 0 }

    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: 0, y: rect.height))

            let interpolationPoints: [CGPoint] = data.enumerated().map { (index, element) in
                let y = rect.height - (CGFloat(element) / CGFloat(maximum) * rect.height) * scale
                let x = CGFloat(index) / CGFloat(data.count) * rect.width
                return CGPoint(x: x, y: y)
            }

            guard let curves = Path.interpolatePointsWithHermite(interpolationPoints: interpolationPoints) else {
                return
            }

            path.addPath(curves)
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
        }
    }

}
