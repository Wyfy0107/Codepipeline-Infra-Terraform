const app = require('express')();
const os = require('os');
const PORT = 3000;

app.get('/', (req, res) => res.send(`hello from ${os.hostname()} `));
app.listen(PORT);
