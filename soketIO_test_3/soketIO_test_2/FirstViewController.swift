//
//  FirstViewController.swift
//  soketIO_test_2
//
//  Created by 中村暸汰 on 2022/08/11.
//

import UIKit
import SocketIO

class FirstViewController: UIViewController {
    let manager = SocketManager(socketURL: URL(string:"https://vps6.nkmr.io/")!, config: [.log(true), .compress])
    var socket : SocketIOClient!
    
    @IBOutlet weak var nameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.placeholder = "名前を入力してください。"

        // Do any additional setup after loading the view.
        socket = manager.defaultSocket
        //接続された場合の処理
        socket.on(clientEvent: .connect){ data, ack in
            print("socket connected!")
            self.socket.emit("start", "connect start")
        }
        //接続が切れた場合の処理
        socket.on(clientEvent: .disconnect){data, ack in
            print("socket disconnected!")
        }
        socket.on("from_server"){data, ack in
            if let id = data as? [String]{
                print(id[0])
            }
        }
        socket.connect()
    }
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // ここでroomNumberを作成
        let base = "123456789"
        //5文字のランダムな文字列を生成
        let num = String((0..<5).map{ _ in base.randomElement()! })

        //部屋作成ボタン（ホスト）
        if segue.identifier == "toNext_host" {
            //ユーザーネームを送る
            self.socket.emit("create-room", nameTextField.text!, num)
            let nextView = segue.destination as! SecondViewController_host
            nextView.nameData = self.nameTextField.text!
            nextView.roomNumber = num
        }
        //部屋入室ボタン(ゲスト）
        if segue.identifier == "toNext_guest" {
            let nextView = segue.destination as! SecondViewController_guest
            nextView.nameData = nameTextField.text!
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
