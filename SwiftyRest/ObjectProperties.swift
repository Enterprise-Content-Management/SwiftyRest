//
//  ObjectProperties.swift
//  SwiftyRest
//
//  Created by Song, Michyo on 12/1/16.
//  Copyright © 2016 EMC. All rights reserved.
//

/**
 Object properties for Rest object model.
 */
public enum ObjectProperties : String {
    case ID = "id"
    case TITLE = "title"
    case UPDATED = "updated"
    case PUBLISHED = "published"
    case CONTENT = "content"
    case LINKS = "links"
    case PROPERTIES = "properties"

    case TYPE = "type"
    case NAME = "name"
    case R_OBJECT_TYPE = "r_object_type"
    case OBJECT_NAME = "object_name"
    case OWNER_NAME = "owner_name"
    case R_MODIFY_DATE = "r_modify_date"
    case R_CREATION_DATE = "r_creation_date"
    case USER_NAME = "user_name"
    case USER_SOURCE = "user_source"
    case USER_LOGIN_NAME = "user_login_name"
    case USER_PASSWORD = "user_password"
    case USER_PRIVILEGES = "user_privileges"
}
