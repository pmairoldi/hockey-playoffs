struct GameObject: Codable {
    let active: Int
    let awayCondense: String
    let awayHighlight: String
    let awayID: String
    let awayScore: Int
    let date: String
    let gameID: Int
    let homeCondense: String
    let homeHighlight: String
    let homeID: String
    let homeScore: Int
    let homeStatus: String
    let period: Int //TODO: make enum of 1, 2, 3, ot(Int)
    let periodTime: String
    let seasonID: String
    let time: String
    let tv: String
}
