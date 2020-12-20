import 'package:bloc/bloc.dart';

class TableZoomCubit extends Cubit<double> {
  TableZoomCubit() : super(1.0);

  double zoomLevel = 1.0;
  void setZoomLevel(double zoomLevel){
    this.zoomLevel = zoomLevel;
    emit(zoomLevel);
  }
}
