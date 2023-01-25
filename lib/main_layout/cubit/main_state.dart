part of 'main_cubit.dart';

@immutable
abstract class MainState {}

class MainInitial extends MainState {}
class ChangeIndexState extends MainState {}
class PickeUserImageState extends MainState {}
class GetUserModelSuccess extends MainState {}
class ChangeSliderValueState extends MainState {}
class ChangeSound extends MainState {}
class AddAudioState extends MainState {}
class ChangeDurationState extends MainState {}
class ChangePostionDurationState extends MainState {}
class ChangeLangState extends MainState {}
class AddAudioToFavState extends MainState {}
class PlaySoundState extends MainState {}
class UpdateProfileInfo extends MainState {}
class initStatePlayingState extends MainState {}
class GetAllAudioListState extends MainState {}
