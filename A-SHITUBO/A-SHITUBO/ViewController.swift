//
//  ViewController.swift
//  soketIO_test_2
//
//  Created by 大石琉翔 on 2022/08/10.
//

import UIKit
import SocketIO

var Game1_Scene: Int = 1

//役割を制御する変数（true:　押す側　false:　押される側）
var pushMan: Bool = true

//ターン数を管理（5ターンで役割チェンジ・10ターンで終了）
var Turn: Int = 0
var Score: Int = 0

//プレイ中かを管理
var NowGame: Bool = true


class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    //socket.ioの設定
    let manager = SocketManager(socketURL: URL(string:"https://vps6.nkmr.io/")!, config: [.log(true), .compress])
    var socket : SocketIOClient!
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var score: UILabel!
    
    var dataList: [String] = [
        "胃", "肝臓", "首", "心臓",
        "腎臓", "生殖器", "頭", "尿管", "胃", "肝臓"
    ]
    
    var userType = ""

    override func viewDidLoad() { //画面の再描画時に毎回呼びだされるところ
        super.viewDidLoad()
        if(Turn == 0){ //初回だけホストかゲストかで値の設定をする
            if(userType == "host"){
                pushMan = true //ホストは押す側から
            }else{
                pushMan = false //ゲストは押される側から
            }
        }
        
        // Do any additional setup after loading the view.
        socket = manager.defaultSocket
        //接続された場合の処理
        socket.on(clientEvent: .connect){data, ack in
            print("socket connected!")
        }
        //接続が切れた場合の処理
        socket.on(clientEvent: .disconnect){data, ack in
            print("socket disconnected!")
        }
        socket.on("next-q"){data, ack in
            //次の問題へ移動する
        }
        socket.connect()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //押される側の処理
        print("ユーザー:"+String(pushMan))
        if(!pushMan && NowGame){
            pickerView.delegate = self
            pickerView.dataSource = self
        }
        
        //ゲーム終了判定
        if(Turn == 10){
            score.text = String(Score)+"点"
            Turn = 0
        }
    }
    
    //サーバーから文字を受け取ると動く関数を書く
    //今はボタンをタップしたら受け取ったことにする（決定ボタン）　押す側のボタン
    @IBAction func receive_msg(_ sender: Any) {
        Turn += 1
        Game1_Scene += 1
        gameChange(turn: Turn) //ホスト側の攻守交代判定（押す→押される）
        gameFin(turn: Turn)
        if(pushMan && NowGame){
            self.performSegue(withIdentifier: "toGame1_"+String(Game1_Scene),sender: nil)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataList.count
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // UIPickerViewの最初の表示
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        
        return dataList[row]
    }
    
    var answer: String = ""
    //正解時のアラート
    func cor_showAlert(message: String) {
          let alertController = UIAlertController(
            title: "正解です！", message: "その調子です！", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
                self.gameChange(turn: Turn)
                self.gameFin(turn: Turn)
        }))
          present(alertController, animated: true, completion: nil)
      }
    //不正解時のアラート
    func incor_showAlert(message: String, turn: Int) {
          let alertController = UIAlertController(title: "不正解です！",
            message: "答えは"+message+"でした。", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
                self.gameChange(turn: turn)
                self.gameFin(turn: turn)
        }))
          present(alertController, animated: true, completion: nil)
      }
    
    //ターン数を渡して，攻守交代か判定する
    func gameChange(turn: Int){
        print("ターン:"+String(Turn))
        if(turn == 5){
            if(pushMan){
                pushMan = false
                print("ユーザー:"+String(pushMan))
                self.performSegue(withIdentifier: "toGame2", sender: nil)
            }else{
                pushMan = true
                print("ユーザー:"+String(pushMan))
                self.performSegue(withIdentifier: "toGame1_"+String(Game1_Scene), sender: nil)
            }
        }
    }
    //ターン数が10だったら結果を返す
    func gameFin(turn: Int){
        if(turn == 10){
            NowGame = false
            self.performSegue(withIdentifier: "toResult", sender: nil)
        }
    }
    
    //押される側が答えを送信
    @IBAction func send_answer(_ sender: Any) {
        Turn += 1
        if(answer == dataList[Turn-1]){
            Score += 20
            cor_showAlert(message: dataList[Turn-1])
        } else {
            incor_showAlert(message: dataList[Turn-1], turn: Turn)
        }
    }
    
    // UIPickerViewのRowが選択された時の挙動
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int,
                    inComponent component: Int) {
        answer = dataList[row]
        
    }
    
}



