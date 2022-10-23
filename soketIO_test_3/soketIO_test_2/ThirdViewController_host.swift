//
//  ThirdViewController_host.swift
//  soketIO_test_2
//
//  Created by 中村暸汰 on 2022/08/11.
//

import UIKit
import SocketIO

class ThirdViewController_host: UIViewController {
    let manager = SocketManager(socketURL: URL(string:"https://vps6.nkmr.io/")!, config: [.log(true), .compress])
    var socket : SocketIOClient!
    
    @IBOutlet weak var nameLabel: UILabel!
    var nameData = ""
    var roomNumber = ""
    var mode = ""

    override func viewDidLoad() {
        super.viewDidLoad()
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
        socket.connect()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //ホスト名とモードとコースを送る
        socket.emit("room-settings", roomNumber, nameData, mode, "body")

        //ボタンは全身だけ動く
        if segue.identifier == "toNext" {
            let nextView = segue.destination as! FourthViewController
            nextView.nameData = nameData
            nextView.roomNumber = roomNumber
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
