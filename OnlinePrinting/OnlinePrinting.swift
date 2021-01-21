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
    var widgetModel: WidgetModel
}

struct Provider: TimelineProvider {
    
    typealias Entry = SimpleEntry
        
    @AppStorage( "lastVisitedCategory", store: UserDefaults(suiteName: "group.com.developer-xpn.store.OnlinePrinting") )
    private var lastVisitedCategory: Data = Data()
    
    func placeholder(in context: Context) -> SimpleEntry {
        return SimpleEntry( widgetModel: WidgetModel(image: "", title: "Loading visited items"))
    }
    
    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        let entry = SimpleEntry(widgetModel:  WidgetModel(image: "", title: "The best Item Ever!!!"))
        completion( entry )
    }
        
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        
        guard let item = try? JSONDecoder().decode(WidgetModel.self, from: lastVisitedCategory) else {
            let entry = SimpleEntry(widgetModel:  WidgetModel(image: "", title: "Not found"))
            completion( Timeline(entries: [entry], policy: .atEnd))
            return
        }
                
        let entry = SimpleEntry(widgetModel:  item)
        completion( Timeline(entries: [entry], policy: .atEnd))
    }
}

@main
struct WidgetView: Widget {
    private let kind = "Widget"
    
    var body: some WidgetConfiguration {
        
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            
            ZStack {
                Image(entry.widgetModel.title)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                
                Text( "Your last visited item was: \(entry.widgetModel.title)" )
                    .font(.custom("McLaren-Regular", size: 15))
                    .padding()
            }
            
        } .configurationDisplayName("OnlinePrinting.am")
        .supportedFamilies([.systemSmall])
    }
}
