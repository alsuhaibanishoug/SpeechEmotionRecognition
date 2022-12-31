import flask
import os
import numpy as np
import pandas as pd
import tensorflow as tf
import numpy as np
import librosa
import soundfile as sf

from sklearn.preprocessing import OneHotEncoder
from flask import request , render_template
from pydub import AudioSegment
from playsound import playsound 
from IPython.display import Audio



app = flask.Flask(__name__)
app.config["DEBUG"] = True

#logic starts
def extract_features(data, sample_rate, frame_length=2048, hop_length=512):
    # ZCR
    result = np.array([])
    zcr = np.mean(librosa.feature.zero_crossing_rate(y=data).T, axis=0)
    result=np.hstack((result, zcr)) # stacking horizontally

    # Chroma_stft
    stft = np.abs(librosa.stft(data))
    chroma_stft = np.mean(librosa.feature.chroma_stft(S=stft, sr=sample_rate).T, axis=0)
    result = np.hstack((result, chroma_stft)) # stacking horizontally

    # MFCC
    mfcc = np.mean(librosa.feature.mfcc(y=data, sr=sample_rate).T, axis=0)
    result = np.hstack((result, mfcc)) # stacking horizontally

    # Root Mean Square Value
    rms = np.mean(librosa.feature.rms(y=data).T, axis=0)
    result = np.hstack((result, rms)) # stacking horizontally

    # MelSpectogram
    mel = np.mean(librosa.feature.melspectrogram(y=data, sr=sample_rate).T, axis=0)
    result = np.hstack((result, mel)) # stacking horizontally
    
    return result

def get_features(path):
     # duration and offset are used to take care of the no audio in start and the ending of each audio files as seen above.
    data, sample_rate = librosa.load(path, offset=0.4)
    sf.write('ang.wav', data, sample_rate, format='wav')
    data = data.T
    
    res1 = extract_features(data,sample_rate)
    result = np.array(res1)
    
    return result

def checker(sent_audio):
    
    msg=get_features(sent_audio)
    
    Y=['angry', 'fear', 'happy', 'neutral', 'sad', 'surprise']
    encoder = OneHotEncoder()
    Y = encoder.fit_transform(np.array(Y).reshape(-1,1)).toarray()


    data = pd.DataFrame(msg)
    data = np.expand_dims(data, axis=0)
    data.shape
    

    model = tf.keras.models.load_model("6_Emotion_Model_new_cnn_50.h5")
    emo=encoder.inverse_transform(model.predict(data))

    return emo
	



@app.route('/', methods=['GET','POST'])
def home():
    
    if request.method == 'POST':
        uploaded_file = request.files['file']
        if uploaded_file != '':
            _, ext = os.path.splitext(uploaded_file.filename)
            if ext == ".mp3":
                sound = AudioSegment.from_mp3(uploaded_file)
                wav_form = sound.export(format="wav") 
                uploaded_file = wav_form
            elif ext == '.avi':
                sound = AudioSegment.from_file(uploaded_file, 'avi')
                wav_form = sound.export(format="wav") 
                uploaded_file = wav_form     
        
            
            return print(checker(uploaded_file))
 
    return render_template('index.html')

app.run()