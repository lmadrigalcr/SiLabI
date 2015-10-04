﻿using SiLabI.Data;
using SiLabI.Exceptions;
using SiLabI.Model;
using SiLabI.Model.Query;
using SiLabI.Util;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.ServiceModel.Web;
using System.Web;

namespace SiLabI.Controllers
{
    /// <summary>
    /// Perform CRUD operations for Users.
    /// </summary>
    public class UserController : IController<User>
    {
        private UserDataAccess _UserDA;

        /// <summary>
        /// Creates an UserController();
        /// </summary>
        public UserController()
        {
            this._UserDA = new UserDataAccess();
        }

        public GetResponse<User> GetAll(QueryString request, Dictionary<string, object> payload)
        {
            // By default search only active users.
            if (!request.Query.Exists(element => element.Name == "state"))
            {
                Field field = Field.Find(ValidFields.User, "state");
                request.Query.Add(new QueryField(field, Relationship.EQ, "Activo"));
            }

            GetResponse<User> response = new GetResponse<User>();
            DataTable table = _UserDA.GetAll(payload["id"], request);
            int count = _UserDA.GetCount(payload["id"], request);     

            foreach (DataRow row in table.Rows)
            {
                response.Results.Add(User.Parse(row));
            }

            response.CurrentPage = request.Page;
            response.TotalPages = (count + request.Limit - 1) / request.Limit;

            return response;
        }

        public User GetOne(string username, QueryString request, Dictionary<string, object> payload)
        {
            DataRow row = _UserDA.GetOne(payload["id"], username, request);
            return User.Parse(row);
        }

        public User GetOne(int id, QueryString request, Dictionary<string, object> payload)
        {
            DataRow row = _UserDA.GetOne(payload["id"], id, request);
            return User.Parse(row);
        }

        public User Create(BaseRequest request, Dictionary<string, object> payload)
        {
            throw new InvalidOperationException("An user cannot be created.");
        }

        public User Update(int id, BaseRequest request, Dictionary<string, object> payload)
        {
            throw new InvalidOperationException("An user cannot be updated.");
        }

        public void Delete(int id, BaseRequest request, Dictionary<string, object> payload)
        {
            throw new InvalidOperationException("An user cannot be deleted.");
        }
    }
}