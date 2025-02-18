const fs = require('fs');
const path = require('path');

function getPresentationList() {
    const presentationsDir = path.join(__dirname, 'presentaties');
    const files = fs.readdirSync(presentationsDir);
    return files
        .filter(file => file.endsWith('.pdf'))
        .map(file => file.replace('.pdf', ''));
}

module.exports = { getPresentationList };
