part of 'speech_cubit.dart';

@immutable
abstract class SpeechState {}

class SpeechInitial extends SpeechState {}
class ChangeLangState extends SpeechState {}
class State1 extends SpeechState {}
class State2 extends SpeechState {}
class State3 extends SpeechState {}
class State4 extends SpeechState {}
class UploadAudioLoading extends SpeechState {}
class GetUserEmoji extends SpeechState {}
class ChooseAudioSuccess extends SpeechState {}
class ChooseLangModel extends SpeechState {}
class ChangePlayingState extends SpeechState {}
class StopRecorderState extends SpeechState {}


class GetFavItemsLoading extends SpeechState {}
class GetFavItemsSuccess extends SpeechState {}
class GetFavItemsError extends SpeechState {}

