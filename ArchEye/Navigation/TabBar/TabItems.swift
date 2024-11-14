import Foundation

enum TabItems: Int, CaseIterable {
    case history
    case explore
    case profile
    
    var title: String {
        switch self {
        case .history:
            return "History"
        case .explore:
            return "Explore"
        case .profile:
            return "Profile"
        }
    }
    
    var icon: String {
        switch self {
        case .history:
            return "clock"
        case .explore:
            return "building.columns"
        case .profile:
            return "person"
        }
    }
}

