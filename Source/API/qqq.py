from flask import Flask, render_template, redirect, url_for, request, send_file, session, Response, jsonify
from flask_sqlalchemy import SQLAlchemy
import os
import base64
from uuid import uuid4
import numpy as np
import cv2
import keras
from keras.models import load_model
from keras.preprocessing import image
import mediapipe as mp
import datetime
import random
import joblib
from PIL import Image
from shortuuid import uuid
import tempfile

os.chdir(os.path.dirname(os.path.abspath(__file__)))

_db = SQLAlchemy()

app = Flask(__name__)
app.secret_key = "9g8j4538gjsdfjg94"
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///' + os.path.join(app.root_path, 'database.sqlite3')
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = True
app.config['UPLOAD_FOLDER'] = 'static/profile_images'
os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)
os.chdir(os.path.dirname(os.path.abspath(__file__)))

mp_hands = mp.solutions.hands
hands = mp_hands.Hands(static_image_mode=True, max_num_hands=1, min_detection_confidence=0.5)

model = load_model("asl_model7.h5")

folders = {
    "Alif": "أ",
    "Ayn": "ع",
    "Ba": "ب",
    "Dad": "ض",
    "Dal": "د",
    "Dhal": "ذ",
    "Fa": "ف",
    "Ghayn": "غ",
    "Ha": "ح",
    "Hah":"ه",
    "Jeem": "ج",
    "Kaf": "ك",
    "Kha": "خ",
    "Lam": "ل",
    "Meem": "م",
    "Noon": "ن",
    "Qaf": "ق",
    "Ra": "ر",
    "Sad": "ص",
    "Seen": "س",
    "Sheen": "ش",
    "Ta": "ت",
    "Tah": "ط",
    "Tha": "ث",
    "Waw": "و",
    "Ya": "ي",
    "Zah": "ظ",
    "Zay": "ز"
}

class Account(_db.Model):
    __tablename__ = 'accounts'
    id = _db.Column(_db.Integer, primary_key=True)
    username = _db.Column(_db.String(100), nullable=False)
    email = _db.Column(_db.String(100), nullable=False)
    password = _db.Column(_db.String(100), nullable=False)
    history = _db.Column(_db.String(2000), nullable=False)
    learn_progress = _db.Column(_db.String(2000), nullable=False)
    image_path = _db.Column(_db.String(200), nullable=True)

_db.init_app(app)
with app.app_context():
    _db.create_all()

def detect_and_crop_hand(frame):
    """Detects and crops the hand from the frame."""
    img_rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
    results = hands.process(img_rgb)
    
    if results.multi_hand_landmarks:
        for hand_landmarks in results.multi_hand_landmarks:
            h, w, _ = frame.shape
            x_min, y_min, x_max, y_max = w, h, 0, 0
            
            for lm in hand_landmarks.landmark:
                x, y = int(lm.x * w), int(lm.y * h)
                x_min, y_min = min(x_min, x), min(y_min, y)
                x_max, y_max = max(x_max, x), max(y_max, y)

            # إضافة هوامش حول اليد
            padding = 20
            x_min, y_min = max(0, x_min - padding), max(0, y_min - padding)
            x_max, y_max = min(w, x_max + padding), min(h, y_max + padding)

            print(f"Detected Hand at: ({x_min}, {y_min}), ({x_max}, {y_max})")  # تتبع الأبعاد

            hand_crop = frame[y_min:y_max, x_min:x_max]
            if hand_crop.shape[0] > 0 and hand_crop.shape[1] > 0:
                hand_crop = cv2.resize(hand_crop, (224, 224))
                im = hand_crop
                return hand_crop
    
    print("[ERROR] No hand detected")
    return None

def predict_sign(frame):
    """Predicts the sign from the cropped hand."""
    cropped_hand = detect_and_crop_hand(frame)
    if cropped_hand is None:
        print("[ERROR] No hand detected in predict_sign()")
        return None

    # تحويل الصورة إلى مصفوفة وإجراء التنبؤ
    img_array = image.img_to_array(cropped_hand) / 255.0
    img_array = np.expand_dims(img_array, axis=0)

    predictions = model.predict(img_array)
    class_index = np.argmax(predictions)

    print(f"Prediction index: {class_index}")
    
    return folders.get(list(folders.keys())[class_index], None)

