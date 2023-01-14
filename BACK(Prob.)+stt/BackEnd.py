import flask
import os
import pandas as pd
import tensorflow as tf
import numpy as np
import librosa
from sklearn.preprocessing import OneHotEncoder
from flask import request , render_template
from pydub import AudioSegment
#pip install speechrecognition
import speech_recognition as sr 
from pydub.silence import split_on_silence
#pip install arabic_reshaper 
import arabic_reshaper
#pip install python-bidi
from bidi.algorithm import get_display




app = flask.Flask(__name__, template_folder='template')
app.config["DEBUG"] = True

# create a speech recognition object
r = sr.Recognizer()


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
    data, sample_rate = librosa.load(path, offset=0.4)
    #sf.write('ang.wav', data, sample_rate, format='wav')
    data = data.T
    
    res1 = extract_features(data,sample_rate)
    result = np.array(res1)
    
    return result

def checker(sent_audio):
    
    msg=get_features(sent_audio)
    
    Y=['angry', 'happy', 'neutral', 'sad', 'surprise']
    encoder = OneHotEncoder()
    Y = encoder.fit_transform(np.array(Y).reshape(-1,1)).toarray()


    data = pd.DataFrame(msg)
    data = np.expand_dims(data, axis=0)
    data.shape

    model = tf.keras.models.load_model("5__Emotion_Model_new_cnn_83_acc.h5")
    prediction= model.predict(data)
    emo=encoder.inverse_transform(prediction)


    all_emotion=[100*np.max(n) for n in prediction[0]]
    all_emotion=dict(enumerate(all_emotion))

    classnames={0:'angry',1:'happy',2:'neutral',3:'sad',4:'surprise'}
    all_emotion=dict((classnames[key], value) for (key, value) in all_emotion.items())

    return all_emotion
	
# a function that splits the audio file into chunks
# and applies speech recognition
def get_large_audio_transcription(path, lang):
    """
    Splitting the large audio file into chunks
    and apply speech recognition on each of these chunks
    """
    # open the audio file using pydub
    sound = AudioSegment.from_wav(path)  
    # split audio sound where silence is 700 miliseconds or more and get chunks
    chunks = split_on_silence(sound,
        # experiment with this value for your target audio file
        min_silence_len = 500,
        # adjust this per requirement
        silence_thresh = sound.dBFS-14,
        # keep the silence for 1 second, adjustable as well
        keep_silence=500,
    )
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
        with sr.AudioFile(chunk_filename) as source:
            audio_listened = r.record(source)
            # try converting it to text
            try:
                if(lang == 'ar'):
                    text = r.recognize_google(audio_listened, language = 'ar-SA')
                else:
                    text = r.recognize_google(audio_listened)
            except sr.UnknownValueError as e:
                print("Error:", str(e))
            else:
                text = f"{text.capitalize()}. "
                #print(chunk_filename, ":", text)
                whole_text += text
    
    if(lang == 'ar'):
        reshaped_text = arabic_reshaper.reshape(whole_text)    # correct its shape
        whole_text = get_display(reshaped_text)                # correct its direction

    # return the text for all chunks detected
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
                text = get_large_audio_transcription(uploaded_file, 'ar')
            else:
                text = get_large_audio_transcription(uploaded_file, 'en')
            
            responce['text']= text

            return responce

    return render_template('index.html')

app.run()