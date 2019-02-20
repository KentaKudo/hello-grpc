const {HelloRequest, HelloResponse} = require('./api/api_pb.js')
const {GreeterClient} = require('./api/api_grpc_web_pb.js')

// create a client specifying host
var client = new GreeterClient('http://localhost:8080')

// create a request
var request = new HelloRequest();
request.setName('World')

// send a request and print
client.sayHello(request, {}, (err, response) => {
    document.write(response.getMessage());
});