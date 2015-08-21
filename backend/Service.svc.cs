﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;
using System.Web.Script.Serialization;
using System.IO;
using System.Reflection;
using System.ServiceModel.Activation;
using SiLabI.Model;
using SiLabI.Controllers;
using System.Net;
using SiLabI.Model.Query;

namespace SiLabI
{
    /// <summary>
    /// The web service implementation.
    /// </summary>
    [AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
    public partial class Service : IService
    {
        private AuthenticationController _AuthController;
        private UserController _UserController;
        private AdministratorController _AdminController;
        private StudentController _StudentController;

        public Service()
        {
            this._AuthController = new AuthenticationController();
            this._UserController = new UserController();
            this._AdminController = new AdministratorController();
            this._StudentController = new StudentController();
        }
    }
}