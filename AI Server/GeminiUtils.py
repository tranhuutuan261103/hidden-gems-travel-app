import google.generativeai as genai
import time
import json
import yt_dlp
import os 
def download_video(url, output_path):
    ydl_opts = {
        'format': 'best',
        'noplaylist': True,
        'outtmpl': output_path 
    }
    with yt_dlp.YoutubeDL(ydl_opts) as ydl:
        ydl.download([url])

def configure_genai(api_key):
    genai.configure(api_key=api_key)

def upload_video(file_path):
    print(f"Uploading file...")
    video_file = genai.upload_file(path=file_path)
    print(f"Completed upload: {video_file.uri}")
    return video_file

def wait_for_processing(video_file):
    while video_file.state.name == "PROCESSING":
        print('.', end='')
        time.sleep(10)
        video_file = genai.get_file(video_file.name)
    if video_file.state.name == "FAILED":
        raise ValueError(video_file.state.name)
    return video_file

def make_llm_request(video_file):
    prompt = (
        "Please analyze the video and provide the following information in JSON format:\n"
        "{\n"
        "  \"Địa điểm\": \"...\",\n"
        "  \"Mô tả\": \"...\",\n"
        "  \"Keywords\": [...]\n"
        "}\n"
    )
    model = genai.GenerativeModel(model_name="gemini-1.5-pro-latest")
    print("Making LLM inference request...")
    response = model.generate_content([prompt, video_file], request_options={"timeout": 600})
    return response

def extract_info_from_response(response):
    try:
        result = response.text
        first_sign = result.find('{')
        last_sign = result.find('}')
        result = result[first_sign:last_sign + 1]
        video_info = json.loads(result)
        
        extracted_info = {
            "Địa điểm": video_info.get("Địa điểm", ""),
            "Mô tả": video_info.get("Mô tả", ""),
            "Keywords": video_info.get("Keywords", [])
        }
        return extracted_info

    except json.JSONDecodeError:
        print("Error: Unable to decode the response into JSON.")
        print("Response text:")
        print(result)
        return None
    except Exception as e:
        print(f"Error during API request: {e}")
        return None

def process_video(api_key, file_path):
    configure_genai(api_key)
    video_file = upload_video(file_path)
    video_file = wait_for_processing(video_file)
    response = make_llm_request(video_file)
    extracted_info = extract_info_from_response(response)
    return extracted_info

# if __name__ == "__main__":
#     api_key = "AIzaSyDmLyivkztEpNNlFG9Ly06oCotkW2ZJ8EE"
    
#     url = "https://www.tiktok.com/@nglethuthuy/video/7377337106269539600?q=%C4%91%C3%A0%20n%E1%BA%B5ng&t=1722065442069"

#     output_path = "downloaded_video.mp4"
    
#     download_video(url, output_path)
    
#     info = process_video(api_key, output_path)
#     os.remove(output_path)
    
#     if info:
#         print("\nExtracted Info as Dictionary:")
#         print(info)
#     else:
#         print("Failed to extract information.")