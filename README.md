## Server Side

### Start server at port `3000`

```dart
final server = await ServerSocket.connect(ip: io.InternetAddress.anyIPv4, port: 3000);

  server.onConnection((Socket client) {
    handleClient(client);
    /// You can listen to event from this perticular client 
    /// using Socket method on
  });
```
---
<br>

## Client Side

###  Connect to server hosted on `localhost` at port `3000`

```dart
final Socket client = await ClientSocket.connect(host: "0.0.0.0", port: 3000);
handleServerConnection(client);
```
### Add event listener pass `on` as an event  

```dart
  final registered = client.on('message', (data) {
    //TODO: display message
  });
```

### Listen to any event from server

```dart 
client.listen((data){
    //TODO : 
})
```
`data` key , value pair `=>` `Map<String,dynamic>`

### Send data for event `on`

`STEP 1` : Declare class & extend it with DTO
```dart
/// remember to exnted class from DTO for data transmission
/// there we will be transferring Message data over socket 

class Message extends DTO {
  String username;
  String message;

  Message({required this.username, required this.message});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(username: json['username'], message: json['message']);
  }

  @override
  Map<String, dynamic> toJson() {
    return {"username": username, "message": message};
  }

/// in case you wish to encode data differently
/// then remember to decode data correspondingly
  @override
  String encode() {
    return json.encode(toJson());
  }
}
```
`STEP 2` : Send corresponding `message`
```dart
client.send(
      'message',
      Message(
        username: username,
        message: 'Hi i am $username',
        ),
    );
```