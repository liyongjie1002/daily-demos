//
//  LAPersonaModel.swift
//  LoveAI
//
//  Created by mac on 2024/8/23.
//

import Foundation
import HandyJSON

class LAPersonaResponseData: HandyJSON {
    var code = 0
    var data = [LAPersonaDataModel]()
    required init() {}
}

class LAPersonaDataModel: HandyJSON {
    var category = ""
    var category_icon = ""
    var list = [LAPersonaModel]()
    required init() {}
}

class LAPersonaModel: HandyJSON {
    var person_id = ""
    var person_name = ""
    var person_desc = 0
    var icon = ""
    var is_hot = false
    var is_default = false
    var emoji = ""
    required init() {}

}
