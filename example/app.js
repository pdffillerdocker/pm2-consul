const port = 8080
const logpath = '/var/log/nodejs/app.log'

require('dotenv').config();

var greeting = process.env.GREETING_STRING || 'No greeting for now ... =(';
var counter = 0;

var winston = require('winston')
var logfile = new winston.transports.File({ filename: logpath })
var logger = winston.createLogger({
  level: 'info',
  format: winston.format.json(),
  transports: [ logfile ]
});
logger.info("Log file opened.");

process.on('SIGINT', function() {
  // what we should perform for graceful stop
  console.log("SIGINT received. Exiting for reload.");
  logger.info("SIGINT received. Exiting for reload.");
  process.exit(0);
});

process.on('SIGHUP', function() {
  // what we should perform to reopen application log file
  console.log("SIGHUP received. Reopening application log file.");
  logger.info("Log file is closing.");
  logfile.close();
  delete logfile;
  logger.clear();
  logfile = new winston.transports.File({ filename: logpath })
  logger.add(logfile);
  logger.info("Log file reopened.");
});

var http = require('http');
var server = http.createServer(function (request, response) {
  counter++;
  response.writeHead(200, {"Content-Type": "text/plain"});
  response.end(greeting + "\nRequests since last reload: " + counter + "\n");
  logger.info("requested " + request.url + " from " + request.connection.remoteAddress);
});

server.listen(port);

console.log("This is STDOUT. Server started.");
console.error("This is STDERR. Server started.");
logger.info("This is application log. Server started.");
