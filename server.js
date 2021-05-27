const cors = require('cors');
const express = require('express');
const app = express(),
      bodyParser = require("body-parser");
      port = 4600;
      app.use(cors());


const users = [];

app.use(bodyParser.json());
app.use(express.static(process.cwd()+"/my-app/dist/angular-nodejs-example/"));

app.get('/api/users', (req, res) => {
  res.json(users);
});

app.post('/api/user', (req, res) => {
  const user = req.body.user;
  users.push(user);
  res.json("user addedd");
  console.log(req.body);                                                                                                                                                                                                                                        
});


app.get('/', (req,res) => {
  res.send('App works!!');
  res.sendFile(process.cwd()+"/my-app/dist/angular-nodejs-example/index.html")
});
var arg='final24'
app.listen(port, () => {
  console.log(`Server listening on the port::${port}`);
  /*const { exec } = require('child_process');
	var yourscript = exec(`sh Automation.sh ${arg}`,
       		(error, stdout, stderr) => {
          		console.log(stdout);
            		console.log(stderr);
            		if (error !== null) {
                			console.log(`exec error: ${error}`);
            		}
        	});*/
});
