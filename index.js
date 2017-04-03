const cluster = require('cluster');

// Basically whether or not the bot should restart itself on error
const DEV_MODE = true;

if(cluster.isMaster) {
  // Create a worker for our bot to run in
  cluster.fork();

  // Replace the worker if it dies
  cluster.on('exit', (worker, code, signal) => {
    console.log('\n--- Worker Died ---\n');
    if(code != 0 && !DEV_MODE) cluster.fork();
  });
}

if(cluster.isWorker) {
  console.log('\n--- Worker Started ---\n');
  // Just hands over the context to the main livescript file
  require('./build/main');
}
