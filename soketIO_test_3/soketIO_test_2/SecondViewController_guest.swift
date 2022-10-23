//
//  SecondViewController.swift
//  soketIO_test_2
//
//  Created by 中村暸汰 on 2022/08/11.
//
    
import UIKit
import SocketIO

class SecondViewController_guest: UIViewController {
    let manager = SocketManager(socketURL: URL(string:"https://vps6.nkmr.io/")!, config: [.log(true), .compress])
    var socket : SocketIOClient!
    
    @IBOutlet weak var RoomNumber: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    var nameData = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RoomNumber.placeholder = "部屋番号を入力してください。"
        nameLabel.text = "\(nameData)さん"

        // Do any additional setup after loading the view.
        socket = manager.defaultSocket
        //接続された場合の処理
        socket.on(clientEvent: .connect){ data, ack in
            print("socket connected!")
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
        //ゲスト名・ルームIDを送る
        let rid :Int? = Int(RoomNumber.text!)
        socket.emit("guest-come", rid!,  nameData)
        if segue.identifier == "toNext" {
            let nextView = segue.destination as! ThirdViewController_guest
            nextView.nameData = nameData
            nextView.roomId = RoomNumber.text!
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

