/**
 * @api {put} /v1/students/:id Update a student.
 * @apiVersion 1.0.0
 * @apiName UpdateStudent
 * @apiGroup Students
 * @apiPermission operator
 * @apiUse BaseError
 *
 * @apiDescription Update a student.
 *
 * @apiExample Example:
 *     PUT /students/402
 *     {
 *       "student": {
 *         "email": "ataylor4a@moonfruit.com",
 *         "last_name_1": "Lewis",
 *         "last_name_2": "Taylor",
 *         "phone": "83492144"
 *       },
 *       "access_token":"..."
 *     }
 *
 * @apiParam {Object}								student 				The student data.
 * @apiParam {String}								[student.name] 			The first name.
 * @apiParam {String}								[student.last_name_1]	The first last name.
 * @apiParam {String}								[student.last_name_2]	The second last name.
 * @apiParam {String}								[student.username]		The username.
 * @apiParam {String}								[student.password]		The password.
 * @apiParam {String="Masculino, Femenino"}			[student.gender]		The gender.
 * @apiParam {String}								[student.email]			The email address.
 * @apiParam {String}								[student.phone]			The phone number.
 * @apiParam {String="Activo, Inactivo, Bloqueado"}	[student.state]			The user state.
 * @apiParam {String}								access_token			The access token.
 *
 * @apiSuccess {Number}									id 				The user identification.
 * @apiSuccess {String}									name 			The first name.
 * @apiSuccess {String}									last_name_1		The first last name.
 * @apiSuccess {String}									last_name_2		The second last name.
 * @apiSuccess {String}									username		The username.
 * @apiSuccess {String="Masculino, Femenino"}			gender			The gender.
 * @apiSuccess {String}									email			The email address.
 * @apiSuccess {String}									phone			The phone number.
 * @apiSuccess {Date}									created_at		The creation date.
 * @apiSuccess {Date}									updated_at		The last update date.
 * @apiSuccess {String="Activo, Inactivo, Bloqueado"}	state			The user state.
 *
 * @apiSuccessExample {json} Success-Response:
 *     HTTP/1.1 200 OK
 *     {
 *       "created_at": "/Date(1440097559917-0600)/",
 *       "email": "ataylor4a@moonfruit.com",
 *       "gender": "Masculino",
 *       "id": 1136,
 *       "last_name_1": "Lewis",
 *       "last_name_2": "Taylor",
 *       "name": "Arthur",
 *       "phone": "83492144",
 *       "state": "Activo",
 *       "updated_at": "/Date(1440097559917-0600)/",
 *       "username": "201242273"
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