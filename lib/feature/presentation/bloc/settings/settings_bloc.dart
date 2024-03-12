import 'package:bloc/bloc.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../domain/usecase/get_settings/get_settings.dart';
import '../../../domain/usecase/update_settings/update_settings.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({required this.updateSettings, required this.getSettings})
      : super(const SettingsState()) {
    on<UpdateSessionEvent>(_mapUpdateSettingsEventToState);
    on<GetSessionEvent>(_mapGetSettingsEventToState);
  }

  UpdateSettings updateSettings;
  GetSettings getSettings;

  void _mapUpdateSettingsEventToState(
      UpdateSessionEvent event, Emitter<SettingsState> emit) async {
    emit(state.copyWith(
      status: SettingsStates.loading,
    ));
    await updateSettings
        .call(ParamsUpdateSettings(settings: event.settingsModel))
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
    await getSettings.call(NoParams()).then((result) {
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
