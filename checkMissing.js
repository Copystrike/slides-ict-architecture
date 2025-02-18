const { exec } = require('child_process');
const fs = require('fs');
const path = require('path');
const execSync = require('child_process').execSync;

function getExpectedPresentations() {
    // Get all theory lesson directories
    const files = fs.readdirSync(__dirname);
    return files
        .filter(file => file.startsWith('theorieles'))
        .map(file => file.replace(' ', '-').toLowerCase());
}

function getExistingPresentations() {
    const presentationsDir = path.join(__dirname, 'presentaties');
    const files = fs.readdirSync(presentationsDir);
    return files
        .filter(file => file.endsWith('.pdf'))
        .map(file => file.replace('.pdf', ''));
}

function printMissingPresentations() {
    const existing = getExistingPresentations();
    const expected = getExpectedPresentations();
    const missing = expected.filter(exp => !existing.includes(exp));

    
    missing.forEach(pres => {
        // exec echo `pres` is missing
        execSync(`echo ${pres} is missing`);
    });
}

printMissingPresentations();
