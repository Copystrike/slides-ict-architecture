const puppeteer = require("puppeteer");
const fs = require("fs");

async function exportSlides() {
  if (!process.argv[2]) {
    console.error("Please provide a folder name as an argument");
    process.exit(1);
  }

  console.log("Starting export process...");
  console.log("Target folder:", process.argv[2]);

  const browser = await puppeteer.launch({
    headless: "new",
  });
  console.log("Browser launched");

  const page = await browser.newPage();
  console.log("New page created");

  try {
    // Set the viewport to zoom out
    await page.setViewport({
      // A4 landscape
      width: 842,
      height: 595,
      deviceScaleFactor: 4, // Zoom out by setting a lower scale factor
    });

    await page.goto("http://localhost:8000", {
      waitUntil: "networkidle0",
      timeout: 30000,
    });

    console.log("Waiting for Reveal.js to load...");
    await page.waitForFunction(
      () => {
        return typeof Reveal !== "undefined" && Reveal.isReady();
      },
      { timeout: 10000 }
    ); // Add timeout of 10 seconds
    console.log("Reveal.js loaded");

    const dir = "presentaties";

    try {
      if (!fs.existsSync(dir)) {
        fs.mkdirSync(dir, { recursive: true });
      }
    } catch (err) {
      console.error("Error creating directory:", err);
      throw err;
    }
    
    console.log("Pressing 'e' key...");
    await page.keyboard.press("e");
    
    // wait 5 seconds for the page to render
    await new Promise((resolve) => setTimeout(resolve, 1000));
    
    await page.evaluate(() => {
      const downloadsSection = document.querySelector(".downloads-section");
      downloadsSection.style.display = "none";
    });

    console.log("Generating PDF...");
    const pdfPath = `${dir}/${process.argv[2].replaceAll(" ", "-")}.pdf`;

    await page.pdf({
      path: pdfPath,
      width: "842px",
      height: "595px",
      printBackground: true,
      outline: false,
      scale: 0.5,
      tagged: false,
    });

    console.log(`PDF saved to ${pdfPath}`);

    await browser.close();
  } catch (err) {
    console.error("Detailed error:", err);
    await browser.close();
    process.exit(1);
  }
}

// Actually execute the function
exportSlides().catch((err) => {
  console.error("Top level error:", err);
  process.exit(1);
});
