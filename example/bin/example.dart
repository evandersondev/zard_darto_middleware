import 'package:darto/darto.dart';
import 'package:zard/zard.dart';

import 'package:zard_darto_middleware/zard_darto_middleware.dart';

void main() {
  final app = Darto();

  final userBodySchema = z.map({
    'name': z.string().min(3),
    'email': z.string().email(),
    'age': z.int().min(18),
  });

  final userQuerySchema = z.map({'ref': z.string().optional()});

  final userParamSchema = z.map({'id': z.string().uuid()});

  app.post(
    '/users/:id',
    validateRequest(
      body: userBodySchema,
      query: userQuerySchema,
      params: userParamSchema,
    ),
    (Request req, Response res) {
      final body = req.$body;
      final query = req.$query;
      final params = req.$params;

      res.json({
        'message': 'Validation passed',
        'body': body,
        'query': query,
        'params': params,
      });
    },
  );

  app.get('/users/:id', validateRequestParams(userParamSchema), (
    Request req,
    Response res,
  ) {
    final id = req.$params['id'];
    res.json({'message': 'Validation passed', 'params': id});
  });

  app.listen(3000);
}
