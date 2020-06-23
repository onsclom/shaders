const WebSocket = require("ws");
const {v1: uuidv1} = require("uuid");
const wss       = new WebSocket.Server({ port: process.env.PORT || 8080 });

console.log("startuped up!")

function broadcast(clientId, message) {
    
    wss.clients.forEach(client => {
        //if (client.readyState === WebSocket.OPEN && client.id != clientId) {
        if (client.readyState === WebSocket.OPEN) {
        //client.send(`[${clientId}]: ${message}`);
            client.send(message);
        }
    });

}

wss.on("connection", ws => {
    ws.id = uuidv1();
    console.log("new connection: " + ws.id);

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
        }
        else
        {
            console.log("its not a connection type");
    
            broadcast(ws.id, message);
        }

    });
});