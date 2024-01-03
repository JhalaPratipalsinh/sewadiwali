import 'package:dartz/dartz.dart';

extension EitherX<L, R> on Either<L, R> {
  R? getRight() => fold<R?>((_) => null, (r) => r);

  L? getLeft() => fold<L?>((l) => l, (_) => null);
}
