/**
 * @api {get} /v1/users/:username Retrieve an user.
 * @apiVersion 1.0.0
 * @apiName GetUser
 * @apiGroup Users
 * @apiPermission operator
 * @apiUse BaseError
 *
 * @apiDescription Retrieve an user.
 *
 * @apiExample Example:
 * 		GET /users/emarin
 *
 * @apiParam {String}	access_token	The access token.
 *
 * @apiSuccess {Number}						id 				The user identification.
 * @apiSuccess {String}						name 			The first name.
 * @apiSuccess {String}						last_name_1		The first last name.
 * @apiSuccess {String}						[last_name_2]	The second last name.
 * @apiSuccess {String}						username		The username.
 * @apiSuccess {String="Masculino, Femenino"}		gender			The gender.
 * @apiSuccess {String}						[email]			The email address.
 * @apiSuccess {String}						[phone]			The phone number.
 * @apiSuccess {Date}						created_at		The creation date.
 * @apiSuccess {Date}						updated_at		The last update date.
 * @apiSuccess {String="active, inactive, blocked"}						state	The user state.
 * @apiSuccess {String="student, professor, operator, administrator"} 	type 	The user type.
 *
 * @apiSuccessExample {json} Success-Response:
 *     HTTP/1.1 200 OK
 *     {
 *       "created_at": "/Date(1439325374913-0600)/",
 *       "email": "gjacksonhi@USER_squidoo.com",
 *       "gender": "Male",
 *       "id": 631,
 *       "last_name_1": "Lynch",
 *       "last_name_2": "Jackson",
 *       "name": "Gregory",
 *       "phone": "7-(384)880-7491",
 *       "state": "active",
 *       "updated_at": "/Date(1439325374913-0600)/",
 *       "username": "gjacksonhi",
 *       "type": "student"
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