//
//  LAViewModel.swift
//  LoveAI
//
//  Created by mac on 2024/8/22.
//

import UIKit
import Booming

let base_url = "https://api.lovekey.store/v1"

// header

let get_person_list = "/api/get_person_list"
let get_hi_list = "/api/get_hi_list"
let gen_reply = "/api/gen_reply"

class LAGlobalViewModel: NSObject {
    
    // 请求人设市场
    func requestPersonas(block :@escaping ([LAPersonaModel]) -> ()) {
        let api = NetworkAPIOO()
        api.ip = "https://api.lovekey.store/v1/api/get_person_list?gender=1"
        api.method = APIMethod.get
        api.request(successed: { response in
            guard let string = response.bpm.toJSONString(prettyPrint: true), let data = LAPersonaResponseData.deserialize(from: string), data.code == 1 else {
                return
            }
            let personas = data.data.first?.list
//            LAGlobalManager.shared.allPersonaCategorys = personas
            block(personas ?? [LAPersonaModel]())
        })
    }
    
}
