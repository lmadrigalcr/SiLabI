/**
 * @api {post} /authenticate Authenticates an user.
 * @apiVersion 1.0.0
 * @apiName Authenticate
 * @apiGroup Authenticate
 * @apiPermission none
 * @apiUse AuthenticationError
 *
 * @apiDescription Retrieves the user information and access token based on an user log in credentials.
 *
 * @apiParam {String} username The username.
 * @apiParam {String} password The password.
 *
 * @apiSuccess {String}	access_token		The access token.
 * @apiSuccess {Object}	user 				The user data.
 * @apiSuccess {Number}	user.id 			The user identification.
 * @apiSuccess {String}	user.name 			The first name.
 * @apiSuccess {String}	user.last_name_1	The first last name.
 * @apiSuccess {String}	[user.last_name_2]	The second last name.	
 * @apiSuccess {String}	user.username		The username.
 * @apiSuccess {String}	user.gender			The gender.
 * @apiSuccess {String}	[user.email]		The email address.
 * @apiSuccess {String}	[user.phone]		The phone number.
 * @apiSuccess {Date}	user.created_at		The creation date.
 * @apiSuccess {Date}	user.updated_at		The last update date.
 *
 * @apiSuccessExample Response (example):
 *     HTTP/1.1 200 OK
 *     {
 *       "access_token": "",
 *       "user": {
 *         "id": 2,
 *         "name": "Eric",
 *         "last_name_1": "Andrews",
 *         "last_name_2": "Murray",
 *         "username": "emurray1"
 *         "gender": "Male",
 *         "email": "emurray1@buzzfeed.com",
 *         "phone": "83567411",
 *         "created_at": "/Date(1439606715483-0600)/",
 *         "updated_at": "/Date(1439606715483-0600)/"
 *       }
 *     }
 *
 * @apiError InvalidCredentials Invalid username or password.
 * @apiError MissingCredentials Missing username or password.
 *
 * @apiErrorExample Response (example):
 *     HTTP/1.1 400 BadRequest
 *     {
 *       "code": 400,
 *       "error": "InvalidCredentials",
 *       "description": "Invalid username or password"
 *     }
 */