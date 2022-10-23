# hackathon2022_group4
2022年8月に行った研究室内ハッカソンのgroup4のコード

## Git cloneしてからのdockerコンテナの動作手順（ターミナル）
<p>１．cloneしたhackathon2022_group4/Docker_api_socket/apiのフォルダまで移動</p>
<p>２．その階層で以下のコマンドを実行</p>

```
npm install express
npm install mysql
npm install nodemon
npm install socket.io
```

<p>３．hackathon2022_group4/Docker_api_socketのフォルダに移動</p>
<p>４．その階層で以下のコマンドを実行</p>

```
docker-compose up -d --build
```

<p>５．Docker Desktopなどでdocker-apiの動作を確認</p>
