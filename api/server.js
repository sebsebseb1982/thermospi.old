var express  = require('express'),
    path     = require('path'),
    bodyParser = require('body-parser'),
    app = express(),
    expressValidator = require('express-validator');


/*Set EJS template Engine*/
app.set('views','./views');
app.set('view engine','ejs');

app.use(express.static(path.join(__dirname, 'public')));
app.use(bodyParser.urlencoded({ extended: true })); //support x-www-form-urlencoded
app.use(bodyParser.json());
app.use(expressValidator());

/*MySql connection*/
var connection  = require('express-myconnection'),
    mysql = require('mysql');

app.use(
    connection(mysql,{
        host     : 'localhost',
        user     : 'seb',
        password : 'seb',
        database : 'temperatures',
        debug    : false //set true if you wanna see debug logger
    },'request')
);

//RESTful route
var router = express.Router();


/*------------------------------------------------------
*  This is router middleware,invoked everytime
*  we hit url /api and anything after /api
*  like /api/user , /api/user/7
*  we can use this for doing validation,authetication
*  for every route started with /api
--------------------------------------------------------*/
router.use(function(req, res, next) {
    console.log(req.method, req.url);
    next();
});

var querySQL = function(req, res, sql) {
    req.getConnection(function(err,conn){

        if (err) return next("Cannot Connect");

        var query = conn.query(sql,function(err,rows){

            if(err){
                console.log(err);
                return next("Mysql error, check your query");
            }

            res.setHeader('Content-Type', 'application/json');
            res.end(JSON.stringify(rows, null, 3));
        });
    });
};

var daysOfHistory = 1;

router
    .route('/records')
    .get(function(req,res){
        querySQL(req,res,'SELECT * FROM records WHERE date >= ( CURDATE() - INTERVAL ' + daysOfHistory + ' DAY )');
    });

router
    .route('/status')
    .get(function(req,res){
        querySQL(req,res,'SELECT * FROM status WHERE date >= ( CURDATE() - INTERVAL ' + daysOfHistory + ' DAY )');
    });

router
    .route('/sensors')
    .get(function(req,res){
        querySQL(req,res,'SELECT * FROM sensors');
    });

router
    .route('/setpoints')
    .get(function(req,res){
        querySQL(req,res,'SELECT * FROM setpoints WHERE date >= (SELECT date FROM setpoints WHERE date < ( CURDATE() - INTERVAL ' + daysOfHistory + ' DAY ) order by date DESC limit 1);');
    })
    .post(function(req,res){
        req.assert('value','Setpoint value is required').notEmpty();
        var errors = req.validationErrors();
        if(errors){
            res.status(422).json(errors);
            return;
        }

        var exec = require('child_process').exec;
        exec('~/thermospi/scripts/setPoint.sh ' + req.query.value, function(error, stdout, stderr) {
            console.log('stdout: ', stdout);
            console.log('stderr: ', stderr);
            if (error !== null) {
                console.log('exec error: ', error);
            }
                res.setHeader('Content-Type', 'text/plain');
                res.end(stdout);
        });
    });

app.use(function(req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  next();
});


//now we need to apply our router here
app.use('/api', router);

//start Server
var server = app.listen(3000,function(){

   console.log("Listening to port %s",server.address().port);

});
