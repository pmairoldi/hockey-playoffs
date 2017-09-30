struct PeriodObject: Codable {
    let gameID: Int
    let goals: Int
    let period: Int //TODO: make enum of 1, 2, 3, ot(Int)
    let shots: Int
    let teamID: String
}
