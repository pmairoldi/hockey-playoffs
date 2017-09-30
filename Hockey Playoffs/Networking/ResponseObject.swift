struct ResponseObject: Codable {
    let events: [EventObject]
    let games: [GameObject]
    let periods: [PeriodObject]
    let teams: [TeamObject]
}
