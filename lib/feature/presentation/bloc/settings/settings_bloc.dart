import 'package:bloc/bloc.dart';
import '../../../domain/repository/settings/settings_repository.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({required this.settingsRepo}) : super(const SettingsState()) {
    on<UpdateSessionEvent>(_mapUpdateSettingsEventToState);
    on<GetSessionEvent>(_mapGetSettingsEventToState);
  }

  final SettingsRepository settingsRepo;

  void _mapUpdateSettingsEventToState(
      UpdateSessionEvent event, Emitter<SettingsState> emit) async {
    emit(state.copyWith(
      status: SettingsStates.loading,
    ));
    await settingsRepo
        .updateSettings(settingsModel: event.settingsModel)
        .then((result) {
      result.fold((l) {
        emit(
          state.copyWith(
            status: SettingsStates.failure,
            settingsModel: event.settingsModel,
            error: l,
          ),
        );
      }, (r) {
        emit(
          state.copyWith(
              status: SettingsStates.success,
              settingsModel: event.settingsModel),
        );
      });
    });
  }

  void _mapGetSettingsEventToState(
      GetSessionEvent event, Emitter<SettingsState> emit) async {
    emit(state.copyWith(
      status: SettingsStates.loading,
    ));
    await settingsRepo.getSetting().then((result) {
      result.fold((l) {
        emit(
          state.copyWith(
            status: SettingsStates.failure,
            settingsModel: state.settingsModel,
            error: l,
          ),
        );
      }, (r) {
        emit(
          state.copyWith(status: SettingsStates.success, settingsModel: r),
        );
      });
    });
  }
}
