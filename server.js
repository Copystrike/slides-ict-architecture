/* Officiële Reveal docs doen uitschijnen dat het nodig is de broncode te klonen en aan te passen per presentatie.
 * Dit script staat toe presentaties buiten die folder te plaatsen.
 * Zo blijft code van Reveal.js zelf gescheiden van code slides.
 */
const express = require('express');
const ejs = require('ejs');
const fs = require('fs');
const path = require('path');
const app = express();
const port = 8000;

const staticDir = path.join(__dirname, process.argv[2]);
const templateFilePath = "index.ejs";

app.get('/', (req, res, next) => {
    const contentFilePath = path.join(staticDir, req.path, "index.md");
    const markdownContent = fs.readFileSync(contentFilePath, 'utf8');
    const rawFolderName = process.argv[2];
    const folderName = rawFolderName.endsWith("/") || rawFolderName.endsWith("\\") ? rawFolderName.slice(0, -1) : rawFolderName;
    ejs.renderFile(
        templateFilePath,
        { markdownContent, folderName: folderName },
        (err, str) => {
            if (err) return next(err);
            res.send(str);
        });
});

// afbeeldingen en Reveal moeten ook geserveerd worden!
app.use(express.static(staticDir));
app.use(express.static("."));
app.use("/reveal.js", express.static(__dirname + "/node_modules/reveal.js"))

app.listen(port, () => {
    console.log(`Listening on http://localhost:${port} with static dir ${path.join(__dirname, process.argv[2])}`);
});
