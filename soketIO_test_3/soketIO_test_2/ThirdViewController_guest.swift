//
//  ThirdViewController_guest.swift
//  soketIO_test_2
//
//  Created by 中村暸汰 on 2022/08/11.
//

import UIKit
import SocketIO

class ThirdViewController_guest: UIViewController {
    let manager = SocketManager(socketURL: URL(string:"https://vps6.nkmr.io/")!, config: [.log(true), .compress])
    var socket : SocketIOClient!
    
    @IBOutlet weak var gameStart: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    var nameData = ""
    var roomId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = "\(nameData)さん"

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
        socket.on("from_server"){data, ack in
            if let id = data as? [String]{
                print(id[0])
            }
        }
        //部屋が見つかったのでゲームスタート
         socket.on("ready-guest"){data, ack in
             //ボタンを使えるようにする
             self.gameStart.isEnabled = true
         }
        socket.connect()
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGame2" {
            let nextView = segue.destination as! ViewController
            nextView.userType = "guest"
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
