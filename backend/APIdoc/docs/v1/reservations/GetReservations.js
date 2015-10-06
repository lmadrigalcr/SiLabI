/**
 * @api {get} /v1/reservations Retrieve a list of reservations.
 * @apiVersion 1.0.0
 * @apiName GetReservations
 * @apiGroup Reservations
 * @apiPermission operator
 * @apiUse BaseError
 *
 * @apiDescription Retrieve a list of reservations.
 *
 * @apiParamExample Example query:
 * 		GET /reservations?q=created_at+gt+2015-03-12T00:00:00 HTTP/1.1
 *		Retrieve all the reservations that was created after 2015/03/12
 *
 *		Valid Operations: eq, ne, gt, ge, lt, le, like.
 *		The character '*' is a wildcard for the like operation.
 *
 * @apiParamExample Example fields:
 *      GET /reservations?fields=start_time,end_time HTTP/1.1
 *      Retrieves only the start_time and end_time.
 *
 * @apiParamExample Example sort:
 *      GET /reservations?sort=id HTTP/1.1
 *      Order the results by ascending id.
 *
 * @apiParamExample Full example:
 *      GET /reservations?q=created_at+gt+2015-03-12T00:00:00&fields=start_time,end_time&sort=id HTTP/1.1
 *
 * @apiParam {String}   access_token	The access token.
 * @apiParam {String[]} [q]           A query to filter the results.
 * @apiParam {String[]} [fields]      A list of fields to include in the results.
 * @apiParam {String[]} [sort]        A list of fields to sort the results.
 * @apiParam {Number}   [page=1]      The page number.
 * @apiParam {Number}   [limit=20]    The amount of results by page.
 *
 * @apiSuccess {Number}							                          total_pages			      The total amount of pages for this query.
 * @apiSuccess {Number}	  								                    current_page	        The current page number.
 * @apiSuccess {Object[]} 								                    results 				      The list of reservations.
 * @apiSuccess {Number}									                      results.id 		        The reservation identification.
 * @apiSuccess {Date}									                        results.start_time 		The reservation start time.
 * @apiSuccess {Date}									                        results.end_time 		  The reservation end time.
 * @apiSuccess {Date}									                        results.created_at    The creation date.
 * @apiSuccess {Date}									                        results.updated_at    The last update date.
 * @apiSuccess {String="Por iniciar, Cancelada, Finalizada"}	results.state			    The reservation state.
 * @apiSuccess {Object}									                      results.professor 	  The professor data.
 * @apiSuccess {Object}                                       results.laboratory		The laboratory data.
 * @apiSuccess {Object}                                       results.software  		The software data.
 * @apiSuccess {Object}                                       results.group  		    The group data.
 *
 * @apiSuccessExample {json} Success-Response:
 *     HTTP/1.1 200 OK
 *     {
 *       "total_pages": 1,
 *       "current_page", 1,
 *       "results": [
 *         {
 *           "id": 1,
 *           "state": "Por iniciar",
 *           "start_time": "2015-08-27T13:00:00.000Z",
 *           "end_time": "2015-08-27T14:00:00.000Z",
 *           "created_at": "2015-08-27T22:14:20.646Z",
 *           "updated_at": "2015-08-27T22:14:20.646Z",
 *           "professor": {
 *             "created_at": "2015-08-27T22:14:20.646Z",
 *             "email": "gjacksonhi@squidoo.com",
 *             "gender": "Masculino",
 *             "id": 54,
 *             "last_name_1": "Lynch",
 *             "last_name_2": "Jackson",
 *             "name": "Gregory",
 *             "full_name": "Gregory Lynch Jackson",
 *             "phone": "7-(384)880-7491",
 *             "state": "Activo",
 *             "updated_at": "2015-08-27T22:14:20.646Z",
 *             "username": "gjackson"
 *           },
 *           "laboratory": {
 *             "id": 1136,
 *             "name": "Laboratorio A",
 *             "seats": 20,
 *             "state": "Activo",
 *             "created_at": "2015-08-27T22:14:20.646Z",
 *             "updated_at": "2015-08-27T22:14:20.646Z"
 *           },
 *           "software": {
 *             "id": 1136,
 *             "name": "Software #35",
 *             "code": "SF-35",
 *             "state": "Activo",
 *             "created_at": "2015-08-27T22:14:20.646Z",
 *             "updated_at": "2015-08-27T22:14:20.646Z"
 *           },
 *           "group": {
 *             "id": 1136,
 *             "number": 40,
 *             "course": {
 *               "id": 1136,
 *               "name": "Inglés II Para Computación",
 *               "code": "CI-1312",
 *               "state": "Activo",
 *               "created_at": "2015-08-27T22:14:20.646Z",
 *               "updated_at": "2015-08-27T22:14:20.646Z"
 *             },
 *             "professor": {
 *               "id": 54,
 *               "created_at": "2015-08-27T22:14:20.646Z",
 *               "email": "gjacksonhi@squidoo.com",
 *               "gender": "Masculino",
 *               "last_name_1": "Lynch",
 *               "last_name_2": "Jackson",
 *               "name": "Gregory",
 *               "full_name": "Gregory Lynch Jackson",
 *               "phone": "7-(384)880-7491",
 *               "state": "Activo",
 *               "updated_at": "2015-08-27T22:14:20.646Z",
 *               "username": "gjackson"
 *             },
 *             "period": {
 *               "value": 1,
 *               "type": "Semestre",
 *               "year": 2015
 *             }
 *             "state": "Activo",
 *             "created_at": "2015-08-27T22:14:20.646Z",
 *             "updated_at": "2015-08-27T22:14:20.646Z"
 *           }
 *         }
 *       ]
 *     }
 *
 * @apiErrorExample {json} Error-Response:
 *     HTTP/1.1 401 Unauthorized
 *     {
 *       "code": 401,
 *       "error": "Unauthorized",
 *       "description": "You don't have permissions to perform this operation."
 *     }
 */