import vertexai
from vertexai.vision_models import (
    Image as VMImage,
    MultiModalEmbeddingModel,
    MultiModalEmbeddingResponse,
    Video as VMVideo,
    VideoSegmentConfig,
)
from vertexai.vision_models import MultiModalEmbeddingModel, Video
import requests
from typing import Any, Dict, Iterable, List, Optional, Tuple, Union
import os 
mm_embedding_model = MultiModalEmbeddingModel.from_pretrained("multimodalembedding")

def get_text_embedding(
    text: str = "banana muffins",
    dimension: Optional[int] = 1408,
) -> List[List[float]]:
    embedding = mm_embedding_model.get_embeddings(
            contextual_text=text,
        )
    return embedding.text_embedding

def get_image_embedding(
    image_url: str = None,
    image_path: str = None,
    dimension: Optional[int] = 1408,
) -> List[float]:
    try:
    # Send a GET request to the URL
        response = requests.get(image_url)
        # Check if the request was successful
        if response.status_code == 200:
            # Open a file in binary write mode
            with open("downloaded_image.jpg", "wb") as file:
                # Write the content of the response to the file
                file.write(response.content)
            print("Image successfully downloaded and saved!")
            image_path = "downloaded_image.jpg"
        else:
            print(f"Failed to download image. Status code: {response.status_code}")
    except requests.exceptions.RequestException as e:
        print(f"An error occurred: {e}")
    if not image_path:
        raise ValueError("Either image_path or image_url must be provided.")
    image = VMImage.load_from_file(image_path)
    embedding = mm_embedding_model.get_embeddings(
        image=image,
        dimension=dimension,
    )
    os.remove(image_path)
    return embedding.image_embedding

def get_video_embedding(
    video_path: str,
    dimension: Optional[int] = 1408,
    video_segment_config: Optional[VideoSegmentConfig] = None,
) -> List[float]:
    video = VMVideo.load_from_file(video_path)
    video_segment_config = VideoSegmentConfig(end_offset_sec=1)
    embedding = mm_embedding_model.get_embeddings(
        video=video,
        video_segment_config=video_segment_config,
    )
    return [video_emb.embedding for video_emb in embedding.video_embeddings]
# emb = get_video_embedding('test.mp4')
# print(len(emb[0]))