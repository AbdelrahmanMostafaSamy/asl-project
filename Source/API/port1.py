import os
# os.environ['TF_ENABLE_ONEDNN_OPTS'] = '0'  # Disable XNNPACK

from flask import Flask, request
from flask_socketio import SocketIO
import cv2
import base64
import numpy as np
import mediapipe as mp
import tensorflow as tf
from collections import defaultdict

ACTIONS = ['بخير', 'كيف حالك', 'لا', "سؤال", 'سلام عليكم']

app = Flask(__name__)
socketio = SocketIO(app, cors_allowed_origins="*")

SEQUENCE_LENGTH = 30
FEATURE_SIZE = 1662

mp_holistic = mp.solutions.holistic
mp_drawing = mp.solutions.drawing_utils

# Load the model with compatibility fixes
model = tf.keras.models.load_model(r'C:\Users\Hamza\OneDrive\Desktop\action3.h5')

def mediapipe_detection(image, model):
    image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
    image.flags.writeable = False
    results = model.process(image)
    image.flags.writeable = True
    image = cv2.cvtColor(image, cv2.COLOR_RGB2BGR)
    return image, results

def extract_landmark_data(results):
    pose = np.array([[res.x, res.y, res.z, res.visibility] for res in results.pose_landmarks.landmark]).flatten() if results.pose_landmarks else np.zeros(33 * 4)
    face = np.array([[res.x, res.y, res.z] for res in results.face_landmarks.landmark]).flatten() if results.face_landmarks else np.zeros(468 * 3)
    left_hand = np.array([[res.x, res.y, res.z] for res in results.left_hand_landmarks.landmark]).flatten() if results.left_hand_landmarks else np.zeros(21 * 3)
    right_hand = np.array([[res.x, res.y, res.z] for res in results.right_hand_landmarks.landmark]).flatten() if results.right_hand_landmarks else np.zeros(21 * 3)
    features = np.concatenate([pose, face, left_hand, right_hand])
    if len(features) > FEATURE_SIZE:
        features = features[:FEATURE_SIZE]
    elif len(features) < FEATURE_SIZE:
        features = np.pad(features, (0, FEATURE_SIZE - len(features)))

    return features
user_sequences = defaultdict(list)

@socketio.on("video_stream")
def handle_video_stream(frame_data):
    sid = request.sid
    img_data = base64.b64decode(frame_data)
    np_arr = np.frombuffer(img_data, np.uint8)
    frame = cv2.imdecode(np_arr, cv2.IMREAD_COLOR)

    with mp_holistic.Holistic(min_detection_confidence=0.5, min_tracking_confidence=0.5) as holistic:
        image, results = mediapipe_detection(frame, holistic)
        keypoints = extract_landmark_data(results)

        user_sequences[sid].append(keypoints)
        user_sequences[sid] = user_sequences[sid][-SEQUENCE_LENGTH:]

        if len(user_sequences[sid]) == SEQUENCE_LENGTH:
            res = model.predict(np.expand_dims(user_sequences[sid], axis=0))[0]
            prediction = ACTIONS[np.argmax(res)]
            print(f"{sid}: {prediction}")
            socketio.emit("prediction", prediction, to=sid)

@socketio.on("disconnect", namespace="/motion_stream")
def handle_disconnect():
    sid = request.sid
    if sid in user_sequences:
        del user_sequences[sid]

if __name__ == "__main__":
    socketio.run(app, host="0.0.0.0", port=5001, debug=True)