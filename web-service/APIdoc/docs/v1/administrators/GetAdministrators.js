/**
 * @api {get} /v1/administrators Retrieve a list of administrators.
 * @apiVersion 1.0.0
 * @apiName GetAdministrators
 * @apiGroup Administrators
 * @apiPermission administrator
 * @apiUse BaseError
 *
 * @apiDescription Retrieve a list of administrators.
 *
 * @apiParamExample Example query:
 * 		/administrators?q=name+like+*jose*,updated_at+gt+2015-03-12T00:00:00
 *		Retrieve all the administrators which name contains 'jose' and was updated after 2015/03/12
 *
 *		Valid Operations: eq, ne, gt, ge, lt, le, like.
 *		The character '*' is a wildcard for the like operation.
 *
 * @apiParamExample Example fields:
 *      /administrators?fields=id,name,email
 *      Retrieves only the id, name and email fields.
 *
 * @apiParamExample Example sort:
 *      /administrators?sort=name,-email
 *      Order the results by ascending name and then by descending email.
 *
 * @apiParamExample Full example:
 *      /administrators?q=name+like+*jose*,updated_at+gt+2015-03-12T00:00:00&fields=id,name,email&sort=name,-email
 *
 * @apiParam {String}	access_token	The access token.
 * @apiParam {String[]} [q]				A query to filter the results.
 * @apiParam {String[]} [fields]		A list of fields to include in the results.
 * @apiParam {String[]} [sort]			A list of fields to sort the results.
 * @apiParam {Number}   [page=1]		The page number.
 * @apiParam {Number}   [limit=20]		The amount of results by page.
 *
 * @apiSuccess {Number}		total_pages				The total amount of pages for this query.
 * @apiSuccess {Number}	  	current_page			The current page number.
 * @apiSuccess {Object[]} 	results 				The list of administrators.
 * @apiSuccess {Number}		results.id 				The user identification.
 * @apiSuccess {String}		results.name 			The first name.
 * @apiSuccess {String}		results.last_name_1		The first last name.
 * @apiSuccess {String}		[results.last_name_2]	The second last name.
 * @apiSuccess {String}		results.username		The username.
 * @apiSuccess {String="Masculino, Femenino"}		results.gender			The gender.
 * @apiSuccess {String}		[results.email]			The email address.
 * @apiSuccess {String}		[results.phone]			The phone number.
 * @apiSuccess {Date}		results.created_at		The creation date.
 * @apiSuccess {Date}		results.updated_at		The last update date.
 * @apiSuccess {String="active, inactive, blocked"}	results.state	The user state.
 *
 * @apiSuccessExample {json} Success-Response:
 *     HTTP/1.1 200 OK
 *     {
 *       "total_pages": 23,
 *       "current_page", 1,
 *       "results": [
 *           {
 *              "created_at": "/Date(1439325374913-0600)/",
 *              "email": "gjacksonhi@USER_squidoo.com",
 *              "gender": "Male",
 *              "id": 631,
 *              "last_name_1": "Lynch",
 *              "last_name_2": "Jackson",
 *              "name": "Gregory",
 *              "phone": "7-(384)880-7491",
 *              "state": "active",
 *              "updated_at": "/Date(1439325374913-0600)/",
 *              "username": "gjacksonhi"
 *           },
 *           {
 *              "created_at": "/Date(1439325374913-0600)/",
 *              "email": "lturnerel@USER_wordpress.org",
 *              "gender": "Female",
 *              "id": 526,
 *              "last_name_1": "George",
 *              "last_name_2": "Turner",
 *              "name": "Lori",
 *              "phone": "8-(226)006-5947",
 *              "state": "active",
 *              "updated_at": "/Date(1439325374913-0600)/",
 *              "username": "lturnerel"
 *           }
 *        ]
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
