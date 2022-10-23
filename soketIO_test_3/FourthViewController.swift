//
// FourthViewController.swift
// soketIO_test_2
//
// Created by 中村暸汰 on 2022/08/11.
//
import UIKit
import SocketIO

class FourthViewController: UIViewController {
    let manager = SocketManager(socketURL: URL(string:"https://vps6.nkmr.io/")!, config: [.log(true), .compress])
    var socket : SocketIOClient!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var RoomNumber: UILabel!
    @IBOutlet weak var gameStart: UIButton!
    var nameData = ""
    var roomNumber = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        RoomNumber.text = roomNumber
        nameLabel.text = "\(nameData)さん"

        // Do any additional setup after loading the view.
        socket = manager.defaultSocket
        //ゲストが来たのでゲーム開始画面に移る
        //接続された場合の処理
        socket.on(clientEvent: .connect){ data, ack in
            print("socket connected!")
        }
        //接続が切れた場合の処理
        socket.on(clientEvent: .disconnect){data, ack in
            print("socket disconnected!")
        }
        socket.on("ready-host"){data, ack in
            //ボタンを使えるようにする
            self.gameStart.isEnabled = true
        }
        socket.connect()
    }

    //2人揃ったら
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGame1" {
            let nextView = segue.destination as! ViewController
            nextView.userType = "host"
        }
    }
  // MARK: - Navigation
  // In a storyboard-based application, you will often want to do a little preparation before navigation
}
