const express = require('express');
const app = require('express')()
const cors = require('cors');
const crypto = require('crypto')
const { Client } = require('pg')
const ConsistentHash = require('consistent-hash')
const hr = new ConsistentHash()
hr.add('5432')
hr.add('5433')
hr.add('5434')

app.use(cors());
app.use(express.json()); 

const clients = {
    '5432': new Client ({
        'host': 'localhost',
        'port': '5432',
        'user': 'postgres',
        'password': 'postgres',
        'database': 'postgres'
    }),
    '5433': new Client ({
        'host': 'localhost',
        'port': '5433',
        'user': 'postgres',
        'password': 'postgres',
        'database': 'postgres'
    }),    
    '5434': new Client ({
        'host': 'localhost',
        'port': '5434',
        'user': 'postgres',
        'password': 'postgres',
        'database': 'postgres'
    })
}

connect();
async function connect() {
    await clients['5432'].connect()
    await clients['5433'].connect()
    await clients['5434'].connect()
}



app.get('/{:urlId}', async (req, res) => {
    const urlId = req.params.urlId 
    const server = hr.get(urlId)
    const result = await clients[server].query('select * from url_table where url_id = $1', [urlId])
    if (result.rowsCount > 0) {
        res.send({
            'urlId': urlId,
            'hash': hash,
            'server': server
        })
    } else {
        res.sendStatus(404)
    }
})

app.post('/', async (req, res) => {
    const url = req.query.url

    // consistently hash this to get a port 
    const hash = crypto.createHash('sha256').update(url).digest('base64')
    const urlId = hash.substr(0, 5)
    const server = hr.get(urlId)

    await clients[server].query('insert into url_table (url, url_id) values ($1, $2)', [url, urlId])


    res.send({
        'urlId': urlId,
        'hash': hash,
        'server': server
    })

})

app.listen(8081, () => {
    console.log("listening to 8081")
})

// const urls = []
// for(let i = 0; i < 100; i++) {
//     urls.push(`https://google.com.in?q=test${i}`)
// }
// urls.forEach(u => fetch('http://localhost:8081/?url=https://wikipedia.com.bh/another', {'method': 'POST'}).then(a => a.json()).then(console.log))