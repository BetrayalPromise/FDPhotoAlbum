//
//  CodableExtensions.swift
//  FDFoundation
//
//  Created by Youhao Gong 宫酉昊 on 2019/3/5.
//  Copyright © 2019 Yongpeng Zhu 朱永鹏. All rights reserved.
//

import Foundation

public extension Encodable {
    /// 将 model 编码成参数字典
    public func fd_toDic() -> [String: Any] {
        var result: [String: Any] = [:]

        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(self)
            if let dic = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                result = dic
            } else {
                result = ["error": "得到的参数字典无法转换成 [Stirng: Any] 类型"]
            }
        } catch {
            print(error)
            result = ["error": error]
        }

        return result
    }
}

public extension Decodable {
    // 将字典解码成 model
    public static func fd_fromDic(dic: [String: Any?]) throws -> Self {
        let jsonData = try JSONSerialization.data(withJSONObject: dic)
        let model = try JSONDecoder().decode(Self.self, from: jsonData)
        return model
    }
}
