struct Response: Codable {
    let events: [Event]
    let games: [Game]
    let periods: [Period]
    let teams: [Team]
}
