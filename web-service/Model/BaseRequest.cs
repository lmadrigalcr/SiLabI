﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Runtime.Serialization;
using System.ServiceModel.Web;
using System.Web;

namespace SiLabI.Model
{
    /// <summary>
    /// Base class for all request in the service.
    /// </summary>
    [DataContract]
    public class BaseRequest
    {
        protected string _accessToken;

        /// <summary>
        /// The JWT access token.
        /// </summary>
        [DataMember(Name = "access_token")]
        public string AccessToken
        {
            set
            {
                if (string.IsNullOrWhiteSpace(value))
                {
                    ErrorResponse error = new ErrorResponse(HttpStatusCode.BadRequest, "MissingParameter", "El token de acceso es obligatorio.");
                    throw new WebFaultException<ErrorResponse>(error, error.Code);
                }
                _accessToken = value;
            }
            get { return _accessToken; }
        }

        /// <summary>
        /// Check if the object properties are valid.
        /// </summary>
        /// <returns></returns>
        public virtual bool IsValid()
        {
            return !string.IsNullOrWhiteSpace(AccessToken);
        }
    }
}