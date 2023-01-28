import flask
import os
import pandas as pd
import tensorflow as tf
import numpy as np
import librosa
from flask import request , render_template
from pydub import AudioSegment
#pip install speechrecognition
import speech_recognition as Speech 
from pydub.silence import split_on_silence
#pip install arabic_reshaper 
import arabic_reshaper
#pip install python-bidi
from bidi.algorithm import get_display


app = flask.Flask(__name__, template_folder='template')
app.config["DEBUG"] = True

# create a speech recognition object
Speech_Recognition = Speech.Recognizer()


#logic starts
def extract_features(data, sample_rate):
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
    data, sample_rate = librosa.load(path, sr=None, offset=0.4)
    data = data.T
    
    result = extract_features(data,sample_rate)
    
    return result

def checker(sent_audio):
    
    msg = get_features(sent_audio)

    data = pd.DataFrame(msg)
    data = np.expand_dims(data, axis=0)

    model = tf.keras.models.load_model("5_Emotion_Model_cnn_87.h5", compile=False)
    prediction= model.predict(data)

    all_emotion=[str(100*np.max(n)) for n in prediction[0]]
    all_emotion=dict(enumerate(all_emotion))

    classnames={0:'angry',1:'happy',2:'neutral',3:'sad',4:'surprise'}
    all_emotion=dict((classnames[key], value) for (key, value) in all_emotion.items())

    return all_emotion
	
# a function that splits the audio file into chunks
# and applies speech recognition
def audio_transcription(path, lang):
 
    # open the audio file using pydub
    sound = AudioSegment.from_wav(path)  
    # split audio sound where silence is 1 second or more and get chunks
    chunks = split_on_silence(sound,
                              min_silence_len = 1000,
                              silence_thresh = sound.dBFS-14,
                              keep_silence=200)
    
    folder_name = "audio-chunks"
    # create a directory to store the audio chunks
    if not os.path.isdir(folder_name):
        os.mkdir(folder_name)
    whole_text = ""
    # process each chunk 
    for i, audio_chunk in enumerate(chunks, start=1):
        # export audio chunk and save it in
        # the `folder_name` directory.
        chunk_filename = os.path.join(folder_name, f"chunk{i}.wav")
        audio_chunk.export(chunk_filename, format="wav")
        # recognize the chunk
        with Speech.AudioFile(chunk_filename) as source:
            audio_listened = Speech_Recognition.record(source)
            # try converting it to text
            try:
                if(lang == 'ar'):
                    text = Speech_Recognition.recognize_google(audio_listened, language = 'ar-SA')
                else:
                    text = Speech_Recognition.recognize_google(audio_listened)
            except Speech.UnknownValueError as e:
                print("Error:", str(e))
            else:
                text = f"{text.capitalize()}. "
                whole_text += text
    
    if(lang == 'ar'):
        reshaped_text = arabic_reshaper.reshape(whole_text)    # correct its shape
        whole_text = get_display(reshaped_text)                # correct its direction

    return whole_text


@app.route('/', methods=['GET','POST'])
def home():
    
    if 'file' in request.files:
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
            elif ext == '.m4a':    
                sound = AudioSegment.from_file(uploaded_file, 'm4a')
                wav_form = sound.export(format="wav") 
                uploaded_file = wav_form     
            
            responce = checker(uploaded_file)
            
            if _ == 'ar':
                text = audio_transcription(uploaded_file, 'ar')
            else:
                text = audio_transcription(uploaded_file, 'en')
            
            responce['text']= text

            return responce

    return render_template('index.html')

app.run()
