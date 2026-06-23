import Foundation

protocol AccessPolicy { func canAccess(_ feature: String, as role: UserRole) -> Bool }
