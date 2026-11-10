
import os
from pathlib import Path

from google.oauth2.credentials import Credentials
from googleapiclient.discovery import build
from googleapiclient.http import MediaFileUpload

VIDEO_PATH = Path("video.mp4")

def main():
    if not VIDEO_PATH.exists():
        raise FileNotFoundError(
            "video.mp4 file repository mein nahi mili."
        )

    credentials = Credentials(
        None,
        refresh_token=os.environ["YOUTUBE_REFRESH_TOKEN"],
        token_uri="https://oauth2.googleapis.com/token",
        client_id=os.environ["YOUTUBE_CLIENT_ID"],
        client_secret=os.environ["YOUTUBE_CLIENT_SECRET"],
        scopes=[
            "https://www.googleapis.com/auth/youtube.upload"
        ],
    )

    youtube = build(
        "youtube",
        "v3",
        credentials=credentials
    )

    video = {
        "snippet": {
            "title": "Kids Rhymes - Demo Video",
            "description": (
                "Kids Rhymes channel demo upload."
            ),
            "categoryId": "22",
        },
        "status": {
            "privacyStatus": os.getenv(
                "VIDEO_PRIVACY", "unlisted"
            ),
            "selfDeclaredMadeForKids": True,
        },
    }

    media = MediaFileUpload(
        str(VIDEO_PATH),
        mimetype="video/mp4",
        resumable=True,
    )

    result = youtube.videos().insert(
        part="snippet,status",
        body=video,
        media_body=media,
    ).execute()

    print("Video uploaded successfully!")
    print("Video ID:", result["id"])


if __name__ == "__main__":
    main()
