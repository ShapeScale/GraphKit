//
//  TimelineGraph.swift
//  ShapeScale
//
//  Created by deeje cooley on 3/20/20.
//  Copyright © 2020 ShapeScale. All rights reserved.
//

import SwiftUI

public struct TimelineGraph<T : ShapeStyle, U: ShapeStyle>: View, Graph {
    @State public var data : [(Date, Double)]
    @State public var style : LineGraphStyle<T, U> = LineGraphStyle()
    
    public var body: some View {
        ZStack{
            Grid(count: 10)
                .appearance(style.appearance)
                .gridType(style.grid)
            
            VStack {
                HStack {
                    if self.style.labels.lowerY != "" || self.style.labels.upperY != "" {
                        VStack{
                            Text(self.style.labels.upperY)
                            Spacer()
                            Text(self.style.labels.lowerY)
                        }
                    }
                    
                    VStack{
                        GeometryReader { geometry in
                            Timeline(points: self.data, geometry: geometry, style: self.style)
                        }
                    }
                }
                
                if self.style.labels.lowerX != "" || self.style.labels.upperX != "" {
                    HStack {
                        Text(self.style.labels.lowerX)
                        Spacer()
                        Text(self.style.labels.upperX)
                        
                    }
                    .padding(.leading, 15)
                }
            }
        }
    }
    
}

struct TimelineGraph_Previews: PreviewProvider {
    @State static var points = [(Date(timeIntervalSinceNow: -60 * 60 * 24 * 14), 10.0),
                                (Date(timeIntervalSinceNow: -60 * 60 * 24 * 10), 9.0),
                                (Date(timeIntervalSinceNow: -60 * 60 * 24 * 2), 3.0),
                                (Date(), 6.0)]
    @State static var s = LineGraphStyle<Color, LinearGradient>(
        strokeWidth: 1,
        curve: .continuous,
        appearance: .auto,
        grid: .horizontal
    )
    
    static var previews: some View {
        
        TimelineGraph(data: points, style: s)
            .padding(10)
            .background(Color.black)
            .frame(height: 250)
    }
}
