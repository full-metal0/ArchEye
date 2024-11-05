import ActivityKit
import Foundation
import WidgetKit

struct ActivityAttributesDynamicIsland: ActivityAttributes {
    typealias Status = ContentState
    
    struct ContentState: Codable, Hashable {
        var value: String
    }
}
