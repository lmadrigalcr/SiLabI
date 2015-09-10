/**
 * @api {get} /v1/groups/:id/students Get the group students.
 * @apiVersion 1.0.0
 * @apiName GetGroupStudents.
 * @apiGroup Groups/Students
 * @apiPermission operator
 * @apiUse BaseError
 *
 * @apiDescription Get the group students.
 *
 * @apiExample Example:
 *     GET /groups/45/students HTTP/1.1
 *
 * @apiParam {String}						access_token    The access token.
 *
 * @apiSuccess {Number}									id 				The user identification.
 * @apiSuccess {String}									name 			The first name.
 * @apiSuccess {String}									last_name_1		The first last name.
 * @apiSuccess {String}									last_name_2		The second last name.
 * @apiSuccess {String}									full_name		The full name.
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
 *     [
 *       {
 *          "created_at": "2015-08-27T22:14:20.646Z",
 *          "email": "gjacksonhi@squidoo.com",
 *          "gender": "Masculino",
 *          "id": 631,
 *          "last_name_1": "Lynch",
 *          "last_name_2": "Jackson",
 *          "name": "Gregory",
 *          "full_name": "Gregory Lynch Jackson",
 *          "phone": "7-(384)880-7491",
 *          "state": "Activo",
 *          "updated_at": "2015-08-27T22:14:20.646Z",
 *          "username": "201242273"
 *       },
 *       {
 *          "created_at": "2015-08-27T22:14:20.646Z",
 *          "email": "lturnerel@wordpress.org",
 *          "gender": "Femenino",
 *          "id": 526,
 *          "last_name_1": "George",
 *          "last_name_2": "Turner",
 *          "name": "Lori",
 *          "full_name": "Lori George Turner",
 *          "phone": "8-(226)006-5947",
 *          "state": "Activo",
 *          "updated_at": "2015-08-27T22:14:20.646Z",
 *          "username": "201242277"
 *       }
 *    ]
 *
 * @apiErrorExample {json} Error-Response:
 *     HTTP/1.1 401 Unauthorized
 *     {
 *       "code": 401,
 *       "error": "Unauthorized",
 *       "description": "You don't have permissions to perform this operation."
 *     }
 */