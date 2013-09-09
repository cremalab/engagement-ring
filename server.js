var app, express, mongoose;

console.log("app node file", process.cwd());

express = require('express');

app = express();

app.configure(function() {
  // return app.use(express.bodyParser());
  app.use(express["static"](__dirname + '/public/'));
  app.get('*', function(req,res){
   res.sendfile(__dirname + '/public/index.html');
  });
});

// require('./app_routes')(app);

exports.startServer = function(port, path, callback) {
  var p;
  p = process.env.PORT || port;
  console.log("startServer on port: " + p + ", path " + path);
  return app.listen(p);
};

exports.startServer();
