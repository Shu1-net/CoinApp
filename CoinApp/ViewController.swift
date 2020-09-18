//
//  ViewController.swift
//  CoinApp
//
//  Created by 天野修一 on 2020/09/13.
//  Copyright © 2020 shuichiama.com. All rights reserved.
//

import UIKit
//                                    Pickerを使うようのオプション               別ファイルで作ったプロトコル
//                                                            データソース用
class ViewController:UIViewController,UIPickerViewDataSource,UIPickerViewDelegate,CoinManegerDelegate {
//  下記2つの関数は、上で起きたエラーををfixしたら自動的に出てくる(ラベル表示するため)(追加)
//  正常に作動するとき
    func didUpdatePrice(rate: String, currency: String, crypto: String) {
        
//      非同期処理？？？
        DispatchQueue.main.async {
        self.rateLabel.text = rate
        self.cryptoLabel.text = crypto
        self.currencyLabel.text = currency
        }
    }
//  データを取れずエラーしたとき
    func didFailWithError(error: Error) {
        print("error")
    }
    
    
//  下記2つの関数は、上で起きたエラーををfixしたら自動的に出てくる(pickerを機能させるため)
//  ドラムロールの列数指定(自動1個目)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
//      別ファイルの構造体を取ってくるための変数
        var coinManager = CoinManager()
    
//  ドラムロールの行数(自動2個目)
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//      構造体の中の、配列を選択し、countする(配列の値の数とpickerViewのセルの数を自動で対応)
        
        if component == 0 {
            return coinManager.cryptoArray.count
        }
        
        return coinManager.currencyArray.count

        /*
        switch component {
        case 0:
            return 5
        default:
            break
        }
        return coinManager.currencyArray.count
        */
    }
    

    
//  手動で追加(セルに表示するラベルを指定できるようにする)
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        if component == 0 {
            
            return coinManager.cryptoArray[row]
        }
        return coinManager.currencyArray[row]
        /*
        switch component {
        case 0:
            return coinManager.cryptoArray[row]
        default:
            break
        }
        return coinManager.currencyArray[row]
        */
    }

//  pickerで選択した値(配列)を取得する
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//      選択されたrowのものを指定する
//        print(coinManager.cryptoArray[row],coinManager.currencyArray[row])
//      pickerの列指定が連動してしまっっている
        
        let selectedCrypto = coinManager.cryptoArray[pickerView.selectedRow(inComponent: 0)]
        let selectedCurrency = coinManager.currencyArray[pickerView.selectedRow(inComponent: 1)]
                print(selectedCrypto,selectedCurrency)

        //  コインマネージャーに送る。引数指定は補完に合わせる
        coinManager.getCoinPrice(for: selectedCrypto, currency: selectedCurrency)
        /*失敗例
        let selectedCrypto = coinManager.cryptoArray[row]
        let selectedCurrency = coinManager.currencyArray[row]
        */
        
        
    }
    
    
//これのおかげで列分岐？？ => ていうわけではなかった...
//MARK:- didReceiveMemoryWarning
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//      データソースを使うための必須コード
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
//      使用するデリゲート指定(追加)
        coinManager.delegate = self
        
//      ピッカーの初期値(今回はいらない。もっと複雑なPicker(それ自身に機能をもたせたりするもの)には必要)
//      pickerView.selectRow(<#T##row: Int##Int#>, inComponent: <#T##Int#>, animated: <#T##Bool#>)

//        currencyPicker.selectRow(0, inComponent: 0, animated: false)
//        currencyPicker.selectRow(1, inComponent: 1, animated: false)
    }



    @IBOutlet var cryptoLabel: UILabel!
    
    @IBOutlet var rateLabel: UILabel!
    
    @IBOutlet var currencyLabel: UILabel!
    
    
    
    
    @IBOutlet var currencyPicker: UIPickerView!
    
    
    
    
}

