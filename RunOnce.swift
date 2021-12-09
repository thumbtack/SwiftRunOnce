import Foundation

public enum RunOnce {
    private typealias RunMap = [ClosureSignature: Bool]
    private static var lockKey: Void?
    private static var runMapKey: Void?

    private struct ClosureSignature: Hashable {
        let line: Int
        let column: Int
        let fileId: String
    }

    /**
     Immediately executes a closure, and ensures that the given closure will only be executed at most once during
     the lifetime of the associated object.

     - Parameter object: The object with which to associate this closure.
     - Parameter closure: The code to be executed once. The passed closure executed immediately, and then never again.
     - Parameter line: This value should be left as is. Modifying the default value will have undefined behavior.
     - Parameter column: This value should be left as is. Modifying the default value will have undefined behavior.
     - Parameter fileId: This value should be left as is. Modifying the default value will have undefined behavior.
     */
    public static func forLifetime(
        of object: AnyObject,
        _ closure: () -> Void,
        line: Int = #line,
        column: Int = #column,
        fileId: String = #fileID
    ) {
        let signature = ClosureSignature(line: line, column: column, fileId: fileId)
        let lock = getLock(for: object)

        lock.lock()
        var runMap = getRunMap(for: object)
        guard runMap[signature] == nil else {
            lock.unlock()
            return
        }

        runMap[signature] = true
        setRunMap(runMap, for: object)
        lock.unlock()

        closure()
    }

    private static func getLock(for object: AnyObject) -> NSLock {
        if let lock = objc_getAssociatedObject(object, &Self.lockKey) as? NSLock {
            return lock
        }

        let lock = NSLock()
        objc_setAssociatedObject(object, &Self.lockKey, lock, .OBJC_ASSOCIATION_RETAIN)
        return lock
    }

    private static func getRunMap(for object: AnyObject) -> RunMap {
        if let runMap = objc_getAssociatedObject(object, &Self.runMapKey) as? RunMap {
            return runMap
        }

        let runMap: RunMap = [:]
        setRunMap(runMap, for: object)
        return runMap
    }

    private static func setRunMap(_ runMap: RunMap, for object: AnyObject) {
        objc_setAssociatedObject(object, &Self.runMapKey, runMap, .OBJC_ASSOCIATION_RETAIN)
    }
}

public extension NSObject {
    func runOnce(_ closure: () -> Void, line: Int = #line, column: Int = #column, fileId: String = #fileID) {
        RunOnce.forLifetime(of: self, closure, line: line, column: column, fileId: fileId)
    }
}
