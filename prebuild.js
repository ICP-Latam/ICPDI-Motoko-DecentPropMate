const { exec } = require('child_process');

const isWindows = process.platform === 'win32';

const command = isWindows ? 'dfx generate' : '/usr/bin/sh -c "echo $PATH && /home/mromero/bin/dfx generate"';

exec(command, (error, stdout, stderr) => {
  if (error) {
    console.error(`Error executing command: ${error}`);
    return;
  }
  console.log(`stdout: ${stdout}`);
  console.error(`stderr: ${stderr}`);
});
console.log("Node.js Environment PATH:", process.env.PATH);
process.env.PATH += ':/home/mromero/bin/';
