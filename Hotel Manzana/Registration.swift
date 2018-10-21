//
//  Registration.swift
//  Hotel Manzana
//
//  Created by Georgy Dyagilev on 19/10/2018.
//  Copyright © 2018 Georgy Dyagilev. All rights reserved.
//

import Foundation

struct Registration {
    var firstName: String
    var lastName: String
    var emailAdress: String
    
    var checkInDate: Date
    var checkOutDate: Date
    var numberOfAdults: Int
    var numberOfChildren: Int
    
    var roomType: RoomType
    var wifi: Bool
}

struct RoomType {
    var id: Int
    var name: String
    var shortName: String
    var price: Int
}

func loadRooms() -> [RoomType] {
    let rooms: [RoomType] = [
        RoomType(id: 1, name: "Single room suit", shortName: "SRS", price: 40),
        RoomType(id: 2, name: "Double room suit", shortName: "DRS", price: 50),
        RoomType(id: 3, name: "Single room suit de luxe", shortName: "SRSDL", price: 80),
        RoomType(id: 4, name: "Double room suit de luxe", shortName: "DRSDL", price: 95)
    ]
    return rooms
}

extension RoomType: Equatable {
    static func ==(lhs: RoomType, rhs: RoomType) -> Bool {
        return lhs.id == rhs.id
    }
}
