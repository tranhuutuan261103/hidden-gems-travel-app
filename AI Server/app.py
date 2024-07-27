from pydantic import BaseModel, HttpUrl, constr
import requests
from docarray import BaseDoc, DocList
from docarray.typing import NdArray
from fastapi import FastAPI, HTTPException
import torch
from docarray.index import HnswDocumentIndex
import os
import numpy as np
from VertexUtils import get_image_embedding, get_text_embedding, get_video_embedding
from typing import Optional, Literal
from GeminiUtils import download_video, process_video
from dotenv import load_dotenv
load_dotenv()
class Gems(BaseDoc):
    id: str
    text: Optional[str] = None
    img_url: Optional[str] = None
    video_url: Optional[str] = None
    embedding: NdArray[1408]
api_key = os.getenv('GEMINI_KEY')
# GemsList = DocList[Gems]([])
doc_index = HnswDocumentIndex[Gems](work_dir='./gems_multi')
GemsList = DocList[Gems].pull('file://gems_multi')
# print(GemsList.id)
GemsList.push('file://gems_multi')
app = FastAPI()
class ImageRequest(BaseModel):
    id: str
    urls: list[HttpUrl]

class VideoRequest(BaseModel):
    id: str
    urls: list[HttpUrl]
    
class TextRequest(BaseModel):
    id: str
    text: str 
@app.post("/upload_videos/")
async def upload_videos(request: VideoRequest):
    for url in request.urls:
        try:
            img_embs = get_video_embedding(url)
        except requests.exceptions.RequestException as e:
            raise HTTPException(status_code=400, detail=f"Error fetching image from URL {url}: {e}")
        img_embs = np.array(img_embs)
        for img_emb in img_embs : 
            gem_image = GemsList(
                id=request.id,
                video_url=str(url),
                embedding=img_emb
            )
            GemsList.append(gem_image)
    GemsList.push('file://gems_multi')
    doc_index = HnswDocumentIndex[Gems](work_dir='./gems_multi')
    doc_index.index(GemsList)
    return {"message": "Images processed and saved successfully"}

@app.post("/upload_images/")
async def upload_images(request: ImageRequest):
    for url in request.urls:
        try:
            img_emb = get_image_embedding(url)
        except requests.exceptions.RequestException as e:
            raise HTTPException(status_code=400, detail=f"Error fetching image from URL {url}: {e}")
        img_emb = np.array(img_emb)
        gem_image = Gems(
            id=request.id,
            img_url=str(url),
            embedding=img_emb
        )
        
        GemsList.append(gem_image)
    GemsList.push('file://gems_multi')
    doc_index = HnswDocumentIndex[Gems](work_dir='./gems_multi')
    doc_index.index(GemsList)
    return {"message": "Images processed and saved successfully"}

@app.post("/upload_text/")
async def upload_text(request: TextRequest):
    text_embs = get_text_embedding(request.text)
    text_embs = np.array(text_embs)
    for text_emb in text_embs : 
        gem_text = Gems(
                id=request.id,
                text=request.text,
                embedding=text_emb
            )
            
        GemsList.append(gem_text)
    GemsList.push('file://gems_multi')
    doc_index = HnswDocumentIndex[Gems](work_dir='./gems_multi')
    doc_index.index(GemsList)
    return {"message": "Text processed and saved successfully"}


class RetrieveRequest(BaseModel):
    img_url: Optional[HttpUrl] = None
    url: Optional[str] = None
    text: Optional[str] = None
    type: Literal['image', 'video', 'text', 'platform']

@app.post("/retrieve/")
async def retrieve(request: RetrieveRequest):
    embedding = None
    try:
        if request.type == 'image' and request.img_url:
            embedding = get_image_embedding(image_url = request.img_url)
        elif request.type == 'video' and request.url:
            embedding = get_video_embedding(request.url)
        elif request.type == 'platform' and request.url:
            output_path = "downloaded_video.mp4"
            download_video(request.url, output_path)
            info = process_video('AIzaSyDmLyivkztEpNNlFG9Ly06oCotkW2ZJ8EE', output_path)
            os.remove(output_path)
            return info 
        elif request.type == 'text' and request.text:
            embedding = get_text_embedding(request.text)
        else:
            raise HTTPException(status_code=400, detail="Invalid request data")

        embedding = np.array(embedding)
        doc_index = HnswDocumentIndex[Gems](work_dir='./gems_multi')
        print(embedding.shape)
        matches, scores = doc_index.find(embedding, search_field='embedding', limit=10)
        matched_ids = [match.id for match in matches]
        return {"matches": matched_ids, "scores": scores}
    except requests.exceptions.RequestException as e:
        raise HTTPException(status_code=400, detail=f"Error processing request: {e}")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Internal server error: {e}")

if __name__ == "__main__":
    import uvicorn
    import sys
    import asyncio

    if "pytest" in sys.modules:
        asyncio.run(uvicorn.run(app, host="0.0.0.0", port=8000))
    else:
        uvicorn.run(app, host="0.0.0.0", port=8000)