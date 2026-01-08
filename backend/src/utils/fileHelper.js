const fs = require('fs');
const path = require('path');
const logger = require('./logger');

/**
 * File helper utilities
 */
const deleteFile = (relativeUrl) => {
    if (!relativeUrl) return;

    try {
        // Convert URL /uploads/rabbits/file.jpg to absolute path
        // Assuming the URL starts with /uploads
        const absolutePath = path.join(__dirname, '../../', relativeUrl);

        if (fs.existsSync(absolutePath)) {
            fs.unlinkSync(absolutePath);
            logger.info('File deleted', { path: absolutePath });
        }
    } catch (error) {
        logger.error('Error deleting file', { error: error.message, url: relativeUrl });
    }
};

module.exports = {
    deleteFile
};
