abstract class HomeState{
  const HomeState();
}

class HomeInitial extends HomeState{
  const HomeInitial();
}
class HomeLoading extends HomeState{
  const HomeLoading();
}
class TopDoctorsLoading extends HomeState{
   const TopDoctorsLoading();
}
class TopDoctorsLoaded extends HomeState{
  final List<String> doctorList;
  const TopDoctorsLoaded(this.doctorList);
}
class TopDoctorsLoadingFailed extends HomeState{
  final String message;
  const TopDoctorsLoadingFailed(this.message);
}
class HomeLoaded extends HomeState{}