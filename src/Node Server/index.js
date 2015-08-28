var express = require('express');
var app = express();
//var path    = require("path");


	//app.use(express.logger('dev')); // log every request to the console
	//app.use(express.cookieParser()); // read cookies (needed for auth)
	//app.use(express.bodyParser()); // get information from html forms
	app.set('port', (process.env.PORT || 5000));
	app.use(express.static(__dirname + '/public'));
	app.set('view engine', 'ejs'); // set up ejs for templating

app.get('/', function(req, res) {
		res.render('index'); // load the index.ejs file
	});

	app.get('/alllink', function(req, res) {
		res.render('allLink'); // load the index.ejs file
	});

	app.get('/simbin', function(req, res) {
		res.render('similarityBin'); // load the index.ejs file
	});

	app.get('/simtfldf', function(req, res) {
		res.render('similarityTfIdf'); // load the index.ejs file
	});

	app.get('/cluster', function(req, res) {
		res.render('cluster'); // load the index.ejs file
	});

app.listen(app.get('port'), function() {
  console.log("Node app is running at localhost:" + app.get('port'));
});
