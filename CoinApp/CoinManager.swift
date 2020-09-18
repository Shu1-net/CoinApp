//
//  CoinManager.swift
//  CoinApp
//
//  Created by 天野修一 on 2020/09/13.
//  Copyright © 2020 shuichiama.com. All rights reserved.
//
//ただのswiftファイルなので、空白(初期補完なし)
import Foundation

//作成したURLから
//構造体を
protocol CoinManegerDelegate {
    func didUpdatePrice(rate: String,currency: String,crypto: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
//APIKeyでアクセスするための構造体
        let baseURL = "https://rest.coinapi.io/v1/exchangerate"
        let apiKey = "A28147BD-2E29-40D6-8121-C0CA5AE7B798"
//URL、Keyどちらも”文字列”として！！
    
        let cryptoArray = ["BTC","BCH","ETH","XRP","XEM"]
        let currencyArray = ["USD","CNY","JPY","EUR","HKD","GBP","SGD","DKK","AUD","THB","TWD","XAU","XAG"]
    
//
    //      上で設定したプロトコルにアクセス
        var delegate:CoinManegerDelegate?
    
//  ViewControllerで取得したデータを再度取得
//  仮想通貨名と通貨名がURL組み込みに必要のため。
    func getCoinPrice(for crypto: String,currency: String){

//        print(currency,"送れたよ")
        
//      URLを組み込む(構造体の要素と組み合わせる)
        let urlString = "\(baseURL)/\(crypto)/\(currency)?apikey=\(apiKey)"
        
        print(urlString)
        
//      URLと正しく認識できるか判断する
        if let url = URL(string: urlString) {
//          デフォルトのURLセッションを適用
            let  session = URLSession(configuration: .default)
//          オプションにあるdataTaskにアクセスする
            let task = session.dataTask(with: url) { (data,responce,error)in
//          データにアクセスしたときにエラーが出たときの処理
                if error != nil{
                    self.delegate?.didFailWithError(error:error!)
                    return
                }
                
//              追加
                if let safeData = data{
                    if let bitcoinPrice = self.parseJSON(safeData) {
                        let rateString = String(format: "%.2f", bitcoinPrice)
//                                                       表示フォーマット(小数点以下第二位まで、2f = 第2)
//                      プロトコルで値渡し格納
                        self.delegate?.didUpdatePrice(rate: rateString, currency: currency, crypto: crypto)
                    }
                }
            }
//          タスク(47)実行
            task.resume()

        }
    }
    
    
//  JSONを使って情報入手する用
//                 アンダーバーを忘れないこと！
    func parseJSON(_ data: Data) -> Double? {
        
//      JSONの解析用に定義
        let decoder = JSONDecoder()
        
//      解析(構造体の中身にアクセス)
        do {
            let decodeData = try decoder.decode(CoinData.self, from: data)
//          最新のデータを取得
            let lastPrice = decodeData.rate
            
            print(lastPrice)
            return lastPrice
            
//        エラー回避(JSONでアクセスできなかった時用)
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
        
//       ！！！！！！エラー回避にdo catchはよく使われる！！！！！！！！！
        
        
        
    }
//func
    
    
    
}
//struct
