import 'package:darto_types/darto_types.dart';
import 'package:zard/zard.dart';

Middleware validateRequest({
  Schema? body,
  Schema? query,
  Schema? param,
}) {
  return (Request req, Response res, NextFunction next) async {
    if (body != null) {
      final result = await body.safeParseAsync(req.body);
      if (!result.success) {
        return sendError('Body', result.error!.format(), res);
      }
      req.$body = result.data;
    }

    if (query != null) {
      final result = await query.safeParseAsync(req.query);
      if (!result.success) {
        return sendError('Query', result.error!.format(), res);
      }
      req.$query = result.data;
    }

    if (param != null) {
      final result = await param.safeParseAsync(req.param);
      if (!result.success) {
        return sendError('Params', result.error!.format(), res);
      }
      req.$param = result.data;
    }

    return next();
  };
}

Middleware validateRequestBody(Schema body) => validateRequest(body: body);
Middleware validateRequestQuery(Schema query) => validateRequest(query: query);
Middleware validateRequestParams(Schema params) =>
    validateRequest(param: params);

void sendError(String type, List errors, Response res) {
  res.status(404).json({
    'type': type,
    'errors': errors,
  });
}

extension ValidatedRequest on Request {
  dynamic get $body => context['validatedBody'];
  set $body(dynamic value) => context['validatedBody'] = value;

  dynamic get $query => context['validatedQuery'];
  set $query(dynamic value) => context['validatedQuery'] = value;

  dynamic get $param => context['validatedParams'];
  set $param(dynamic value) => context['validatedParams'] = value;
}
