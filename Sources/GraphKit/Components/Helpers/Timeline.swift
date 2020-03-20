//
//  Timeline.swift
//  ShapeScale
//
//  Created by deeje cooley on 3/20/20.
//  Copyright © 2020 ShapeScale. All rights reserved.
//

import SwiftUI

struct Timeline<T : ShapeStyle, U : ShapeStyle>: View {
    @State var points : [(Date, Double)]
    @State var geometry : GeometryProxy
    var style : LineGraphStyle<T, U>
    
    var path : CGMutablePath {
        let path = CGMutablePath()
        
        if self.style.curve == .continuous {
            
            path.move(to: CGPoint(x: 0, y: self.getHeightValue(height: geometry.size.height, point: self.points.first!.1)))
            
            for index in 1..<self.points.count {
                let newCoordinate = self.generateCoordinate(geometry: geometry, index: index)
                path.addCurve(
                    to: newCoordinate,
                    control1: CGPoint(x: path.currentPoint.x + self.style.curveRadius, y: path.currentPoint.y),
                    control2: CGPoint(x: newCoordinate.x - self.style.curveRadius, y: newCoordinate.y )
                )
            }
            
        } else {
            
            path.move(to: CGPoint(x: 0, y: self.getHeightValue(height: geometry.size.height, point: self.points.first!.1)))
            
            for index in 1..<self.points.count {
                path.addLine(to: self.generateCoordinate(geometry: geometry, index: index))
            }
        }
        
        return path
    }
    
    var closedPath : CGMutablePath {
        let path = self.path
        path.addLine(to: CGPoint(x: CGFloat(self.points.count - 1) * self.getIntervalWidth(width: geometry.size.width), y: geometry.size.height) ) // Bottom  right corner
        path.addLine(to: CGPoint(x: 0, y: geometry.size.height) ) // Bottom left corner
        path.addLine(to: self.generateCoordinate(geometry: geometry, index: 0) ) // Return home
        return path
    }
    
    public var body: some View {
        
        ZStack {
            Path(self.closedPath)
                .fill(self.style.fillColor)
            
            Path(self.path)
                .stroke(self.style.strokeColor, style: .init(
                    lineWidth: self.style.strokeWidth,
                    lineCap: self.style.lineCap,
                    lineJoin: self.style.lineJoin,
                    miterLimit: self.style.miterLimit
                ))
        }
        
    }
    
    private func generateCoordinate(geometry: GeometryProxy, index : Int) -> CGPoint {
        let startDate = points.first!.0
        let endDate = points.last!.0
        let fullTimespan = endDate.timeIntervalSince(startDate)
        let thisDate = points[index].0
        let thisTimespan = endDate.timeIntervalSince(thisDate)
        let ratio = CGFloat(1.0 - (thisTimespan / fullTimespan))
        
        return CGPoint(
        x: ratio * geometry.size.width,
        y: self.getHeightValue(height: geometry.size.height, point: points[index].1)
        )
    }
    
    private func getIntervalWidth(width : CGFloat) -> CGFloat {
        return CGFloat(width / CGFloat(self.points.count - 1))
    }
    
    private func getHeightValue(height: CGFloat, point: Double) -> CGFloat {
        
        return CGFloat(height - (height * CGFloat(point / self.points.map({ return $1 }).max()!)) - (self.style.strokeWidth))
    }
}



struct Timeline_Previews: PreviewProvider {
    @State static var style = LineGraphStyle<Color, LinearGradient>()
    
    static var previews: some View {
        GeometryReader { geometry in
            Timeline(points: [(Date(timeIntervalSinceNow: -60 * 60 * 24 * 14), 10),
                                (Date(timeIntervalSinceNow: -60 * 60 * 24 * 10), 9),
                                (Date(timeIntervalSinceNow: -60 * 60 * 24 * 2), 3),
                                (Date(), 6)],
                     geometry: geometry,
                     style: style)
        }
    }
}