@app.route('/predict', methods=['POST'])
def predict_page():
    try:
        data = request.json.get('image')
        user_id = request.json.get('id')
        user = Account.query.filter_by(id=user_id).first()
        
        if not user:
            return jsonify({'error': 'User not found'}), 404
        if not data:
            return jsonify({'error': 'No image'}), 400

        # فك تشفير الصورة من Base64
        image_data = base64.b64decode(data)
        np_image = np.frombuffer(image_data, np.uint8)
        frame = cv2.imdecode(np_image, cv2.IMREAD_COLOR)
        
        os.makedirs(os.path.join("static", "prediction_images"), exist_ok=True)  # إنشاء الدليل إذا لم يكن موجودًا
        image_path = os.path.join("prediction_images", f"{uuid4().hex}.png").replace("\\", "/")  # تحويل \ إلى /
        cv2.imwrite(os.path.join("static", image_path.replace("/", "\\")), frame)

        if frame is None:
            return jsonify({'error': 'Failed to decode image'}), 400

        # محاولة التنبؤ
        prediction = predict_sign(frame)

        if prediction is None:
            print("[ERROR] No valid prediction")
            return jsonify({'error': 'No hand detected'}), 400
        
        # حفظ الصورة
        os.makedirs(os.path.join("static", "prediction_images"), exist_ok=True)  # إنشاء الدليل إذا لم يكن موجودًا
        image_path = os.path.join("prediction_images", f"{uuid4().hex}.png").replace("\\", "/")  # تحويل \ إلى /
        cv2.imwrite(os.path.join("static", image_path.replace("/", "\\")), frame)  # استخدام \ لحفظ الملف على ويندوز
        
        his = eval(user.history)
        if request.json.get("type") == "Sign Language To Words":
            his.append({
                "id": len(his) + 1,
                "date": datetime.datetime.now().strftime("%d-%m-%Y %H:%M"),
                "prediction": prediction,
                "type": "Sign Language To Words",
                "image": url_for('static', filename=image_path, _external=True)  # استخدام url_for بشكل صحيح
            })
        
        user.history = str(his)
        _db.session.commit()
        
        return jsonify({'prediction': prediction}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route("/ajax/signup", methods=["POST"])
def back_signup():
    username = request.json["username"]
    email = request.json["email"]
    password = request.json["password"]
    image_base = request.json.get("image_base")
    if not all([username, email, password]):
        return jsonify({"error": "All fields are required"}), 400
    if Account.query.filter_by(username=username).first() or Account.query.filter_by(email=email).first():
        return jsonify({"error": "Username or email already exists"}), 400
    if image_base != None:
        image_filename = f"{uuid4().hex}.png"
        image_path = os.path.join(app.config['UPLOAD_FOLDER'], image_filename)
        with open(image_path, "wb") as f:
            f.write(base64.b64decode(image_base))
    else:
        image_filename = None
    new_acc = Account(
        username=username, email=email, password=password, image_path=image_filename,
        history="[]", learn_progress='[{"Name":"أ","Description":"حرف أ هو أول حروف اللغة العربية","Done":"None"},{"Name":"ب","Description":"حرف ب هو ثاني حروف اللغة العربية","Done":"None"},{"Name":"ت","Description":"حرف ت هو ثالث حروف اللغة العربية","Done":"None"},{"Name":"ث","Description":"حرف ث هو رابع حروف اللغة العربية","Done":"None"},{"Name":"ج","Description":"حرف ج هو خامس حروف اللغة العربية","Done":"None"},{"Name":"ح","Description":"حرف ح هو سادس حروف اللغة العربية","Done":"None"},{"Name":"خ","Description":"حرف خ هو سابع حروف اللغة العربية","Done":"None"},{"Name":"د","Description":"حرف د هو ثامن حروف اللغة العربية","Done":"None"},{"Name":"ذ","Description":"حرف ذ هو تاسع حروف اللغة العربية","Done":"None"},{"Name":"ر","Description":"حرف ر هو عاشر حروف اللغة العربية","Done":"None"},{"Name":"ز","Description":"حرف ز هو الحرف الحادي عشر في اللغة العربية","Done":"None"},{"Name":"س","Description":"حرف س هو الحرف الثاني عشر في اللغة العربية","Done":"None"},{"Name":"ش","Description":"حرف ش هو الحرف الثالث عشر في اللغة العربية","Done":"None"},{"Name":"ص","Description":"حرف ص هو الحرف الرابع عشر في اللغة العربية","Done":"None"},{"Name":"ض","Description":"حرف ض هو الحرف الخامس عشر في اللغة العربية","Done":"None"},{"Name":"ط","Description":"حرف ط هو الحرف السادس عشر في اللغة العربية","Done":"None"},{"Name":"ظ","Description":"حرف ظ هو الحرف السابع عشر في اللغة العربية","Done":"None"},{"Name":"ع","Description":"حرف ع هو الحرف الثامن عشر في اللغة العربية","Done":"None"},{"Name":"غ","Description":"حرف غ هو الحرف التاسع عشر في اللغة العربية","Done":"None"},{"Name":"ف","Description":"حرف ف هو الحرف العشرون في اللغة العربية","Done":"None"},{"Name":"ق","Description":"حرف ق هو الحرف الحادي والعشرون في اللغة العربية","Done":"None"},{"Name":"ك","Description":"حرف ك هو الحرف الثاني والعشرون في اللغة العربية","Done":"None"},{"Name":"ل","Description":"حرف ل هو الحرف الثالث والعشرون في اللغة العربية","Done":"None"},{"Name":"م","Description":"حرف م هو الحرف الرابع والعشرون في اللغة العربية","Done":"None"},{"Name":"ن","Description":"حرف ن هو الحرف الخامس والعشرون في اللغة العربية","Done":"None"},{"Name":"ه","Description":"حرف ه هو الحرف السادس والعشرون في اللغة العربية","Done":"None"},{"Name":"و","Description":"حرف و هو الحرف السابع والعشرون في اللغة العربية","Done":"None"},{"Name":"ي","Description":"حرف ي هو الحرف الثامن والعشرون في اللغة العربية","Done":"None"}]'
    )
    _db.session.add(new_acc)
    _db.session.commit()
    return jsonify({'message': 'Account created'}), 200

@app.route("/ajax/login", methods=["POST"])
def back_login():
    r = request.json
    user = Account.query.filter_by(email=r["email"]).first()
    if user:
        if r["password"] == user.password:
            url = url_for('static', filename=f'profile_images/{user.image_path}', _external=True) if user.image_path else None
            return jsonify({'message': 'Correct', "id": user.id, "username": user.username, "email": user.email, "pfp_url": url}), 200
        else:
            return jsonify({'message': 'Wrong password'}), 401
    else:
        return jsonify({'message': 'Not found'}), 404

@app.route("/ajax/accountdata", methods=["GET"])
def back_getaccountdata():
    r = request.json
    if "id" in r.keys():
        user = Account.query.filter_by(id=r["id"]).first()
    elif "email" in r.keys():
        user = Account.query.filter_by(email=r["email"]).first()
    elif "username" in r.keys():
        user = Account.query.filter_by(username=r["username"]).first()
    if not user:
        return jsonify({'message': 'Not found'}), 404
    url = url_for('static', filename=f'profile_images/{user.image_path}', _external=True) if user.image_path else None
    return jsonify({'message': 'Correct', "id": user.id, "username": user.username, "email": user.email, "pfp_url": url}), 200

@app.route("/ajax/learn", methods=["POST"])
def back_learn_feature():
    userid = request.json["id"]
    letter = request.json["letter"]
    done_status = request.json["done"]
    user = Account.query.filter_by(id=userid).first()
    if not user:
        return jsonify({'message': 'Not found'}), 404
    prog = eval(user.learn_progress)
    for item in prog:
        if item["Name"] == letter:
            item["Done"] = done_status
    user.learn_progress = str(prog)
    _db.session.commit()
    return jsonify({'message': 'Correct'}), 200

@app.route("/ajax/reset_learn", methods=["POST"])
def back_reset_learn():
    userid = request.json["id"]
    letter = request.json["letter"]
    user = Account.query.filter_by(id=userid).first()
    if not user:
        return jsonify({'message': 'Not found'}), 404
    prog = eval(user.learn_progress)
    for item in prog:
        if item["Name"] == letter:
            item["Done"] = "None"
    user.learn_progress = str(prog)
    _db.session.commit()
    return jsonify({'message': 'Reset Success'}), 200

@app.route("/ajax/clear_all_letters", methods=["POST"])
def back_clear_all_letters():
    userid = request.json["id"]
    user = Account.query.filter_by(id=userid).first()
    if not user:
        return jsonify({'message': 'User not found'}), 404
    prog = eval(user.learn_progress)
    for item in prog:
        item["Done"] = "None"
    user.learn_progress = str(prog)
    _db.session.commit()
    return jsonify({'message': 'All letters cleared successfully'}), 200

@app.route("/ajax/delete_history_item", methods=["POST"])
def back_delete_history_item():
    user = Account.query.filter_by(id=request.json.get("id")).first()
    if not user:
        return jsonify({'message': 'User not found'}), 404
    his = eval(user.history)
    history_id = request.json.get("history_id")
    his = [entry for entry in his if entry["id"] != history_id]
    user.history = str(his)
    _db.session.commit()
    return jsonify({'message': 'History item deleted successfully'}), 200

@app.route("/ajax/clear_all_history", methods=["POST"])
def back_clear_all_history():
    user = Account.query.filter_by(id=request.json.get("id")).first()
    if not user:
        return jsonify({'message': 'User not found'}), 404
    user.history = "[]"
    _db.session.commit()
    return jsonify({'message': 'All history cleared successfully'}), 200

@app.route("/ajax/get_user_history", methods=["POST"])
def back_get_history():
    user = Account.query.filter_by(id=request.json.get("id")).first()
    if not user:
        return jsonify({'message': 'Not found'}), 404
    return jsonify({'message': 'Correct', "data": eval(user.history)}), 200

@app.route("/ajax/get_user_progress", methods=["POST"])
def back_get_progress():
    user = Account.query.filter_by(id=request.json.get("id")).first()
    if not user:
        return jsonify({'message': 'Not found'}), 404
    return jsonify({'message': 'Correct', "data": eval(user.learn_progress)}), 200

from flask import url_for

def generate_gif(sentence):
    """Generate a GIF from words in a sentence using available images."""
    
    try:
        letter_dir = "./static/letters/"
        available_files = {os.path.splitext(f)[0]: f for f in os.listdir(letter_dir)}
        sorted_keys = sorted(available_files.keys(), key=len, reverse=True)

        sentence = sentence.lower()
        image_files = []
        notfound = []
        used_words = set()

        for phrase in sorted_keys:
            if phrase in sentence and phrase not in used_words:
                image_files.append(os.path.join(letter_dir, available_files[phrase]))
                sentence = sentence.replace(phrase, "", 1).strip()
                used_words.add(phrase)

        for word in sentence.split():
            if word in available_files and word not in used_words:
                image_files.append(os.path.join(letter_dir, available_files[word]))
            else:
                notfound.append(word)

        if notfound:
            return jsonify({'message': f"{', '.join(notfound)} not in the database."}), 204

        images = [Image.open(img).convert("RGBA") for img in image_files[::-1]]
        file_name = f"signlanguage_gifs/{uuid4().hex[:6]}.gif"
        file_path = f"./static/{file_name}"
        images[0].save(file_path, save_all=True, append_images=images[1:], duration=500, loop=0)

        # Return the full URL instead of just the relative path
        file_url = url_for('static', filename=file_name, _external=True)
        return file_url  # Now returns a full URL
    except:
        return "ERROR"

@app.route("/ajax/text_to_signlanguage", methods=["POST"])
def text_to_signlanguage():
    user = Account.query.filter_by(id=request.json.get("id")).first()
    if not user:
        return jsonify({'message': 'Not found'}), 404
    
    sentence = request.json.get("sentence")
    file_url = generate_gif(sentence)
    if file_url == "ERROR":
        return

    his = eval(user.history)
    his.append({
        "id": len(his) + 1,
        "date": datetime.datetime.now().strftime("%d-%m-%Y %H:%M"),
        "prediction": sentence,
        "type": "Words To Sign Language",
        "image": file_url  # Store full URL
    })
    user.history = str(his)
    _db.session.commit()

    return jsonify({'message': 'Correct', 'file_name': file_url}), 200
@app.route("/ajax/get_saved_letters", methods=["GET"])
def back_get_supported_letters():
    letters = []

    for file in os.listdir("./static/letters/"):
        letters.append([file.split(".")[0], url_for('static', filename=f'letters/{file}', _external=True)])

    return jsonify({'message': 'Correct', 'data':letters}), 200

SEQUENCE_LENGTH = 30
FEATURE_SIZE = 1662
MOTION_ACTIONS = ['بخير','كيف حالك','لا',"سؤال",'سلام عليكم']

mp_holistic = mp.solutions.holistic

motion_model = keras.models.load_model('action3.h5')

def midapipe_detection(image, model):
    image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
    image.flags.writeable = False
    results = model.process(image)
    return results

def extract_landmark_data(results: mp_holistic.Holistic):  # type: ignore
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

def process_video(video_path):
    cap = cv2.VideoCapture(video_path)
    sequence = []
    detected_action = None

    with mp_holistic.Holistic(min_detection_confidence=0.5, min_tracking_confidence=0.5) as holistic:
        while cap.isOpened():
            ret, frame = cap.read()
            if not ret:
                break

            results = midapipe_detection(frame, holistic)
            keypoints = extract_landmark_data(results)
            sequence.append(keypoints)

            sequence = sequence[-SEQUENCE_LENGTH:]

            if len(sequence) == SEQUENCE_LENGTH:
                res = motion_model.predict(np.expand_dims(sequence, axis=0))[0]
                detected_action = MOTION_ACTIONS[np.argmax(res)]
                break

    cap.release()

    if detected_action:
        return {'message': 'Correct', 'prediction': detected_action}, 200
    else:
        return {'error': "No action detected"}, 200

@app.route('/predict_motion', methods=['POST'])
def predictmotion_page():
    if 'video' not in request.files:
        return jsonify({'error': 'No video uploaded'}), 400

    video = request.files['video']

    with tempfile.NamedTemporaryFile(dir=os.path.abspath("tempfolder"), delete=False, suffix=".mp4") as temp_video:
        video_path = temp_video.name
        video.save(video_path)
    response, status_code = process_video(video_path)
    os.remove(video_path)

    return jsonify(response), status_code





if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0' ,port=5000)