const express = require('express');
const multer = require('multer');
const path = require('path');
const fs = require('fs');
const extract = require('extract-zip'); // For extracting zip files
const app = express();
const defaultPort = 3000;

// Set the root path for saving files
const rootPath = path.join('D:', 'SCAN_CODE');

// Function to ensure the directory exists
const ensureDir = (dirPath) => {
  if (!fs.existsSync(dirPath)) {
    fs.mkdirSync(dirPath, { recursive: true });
  }
};

// Function to get the current date in DD-MM-YYYY format
const getCurrentDateFolder = () => {
  const now = new Date();
  const day = String(now.getDate()).padStart(2, '0');
  const month = String(now.getMonth() + 1).padStart(2, '0'); // Month is 0-based
  const year = now.getFullYear();
  return `${day}-${month}-${year}`;
};

// Set up multer storage to dynamically set the destination folder
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    const fileName = file.originalname;
    const folderName = fileName.split('_')[0]; // Extract the part before the first '_'
    const dateFolder = getCurrentDateFolder(); // Get the current date folder
    const uploadPath = path.join(rootPath, folderName, dateFolder);

    ensureDir(uploadPath); // Ensure the folder exists
    cb(null, uploadPath); // Save files to the dynamic path
  },
  filename: (req, file, cb) => {
    cb(null, file.originalname); // Save file with the original name
  },
});

// Create the multer instance
const upload = multer({ storage: storage });

// POST route to handle file or directory (as zip) upload
app.post('/upload', upload.single('file'), async (req, res) => {
  if (!req.file) {
    return res.status(400).send('No file uploaded.');
  }

  const uploadedPath = req.file.path;

  try {
    // Check if the uploaded file is a zip file
    if (path.extname(uploadedPath) === '.zip') {
      const extractFolderName = req.file.originalname.split('_')[0]; // Extract folder name from file name
      const dateFolder = getCurrentDateFolder(); // Get the current date folder
      const extractPath = path.join(rootPath, extractFolderName, dateFolder, path.basename(uploadedPath, '.zip'));

      // Extract zip contents
      await extract(uploadedPath, { dir: extractPath });
      console.log('Zip extracted to:', extractPath);

      // Respond with success and path details
      res.json({
        message: 'Zip file uploaded and extracted successfully!',
        path: extractPath,
      });
    } else {
      // Handle single file upload (no extraction needed)
      console.log('File uploaded successfully:', uploadedPath);

      res.json({
        message: 'File uploaded successfully!',
        path: uploadedPath,
      });
    }
  } catch (error) {
    console.error('Error handling upload:', error);
    res.status(500).send('Error processing upload.');
  }
});

// Function to start the server with dynamic port handling
function startServer(port) {
  const server = app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
  });

  server.on('error', (err) => {
    if (err.code === 'EADDRINUSE') {
      console.log(`Port ${port} in use, trying next port...`);
      startServer(port + 1); // Try the next port
    } else {
      console.error('Server error:', err);
    }
  });
}

// Start the server
startServer(defaultPort);
