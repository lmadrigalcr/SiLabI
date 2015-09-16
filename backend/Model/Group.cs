﻿using SiLabI.Util;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Runtime.Serialization;
using System.Web;

namespace SiLabI.Model
{
    [DataContract]
    public class Group : DatabaseObject
    {
        protected int? _number;
        protected Course _course;
        protected User _professor;
        protected Period _period;

        [DataMember(EmitDefaultValue = false, Name = "number")]
        public virtual int? Number
        {
            set { _number = value; }
            get { return _number; }
        }

        [DataMember(EmitDefaultValue = false, Name = "course")]
        public virtual Course Course
        {
            set { _course = value; }
            get { return _course; }
        }

        [DataMember(EmitDefaultValue = false, Name = "professor")]
        public virtual User Professor
        {
            set { _professor = value; }
            get { return _professor; }
        }

        [DataMember(EmitDefaultValue = false, Name = "period")]
        public virtual Period Period
        {
            set { _period = value; }
            get { return _period; }
        }

        public static Group Parse(DataRow row, string prefix = "")
        {
            prefix = prefix.Trim();
            if (!string.IsNullOrWhiteSpace(prefix))
            {
                prefix += ".";
            }

            Group group = new Group();

            group.Id = row.Table.Columns.Contains(prefix + "id") ? Converter.ToNullableInt32(row[prefix + "id"]) : null;
            group.Number = row.Table.Columns.Contains(prefix + "number") ? Converter.ToNullableInt32(row[prefix + "number"]) : null;
            group.CreatedAt = row.Table.Columns.Contains(prefix + "created_at") ? Converter.ToDateTime(row[prefix + "created_at"]) : null;
            group.UpdatedAt = row.Table.Columns.Contains(prefix + "updated_at") ? Converter.ToDateTime(row[prefix + "updated_at"]) : null;
            group.State = row.Table.Columns.Contains(prefix + "state") ? Converter.ToString(row[prefix + "state"]) : null;
            group.Period = Period.Parse(row, prefix + "period");

            if (group.isEmpty())
            {
                group = null;
            }

            return group;
        }
    }
}