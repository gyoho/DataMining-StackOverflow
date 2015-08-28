module.exports = function() {

	// =====================================
	// HOME PAGE (with login links) ========
	// =====================================
	app.get('/', function(req, res) {
		res.render('index.ejs'); // load the index.ejs file
	});

	app.get('/alllink', function(req, res) {
		res.render('allLink.html'); // load the index.ejs file
	});
};