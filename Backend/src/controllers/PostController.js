const PostService = require("../services/PostService.js");
const UserService = require("../services/UserService.js");
const StorageService = require("../services/StorageService.js");
const Dinov2Service = require("../services/Dinov2Service.js");
const HaversineHelper = require("../utils/HaversineHelper.js");

module.exports = {
    createPost: async (req, res) => {
        try {
            const userId = req.user._id;
            if (!req.files) {
                res.json({ message: "Image is required" });
                return;
            }
            const { title, content, longitude, latitude, address, star, categoryId } = req.body;
            const imageUrls = await StorageService.uploadMultiple(req.files, "Posts", title);
            const post = await PostService.create({ title, content, longitude, latitude, address, images: imageUrls, star, categoryId, createdBy: userId});
            
            await UserService.updatePostsFound(userId, [post._id]);
            await UserService.unlockPost(post._id, userId);
            await UserService.markArrived(post._id, userId);

            let result = post;

            const userInfo = await UserService.getUserInfo(userId);
            const postsUnlocked = userInfo.postsUnlocked;
            const postsArrived = userInfo.postsArrived;

            if (postsUnlocked.includes(post._id)) {
                result = { ...post._doc, isUnlocked: true };
            } else {
                result = { ...post._doc, isUnlocked: false };
            }

            if (postsArrived.includes(post._id)) {
                result.isArrived = true;
            } else {
                result.isArrived = false
            }

            await UserService.increasePoints(userId, parseInt(process.env.POINTS_FOR_CREATING_A_GEM));

            console.log("Upload image successful: " + imageUrls);
            await Dinov2Service.uploadImages(post._id, imageUrls);

            res.json(result);
        } catch (error) {
            res.json({ message: error.message });
        }
    },

    getAllPostByVoting: async (req, res) => {
        try {
            const { longitude, latitude, maxDistance, categoryId, limit } = req.query;
            const userId = req.user._id;
            const posts = await PostService.getAll(longitude, latitude, maxDistance, categoryId, limit);
            await UserService.updatePostsFound(userId, posts.map(post => post._id));

            const userInfo = await UserService.getUserInfo(userId);
            const postsUnlocked = userInfo.postsUnlocked;
            const postsArrived = userInfo.postsArrived;
            let result = [];
            for (let post of posts) {
                if (postsUnlocked.includes(post._id)) {
                    result.push({ ...post, isUnlocked: true });
                } else {
                    result.push({ ...post, isUnlocked: false });
                }

                if (postsArrived.includes(post._id)) {
                    result[result.length - 1].isArrived = true;
                } else {
                    result[result.length - 1].isArrived = false;
                }
            }

            result.sort((a, b) => b.star_average - a.star_average);

            res.json(result);
        } catch (error) {
            res.json({ message: error.message });
        }
    },

    getAllPost: async (req, res) => {
        try {
            const { longitude, latitude, maxDistance, categoryId, limit } = req.query;
            const userId = req.user._id;
            const posts = await PostService.getAll(longitude, latitude, maxDistance, categoryId, limit);
            await UserService.updatePostsFound(userId, posts.map(post => post._id));

            const userInfo = await UserService.getUserInfo(userId);
            const postsUnlocked = userInfo.postsUnlocked;
            const postsArrived = userInfo.postsArrived;
            let result = [];
            for (let post of posts) {
                if (postsUnlocked.includes(post._id)) {
                    result.push({ ...post, isUnlocked: true });
                } else {
                    result.push({ ...post, isUnlocked: false });
                }

                if (postsArrived.includes(post._id)) {
                    result[result.length - 1].isArrived = true;
                } else {
                    result[result.length - 1].isArrived = false;
                }
            }

            if (req.query.keywords) {
                console.log(req.query.keywords);
                const text_retrive = await Dinov2Service.retrieveByText(req.query.keywords);

                // Create a mapping from arr1 to index positions
                const orderMappingForImage = {};
                text_retrive.matches.forEach((id, index) => {
                    orderMappingForImage[id] = index;
                    console.log(id);
                });

                // Sort arr2 based on the order in arr1
                const sortedResult = result.sort((a, b) => {
                    const aIndex = orderMappingForImage.hasOwnProperty(a._id) ? orderMappingForImage[a._id.toString()] : Infinity;
                    const bIndex = orderMappingForImage.hasOwnProperty(b._id) ? orderMappingForImage[b._id.toString()] : Infinity;
                    return aIndex - bIndex;
                });

                res.json(sortedResult);
                return;
            }

            if (!req.file) {
                res.json(result);
                return;
            }

            const imageUrl = await StorageService.upload(req.file, "ImagesForSearch", " image for search");
            // const imageUrl = "https://firebasestorage.googleapis.com/v0/b/hidden-gems-travel-cf03e.appspot.com/o/ImagesForSearch%2F2024-07-26T16%3A25%3A25.279Z%20image%20for%20search?alt=media&token=1baa7a53-15ba-4534-abc5-9a29e9b0d217";
            console.log("Upload image successful: " + imageUrl);
            const image_retrive = await Dinov2Service.retrieve(imageUrl);

            // Create a mapping from arr1 to index positions
            const orderMapping = {};
            image_retrive.matches.forEach((id, index) => {
                orderMapping[id] = index;
                console.log(id);
            });

            // Sort arr2 based on the order in arr1
            const sortedResult = result.sort((a, b) => {
                const aIndex = orderMapping.hasOwnProperty(a._id) ? orderMapping[a._id.toString()] : Infinity;
                const bIndex = orderMapping.hasOwnProperty(b._id) ? orderMapping[b._id.toString()] : Infinity;
                return aIndex - bIndex;
            });

            res.json(sortedResult);
        } catch (error) {
            res.json({ message: error.message });
        }
    },

    // getMyPosts: async (req, res) => {
    //     const userId = req.user._id;
    //     const { limit } = req.query;
    //     const posts = await PostService.getMyPosts(limit);
    // },

    getAllPostFound: async (req, res) => {
        try {
            const userId = req.user._id;
            const user = await UserService.getUserInfo(userId);
            const posts = await PostService.getAllFound(user.postsFound);
            res.json(posts);
        } catch (error) {
            res.json({ message: error.message });
        }
    },

    getPost: async (req, res) => {
        try {
            const { id } = req.params;
            const post = await PostService.getOne(id);
            if (!post) {
                res.json({ message: "Post not found" });
                return;
            }
            const userId = req.user._id;

            const userInfo = await UserService.getUserInfo(userId);
            const postsUnlocked = userInfo.postsUnlocked;
            const postsArrived = userInfo.postsArrived;
            let result = post;

            if (postsUnlocked.includes(post._id)) {
                result = { ...post._doc, isUnlocked: true };
            } else {
                result = { ...post._doc, isUnlocked: false };
            }

            if (postsArrived.includes(post._id)) {
                result.isArrived = true;
            } else {
                result.isArrived = false
            }

            res.json(result);
        } catch (error) {
            res.json({ message: error.message });
        }
    },

    updatePost: async (req, res) => {
        try {
            const { id } = req.params;
            const { title, content, longitude, latitude, address, images, star } = req.body;
            const post = await PostService.update(id, { title, content, longitude, latitude, address, images, star });
            res.json(post);
        } catch (error) {
            res.json({ message: error.message });
        }
    },

    deletePost: async (req, res) => {
        try {
            const { id } = req.params;
            await PostService.delete(id);
            res.json({ message: "Post deleted" });
        } catch (error) {
            res.json({ message: error.message });
        }
    },

    getUnlockPost: async (req, res) => {
        try {
            const userId = req.user._id;
            const posts = await UserService.getUnlockPost(userId);
            res.json(posts);
        } catch (error) {
            res.json({ message: error.message });
        }
    },

    unlockPost: async (req, res) => {
        try {
            const { id } = req.params;
            const userId = req.user._id;
            const post = await PostService.getOne(id);
            if (!post) {
                res.json({ message: "Post not found" });
                return;
            }
            if (await UserService.getPoints(userId) < parseInt(process.env.COST_TO_UNLOCK_A_GEM)) {
                res.json({ message: "Not enough points" });
                return;
            }
            if (await UserService.unlockPost(id, userId) === true) {
                UserService.decreasePoints(userId, parseInt(process.env.COST_TO_UNLOCK_A_GEM));
            }
            res.json({ message: "Unlocked post" });
        } catch (error) {
            res.json({ message: error.message });
        }
    },

    markArrived: async (req, res) => {
        try {
            const { id } = req.params;
            const userId = req.user._id;
            const { longitude, latitude } = req.body;
            if (longitude === undefined || latitude === undefined) {
                res.json({ message: "Longitude and latitude are required" });
                return;
            }
            const post = await PostService.getOne(id);
            if (!post) {
                res.json({ message: "Post not found" });
                return;
            }

            const distance = await HaversineHelper.coordinatesToDistance(post.latitude, post.longitude, latitude, longitude);
            if (distance > parseInt(process.env.MAX_DISTANCE_TO_ARRIVE)) {
                res.json({ message: "Too far" });
                return;
            }

            const userInfo = await UserService.getUserInfo(userId);
            if (!userInfo.postsFound.includes(id)) {
                res.json({ message: "You have not found this post" });
                return;
            }
            await UserService.markArrived(id, userId);
            res.json({ message: "Marked arrived" });
        } catch (error) {
            res.json({ message: error.message });
        }
    }
};