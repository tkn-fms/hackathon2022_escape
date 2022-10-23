const express = require("express");
const mysql = require("mysql");

const app = express();
const port = 3000;

var http = require("http").Server(app);
const io = require("socket.io")(http);

app.use(express.urlencoded({ extended: true }));
app.use(express.json());

const con = mysql.createConnection({
  host: "mysql",
  port: 3306,
  user: "test",
  password: "test1234",
  database: "test_db",
  multipleStatements: true,
});
con.connect((err) => {
  if (err) throw err;
  console.log("Connected");
});
app.get("/", (_, res) => {
  const sql = "SELECT * FROM users";
  con.query(sql, (err, result, fields) => {
    if (err) throw err;
    res.send(result);
  });
});

/* soket.ioでクライアントとの接続 */
io.on('connection',function(socket){
    //クラアンと接続時の処理
    socket.on('connect', function(){
      console.log("client connected");
    })
    // クライアント切断時の処理
    socket.on('disconnect', function() {
      console.log("client disconnected");
    });
    //iOSとの接続時の処理
    socket.on("start", function(text){
      console.log(text);
    });

    //部屋作成処理
    socket.on("create-room", function(hostName){
      //mysqlにデータを送る
      const sql = "INSERT INTO users SET host='"+hostName+"'";
      con.query(sql, function(err, result, fields){
        if (err) throw err;
      });
      console.log("部屋作成完了");
    });

    //部屋の詳細設定処理
    socket.on("room-settings", function(roomId, hostName ,gameMode, gameCourse){
      //mysqlに部屋の詳細設定を送る
      const sql = "UPDATE users SET roomId=' "+roomId+"', mode='"+gameMode+"', course='"+gameCourse+"' WHERE host='"+hostName+"'";
      con.query(sql, (err, result, fields) => {
        if (err) throw err;
      });
      //mysqlに一定間隔で問い合わせ
      var inquiry = function(){
        var sql2 = "SELECT * FROM users WHERE roomId='"+roomId+"'";
        con.query(sql2, (err, result, fields) => {
          if (err) throw err;
          console.log("問い合わせ中… ゲスト名:"+result[0]["guest"]);
          if(result[0]["guest"] != ""){
            //guestが来たことを知らせる
            setTimeout(function(){
              console.log("guest来たよ");
              io.emit('ready-host');
            },3000);
            clearTimeout(repeatInquiry);
          }
        });
        var repeatInquiry = setTimeout(inquiry, 3000);
      };
      inquiry();
    });

    //ゲストの入室処理
    socket.on("guest-come", function(roomId, guestName){
      console.log("guest-come発動!");
      //mysqlにゲスト名・ルームIDを送る
      const sql = "UPDATE users SET guest='"+guestName+"' WHERE roomId='"+roomId+"'; SELECT * FROM users WHERE roomId='"+roomId+"'";
      con.query(sql, (err, results, fields) => {
        if (err){
          throw err;
        }
        console.log(results[1]);
        //ゲーム開始の処理
        setTimeout(function(){
          console.log("guest準備OK!");
          io.emit('ready-guest');
        },3000);
      });
    });
  });

  // とりあえず一定間隔でサーバ時刻を"全"クライアントに送る (io.emit)
  var send_servertime = function() {
    var now = new Date();
    io.emit("from_server", now.toLocaleString());
    console.log(now.toLocaleString());
    setTimeout(send_servertime, 5000)
  };
  send_servertime();

  http.listen(port, function(){
    console.log('server listening. Port:' + port);
  });