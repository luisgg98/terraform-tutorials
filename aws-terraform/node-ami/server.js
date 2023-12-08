/**
 * Universidad Internacional de la Rioja
 * Luis Garcia Garces
 * 
 */

const express = require('express');
const MongoClient = require('mongodb').MongoClient;

// Initialize Express app
const app = express();
const port = 3000;

// Read the MongoDB URL from the environment variable
const ip_mongodb = process.env.MONGODB_IP;
const url = `mongodb://${ip_mongodb}:27017`;

let logMessages = '';

if (!url) {
  logMessages = 'MongoDB URL is not defined in the environment.\n';
  console.error(logMessages);
  process.exit(1);
}

// Database Name
const dbName = 'your-database-name';
// Create a new MongoClient
const client = new MongoClient(url);

// Route to check MongoDB connection
app.get('/', async (req, res) => {
  try {
    await client.connect();
    logMessages = 'Connected to MongoDB successfully\n';
    res.send(`Hello World! I am Luis Garcia Garces, welcome to my server!\n${logMessages}MongoDB URL: ${url}\n`);
  } catch (err) {
    logMessages =`Error connecting to MongoDB. Check server logs for more details. ${err} \n`
    res.status(500).send(logMessages);
  } finally {
    await client.close();
  }
});

// Start the server
app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}/`);
  logMessages = `Server running at http://localhost:${port}/\n`;
});
