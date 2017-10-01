struct Response: Codable {
    let events: [Event]
    let games: [Game]
    let periods: [Period]
    let series: [Matchup]

    enum CodingKeys: String, CodingKey {
        case events
        case games
        case periods
        case series = "teams"
    }
}
