//
//  CoinData.swift
//  CoinApp
//
//  Created by 天野修一 on 2020/09/13.
//  Copyright © 2020 shuichiama.com. All rights reserved.
//

import Foundation

struct CoinData: Decodable {
//  通貨のレートをアクセス(データ型は小数ありのDouble)
    let rate: Double
}
