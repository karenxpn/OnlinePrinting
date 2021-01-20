//
//  OnlinePrinting.swift
//  OnlinePrinting
//
//  Created by Karen Mirakyan on 21.01.21.
//

import WidgetKit
import SwiftUI

struct SimpleEntry: TimelineEntry {
    var date: Date = Date()
}

struct Provider: TimelineProvider {
    
    typealias Entry = SimpleEntry
    
    func placeholder(in context: Context) -> SimpleEntry {
        return SimpleEntry()
    }
    
    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
                
        let entry = SimpleEntry()
        completion( entry )
    }
        
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let entry = SimpleEntry()
        completion( Timeline(entries: [entry], policy: .atEnd))
    }
}

@main
struct WidgetView: Widget {
    private let kind = "StepWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            Text( "Your last visit was: \(entry.date)" )
                .font(.custom("McLaren-Regular", size: 15))
                .padding()
        }
    }
}
