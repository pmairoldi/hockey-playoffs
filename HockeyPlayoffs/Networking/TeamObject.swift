struct TeamObject: Codable {
    let awayID: String
    let conference: String //TODO: make enum of east/west
    let homeID: String
    let round: Int //TODO: make enum of rounds
    let seasonID: String
    let seed: Int //TODO: make enum of all possible seeds
}
