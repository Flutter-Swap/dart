import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_swap/shelf_swap.dart';
import 'package:swap_server_sample/src/pagination/widgets.dart';

class PaginationController {
  Router get router {
    var result = Router();

    result.get('/', widget((context) async {
      return const PaginatedSample();
    }));

    return result;
  }
}
