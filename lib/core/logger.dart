import 'package:logger/logger.dart';

final logger = Logger(
  filter: MyFilter(),
  printer: PrefixPrinter(PrettyPrinter()),
);

//TODO custom class for filtering and to log only in development mode so shouldLog should be 'false' in Production phase and 'true' while Development Phase.
//if you don/t want to print the log with color then remove the PrettyPrinter().

class MyFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return true;
  }
}
