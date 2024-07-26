module.exports = {
    upload: async (postId, urls) => {
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

    retrieve: async (imageUrl) => {
        const data_body = {
            "url": imageUrl
        };
        const response = await fetch(`${process.env.DINOV2HELPER_URL}/retrieve_image/`, {
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