//
//  LinkRel.swift
//  SwiftyRest
//
//  Created by Song, Michyo on 11/24/16.
//  Copyright © 2016 EMC. All rights reserved.
//

/**
 Link relation mapping for identifiers in REST
 */
public enum LinkRel: String {
    case selfRel = "self"
    case repositories = "http://identifiers.emc.com/linkrel/repositories"
    case cabinets = "http://identifiers.emc.com/linkrel/cabinets"
    case delete = "http://identifiers.emc.com/linkrel/delete"
    case objects = "http://identifiers.emc.com/linkrel/objects"
    case edit = "edit"
    case content = "http://identifiers.emc.com/linkrel/primary-content"
    case enclosure = "enclosure"
    case checkout = "http://identifiers.emc.com/linkrel/checkout"
    case checkinMajor = "http://identifiers.emc.com/linkrel/checkin-next-major"
    case checkinMinor = "http://identifiers.emc.com/linkrel/checkin-next-minor"
    case parent = "parent"
    case currentUser = "http://identifiers.emc.com/linkrel/current-user"
    case groups = "http://identifiers.emc.com/linkrel/groups"
    case users = "http://identifiers.emc.com/linkrel/users"
    case batches = "http://identifiers.emc.com/linkrel/batches"
    case removeMember = "removeMember"
    case parentLinks = "http://identifiers.emc.com/linkrel/parent-links"
    case childLinks = "http://identifiers.emc.com/linkrel/child-links"
    case search = "http://identifiers.emc.com/linkrel/search"
    case dql = "http://identifiers.emc.com/linkrel/dql"
    case comments = "http://identifiers.emc.com/linkrel/comments"
    case replies = "http://identifiers.emc.com/linkrel/replies"
    case permissions = "http://identifiers.emc.com/linkrel/permissions"
}

