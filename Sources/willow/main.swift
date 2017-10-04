import WillowCore

let willow = WillowCore()

do {
    try willow.run()
} catch {
    print("Error running willow: \(error)")
}
