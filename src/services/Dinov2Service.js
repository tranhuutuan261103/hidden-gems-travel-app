module.exports = {
    uploadImages: async (postId, urls) => {
        const data_body = {
            "id": postId.toString(),
            "urls": urls
        };
        console.log(data_body);
        const response = await fetch(`${process.env.DINOV2HELPER_URL}/upload_images/`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(data_body),
        });
        const data = await response.json();
        if (response.ok) {
            return data;
        } else {
            throw new Error(data.message);
        }
    },

    uploadText: async (postId, text) => {
        console.log("uploadText");
        const data_body = {
            "id": postId.toString(),
            "text": text
        };
        console.log(data_body);
        const response = await fetch(`${process.env.DINOV2HELPER_URL}/upload_text/`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(data_body),
        });
        const data = await response.json();
        if (response.ok) {
            console.log("Upload text success: " + data.message);
            return data;
        } else {
            console.log("Upload text failed: " + data.message);
            throw new Error(data.message);
        }
    },

    retrieve: async (imageUrl) => {
        const data_body = {
            "img_url": imageUrl,
            "type": "image"
        };
        const response = await fetch(`${process.env.DINOV2HELPER_URL}/retrieve/`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(data_body),
        });
        const data = await response.json();
        if (response.ok) {
            return data;
        } else {
            console.log("Retrieve image failed: " + data.message);
            throw new Error(data.message);
        }
    }
};