abstract class Failure {
  final String message;
  const Failure(this.message);
}
class NetworkFailure    extends Failure { const NetworkFailure([super.message = 'لا يوجد اتصال بالإنترنت']); }
class ServerFailure     extends Failure { const ServerFailure([super.message = 'خطأ في الخادم']); }
class CacheFailure      extends Failure { const CacheFailure([super.message = 'خطأ في التخزين المحلي']); }
class NotFoundFailure   extends Failure { const NotFoundFailure([super.message = 'البيانات غير موجودة']); }
class UnknownFailure    extends Failure { const UnknownFailure([super.message = 'خطأ غير معروف']); }
