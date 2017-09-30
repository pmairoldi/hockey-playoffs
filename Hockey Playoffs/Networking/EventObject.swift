struct EventObject: Codable {
    let details: String
    let eventID: Int
    let formalID: String
    let gameID: Int
    let period: Int //TODO: make enum of 1, 2, 3, ot(int)
    let strength: Int //TODO: make enum or change api to return enum
    let teamID: String
    let time: String
    let type: String  //TODO: make enum
    let videoLink: String
    
    enum CodingKeys: String, CodingKey {
        case details = "description"
        case eventID
        case formalID
        case gameID
        case period
        case strength
        case teamID
        case time
        case type
        case videoLink
    }
}
