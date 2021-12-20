# SwiftRunOnce
SwiftRunOnce allows a developer to mark a block of logic as "one-time" code – code that will execute at most once over the lifetime of another object, no matter how many times that block of logic gets invoked.

SwiftRunOnce was designed to satisfy five requirements:
- Robust implementation: A block of code to declared to be one-time code must be just that. There may be no circumstance in which the block of code is allowed to execute a second time over the lifetime of the controlling object.
- Declarative usage: One must be able to make a block of preexisting code into one-time code simply by decorating with the attribute.
- Thread safety: Even in multithreaded environments, a block of code marked with the one-time attribute must execute at most once.
- Reentrancy: A block of one-time code must be able to invoke another block of one-time code without deadlocking or invalidating the one-time constraint.
- Minimalist implementation: Adding a block of one-time code requires no additional storage or maintenance of state within the calling code.  All state management is hidden and protected.

# Usage

SwiftRunOnce exposes a single function:

```swift
forLifetime(
    of object: AnyObject,
    _ closure: () -> Void,
    line: Int = #line,
    column: Int = #column,
    fileId: String = #fileID
)
```

In actual usage, one should always use the default arguments for `line`, `column`, and `fileId` (the behavior when arguments are passed into these parameters is undefined).  An example usage might look something like:

```swift 
func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated: animated)

    // Only fire on initial view, not on back navigation
    RunOnce.forLifetime(of: self) {
        trackView()
    }
}
```

Since most usages of `forLifetime(of::)` will pass `self` as the object, SwiftRunOnce adds a convenience extension to `NSObject` that adds a little more syntactic sugar to this common case.  Using that extension, the above code simply becomes: 

```swift 
func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated: animated)

    // Only fire on initial view, not on back navigation
    runOnce {
        trackView()
    }
}
```

# License

SwiftRunOnce is licensed under the Apache License, Version 2.0. See [LICENSE](https://github.com/thumbtack/SwiftRunOnce/blob/master/LICENSE) for the full license text.
