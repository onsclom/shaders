const WebSocket = require("ws");
const {v1: uuidv1} = require("uuid");
const wss       = new WebSocket.Server({ port: process.env.PORT || 8080 });

console.log("startuped up!")

function broadcast(clientId, message) {
    
    wss.clients.forEach(client => {
        if (client.readyState === WebSocket.OPEN && client.id != clientId) {
            client.send(message);
        }
    });

}

wss.on("connection", ws => {
    ws.id = uuidv1();
    console.log("new connection: " + ws.id);

    ws.on('close', () => {
        
        const disconnectMsg = {
            id: ws.id,
            type: "disconnectEvent"
        };

        disconnectMsgJSON = JSON.stringify(disconnectMsg);

        broadcast(ws.id, disconnectMsgJSON)
        // this should actually broadcast to all that they disconnected probably!
    });

    ws.on("message", message => {

        console.log("recieved message. now broadcasting!");
    
        messageData = JSON.parse(message);

        if (messageData.type == "connected")
        {
            console.log("wow we got a connection type");

            const connectedResponse = {
                type: "connectedResponse",
                id: ws.id
            };

            let response = JSON.stringify(connectedResponse);

            //ws is the connected websocket
            ws.send(response);

            // const newConnection = {
            //     type: "newConnection",
            //     id: ws.id
            // };

            // let newConnectionJSON = JSON.stringify(newConnection);

            //broadcast new player joined event
            //broadcast(ws.id, newConnectionJSON);
        }
        else
        {
            broadcast(ws.id, message);
        }
    });
});