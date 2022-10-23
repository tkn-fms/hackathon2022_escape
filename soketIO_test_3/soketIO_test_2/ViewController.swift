//
//  ViewController.swift
//  soketIO_test_2
//
//  Created by 大石琉翔 on 2022/08/10.
//

import UIKit
import SocketIO

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var UICodeField: UITextField!
    
    
    let manager = SocketManager(socketURL: URL(string:"https://vps6.nkmr.io/")!, config: [.log(true), .compress])
    
    var socket : SocketIOClient!
    var dataList :NSMutableArray! = []

    @IBOutlet weak var testTableView: UITableView!
    
    @IBAction func tapButtonAction(_ sender: Any) {
        socket.emit("from_client", "button pushed!!")
    }
    
    @IBAction func reconnectButtonAction(_ sender: Any) {
        socket.connect()
    }
    
    @IBAction func deconnectButtonAction(_ sender: Any) {
        socket.disconnect()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        nameTextField.placeholder = "名前を入力してください。"
        
        testTableView.delegate = self
        testTableView.dataSource = self

        socket = manager.defaultSocket

        socket.on(clientEvent: .connect){ data, ack in
            print("socket connected!")
        }

        socket.on(clientEvent: .disconnect){data, ack in
            print("socket disconnected!")
        }

        socket.on("from_server"){data, ack in
            if let message = data as? [String]{
                print(message[0])
                self.dataList.insert(message[0],at: 0)
                self.testTableView.reloadData()
            }
        }
        socket.connect()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        cell.textLabel?.text = dataList[indexPath.row] as? String;
        return cell
    }
}





