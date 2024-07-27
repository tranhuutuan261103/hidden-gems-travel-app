const { bucket } = require('../config/FirebaseHelper.js');
const fs = require('fs');
const { ref, uploadBytes, getDownloadURL } = require('firebase/storage');

module.exports = {
    /**
        * Uploads a file to Firebase Storage
        * @param {Object} file - The file object
        * @param {String} path - The path to store the file in Firebase Storage
        * @param {String} filename - The name of the file
        * @returns {String} - The download URL of the file
        * @throws {Error} - Throws an error if the upload fails
        */
    upload: async (file, path, filename) => {
        try {
            console.log(file);
            const storageRef = ref(bucket, `${path}/${new Date().toISOString()}${filename}`);

            // get the buffer of the file from file path
            const buffer = fs.readFileSync(file.path);

            if (file.mimetype !== 'image/jpeg' && file.mimetype !== 'image/png') {
                await uploadBytes(storageRef, buffer, { contentType: 'image/png' });
                return getDownloadURL(storageRef);
            }

            await uploadBytes(storageRef, buffer, { contentType: file.mimetype });
            return getDownloadURL(storageRef);
        } catch (error) {
            throw new Error(error);
        }
    },

    /**
     * Uploads multiple files to Firebase Storage
     * @param {Array} files - An array of file objects
     * @param {String} path - The path to store the files in Firebase Storage
     * @returns {Array} - An array of download URLs
     * @throws {Error} - Throws an error if the upload fails
     */
    uploadMultiple: async (files, path, filename = "") => {
        try {
            const urls = [];
            for (const file of files) {
                if (filename !== "") {
                    file.originalname = filename;
                }
                const url = await module.exports.upload(file, path, file.originalname);
                urls.push(url);
            }
            return urls;
        } catch (error) {
            throw new Error(error);
        }
    }
};