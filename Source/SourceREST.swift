//
//  Info.swift
//  Source
//
//  Created by Kristoffer Dalby on 23/12/15.
//  Copyright © 2015 Kristoffer Dalby. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class ServerInfo {
    var address: String
    var appid: Int?
    var dedicated: String?
    var gameDescription: String?
    var gamedir: String?
    var hostname: String?
    var map: String?
    var maxPlayers: Int?
    var networkVersion: Int?
    var numberOfBots: Int?
    var numberOfPlayers: Int?
    var operatingSystem: String?
    var passworded: Bool?
    var ping: Float?
    var port: Int?
    var secure: Bool?
    var steamid: Int64?
    var version: String?
    var players: PlayerInfo?
    var error: Bool

    required init(address: String) {
        self.address = address
        self.error = false
    }

    func update(completionHandler: () -> Void) {
        let parameters = ["data": self.address]

        Alamofire.request(.POST, ServerInfo.endpointForServerInformation(),
            parameters: parameters,
            encoding: .JSON)
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let jason = JSON(value)

                        if jason["status"] == "error" {
                            self.hostname = jason["data"].stringValue
                            self.error = true
                        } else {
                            let serverInfoJSON = jason["data"][self.address]
                            self.update_data(serverInfoJSON)
                            self.error = false
                        }
                        if self.players == nil {
                            self.players = PlayerInfo(address: self.address)
                        }
                        self.players?.update(completionHandler)
                    }
                case .Failure(let error):
                    print(error)
                    self.error = true
                }
        }
    }

    private func update_data(json: JSON) {
        self.appid = json["appid"].intValue
        self.dedicated = json["dedicated"].stringValue
        self.gameDescription = json["gamedesc"].stringValue
        self.gamedir = json["gamedir"].stringValue
        self.hostname = json["hostname"].stringValue
        self.map = json["map"].stringValue
        self.maxPlayers = json["maxplayers"].intValue
        self.networkVersion = json["network_version"].intValue
        self.numberOfBots = json["numbots"].intValue
        self.numberOfPlayers = json["numplayers"].intValue
        self.operatingSystem = json["os"].stringValue
        self.passworded = json["passworded"].boolValue
        self.ping = json["ping"].floatValue
        self.port = json["port"].intValue
        self.secure = json["secure"].boolValue
        self.steamid = json["steamid"].int64Value
    }

    func numberOfPlayersOfMax() -> String? {
        if let numberOfPlayers = self.players?.numberOfPlayers, let maxPlayers = self.maxPlayers {
            return "\(numberOfPlayers)/\(maxPlayers)"
        }
        return nil
    }

    // MARK: Endpoints
    class func endpointForServerInformation() -> String {
        return "https://source.fap.no/api/v1/serverinfo"
    }
}


class PlayerInfo {
    var address: String
    var numberOfPlayers: Int?
    var players: [Player]
    var error: Bool

    required init(address: String) {
        self.address = address
        self.players = []
        self.error = false
    }

    func update(completionHandler: () -> Void) {
        let parameters = ["data": self.address]

        Alamofire.request(.POST, PlayerInfo.endpointForPlayerInformation(),
            parameters: parameters,
            encoding: .JSON)
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let jason = JSON(value)

                        if jason["status"] == "error" {
                            self.error = true
                        } else {
                            let serverInfoJSON = jason["data"][self.address]
                            self.update_data(serverInfoJSON)
                            self.error = false
                        }
                        completionHandler()
                    }
                case .Failure(let error):
                    print(error)
                    self.error = true
                }
        }
    }

    private func update_data(json: JSON) {
        self.players = []

        for pl in json.arrayValue {
            let player = Player(
                index: pl["index"].intValue,
                kills: pl["kills"].intValue,
                name: pl["name"].stringValue,
                time: pl["time"].floatValue
            )

            self.players.append(player)
            self.players.sortInPlace({$0.kills > $1.kills})
        }
        self.numberOfPlayers = self.players.count
    }

    // MARK: Endpoints
    class func endpointForPlayerInformation() -> String {
        return "https://source.fap.no/api/v1/playerinfo"
    }

}


class Player {
    var index: Int
    var kills: Int
    var name: String
    var time: Float

    required init(index: Int, kills: Int, name: String, time: Float) {
        self.index = index
        self.kills = kills
        self.name = name
        self.time = time
    }
}
