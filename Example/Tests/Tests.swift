import UIKit
import XCTest
import Chronos

var kMockAtomicTime = "kMockAtomicTime"

var ATOMIC_TIME_AFTER_REBOOT: Double = 100

var ATOMIC_TIME_WITHOUT_REBOOT: Double = 7500

extension ChronosTimeMine {
    
    class func getAtomicTime() -> Double {
        let rebootNeeded = UserDefaults.standard.bool(forKey: kMockAtomicTime)
        return rebootNeeded ? ATOMIC_TIME_AFTER_REBOOT : ATOMIC_TIME_WITHOUT_REBOOT
    }
}

class Tests: XCTestCase {
    
    var MOCK_REBOOT_NEEDED: Bool = false {
        didSet(value) {
            UserDefaults.standard.set(value, forKey: kMockAtomicTime)
        }
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSettingUpOfLastServerTime() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
}
