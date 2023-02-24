import XCTest
@testable import KvndDev

final class NSObjectAssociationTests: XCTestCase {
    // MARK: Tests

    func test_associatedValue_returns_nil_when_nothing_was_associated() {
        var key = "key"
        let object = NSObject()
        let value: AnyObject? = object.associatedValue(forKey: &key)
        XCTAssertNil(value)
    }
    
    func test_associatedValue_returns_value_when_it_was_associated() {
        var key = "key"
        let associatedValue = NSString(string: "hello")
        let object = NSObject()
        object.associate(associatedValue, forKey: &key)

        let value: NSString? = object.associatedValue(forKey: &key)
        XCTAssertEqual(associatedValue, value)
    }
    
    func test_associatedValue_returns_default_value_and_stores_it_if_there_was_no_previous_value() {
        var key = "key"
        let associatedValue = NSString(string: "hello")
        let object = NSObject()
        
        let value = object.associatedValue(forKey: &key, defaultValue: associatedValue)
        XCTAssertEqual(associatedValue, value)

        let readValue: NSString? = object.associatedValue(forKey: &key)
        XCTAssertEqual(associatedValue, readValue)
    }
    
    func test_associatedValue_returns_existing_value_if_there_was_previous_value() {
        var key = "key"
        let associatedValue = NSString(string: "hello")
        let object = NSObject()
        object.associate(associatedValue, forKey: &key)
        
        let value = object.associatedValue(forKey: &key, defaultValue: NSString(string: "other"))
        XCTAssertEqual(associatedValue, value)
    }
}
