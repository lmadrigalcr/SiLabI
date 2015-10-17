(function() {
  'use strict';

  angular
      .module('silabi')
      .controller('AppointmentDetailController', AppointmentDetailController);

  AppointmentDetailController.$inject = ['$scope', '$location', '$routeParams', 'AppointmentService', 'AppointmentDateService', 'MessageService', 'StudentService', 'SoftwareService', 'PeriodService', 'LabService', 'StateService', 'moment', 'lodash'];

  function AppointmentDetailController($scope, $location, $routeParams, AppointmentService, AppointmentDateService, MessageService, StudentService, SoftwareService, PeriodService, LabService, StateService, moment, _) {
    var vm = this;
    vm.selectedSoftware = {};
    vm.softwareList = [];
    vm.courses = [];
    vm.laboratories = [];
    vm.states = [];
    vm.groups = [];
    vm.availableDates = [];
    vm.availableHours = [];
    vm.selectedState = {};
    vm.selectedLaboratory = {};

    vm.request = {
      fields: 'id,date,state,created_at,updated_at,student.full_name,student.username,group.number,group.course.name,software.code,software.name,laboratory.name'
    };

    vm.laboratoryRequest = {
      fields: 'name'
    };

    vm.dateRequest = {
      fields: 'date,laboratory.name'
    };

    vm.groupRequest = {
      fields : 'id,number,course.name'
    };

    vm.softwareRequest = {
      fields: 'code,name',
      limit: 10
    };

    vm.setAvailableHours = setAvailableHours;
    vm.changeLaboratory = changeLaboratory;
    vm.searchSoftware = searchSoftware;
    vm.setSoftware = setSoftware;
    vm.fieldsReady = fieldsReady;
    vm.update = updateAppointment;
    vm.delete = deleteAppointment;

    activate();

    function activate() {
      vm.id = $routeParams.id;
      getStates();
      getLaboratories();
      getAppointment();
    }

    function getAppointment () {
      AppointmentService.GetOne(vm.id, vm.request)
      .then(setAppointment)
      .then(setGroups)
      .then(setAvailableDates)
      .catch(handleError);
    }

    function fieldsReady () {
      return !_.isEmpty(vm.appointment) && !_.isEmpty(vm.appointment.software);
    }

    function searchSoftware (input) {
      vm.softwareRequest.query = {};

      vm.softwareRequest.query.code = {
        operation: 'like',
        value: '*' + input + '*'
      };

      return SoftwareService.GetAll(vm.softwareRequest)
        .then(function(data) {
          return data.results;
        });
    }

    function getGroups () {
      var period = PeriodService.GetCurrentPeriod('Semestre');
      vm.groupRequest.query = {};

      vm.groupRequest.query['period.type'] = {
        operation: 'eq',
        value: 'Semestre'
      };

      vm.groupRequest.query['period.value'] = {
        operation: 'eq',
        value: period.value
      };

      vm.groupRequest.query['period.year'] = {
        operation: 'eq',
        value: period.year
      };

      return StudentService.GetGroups(vm.appointment.student.username, vm.groupRequest);
    }

    function getAvailableDates() {
        return AppointmentService.GetAvailable(vm.appointment.student.username, vm.dateRequest);
    }

    function getStates () {
      StateService.GetAppointmentStates()
      .then(setStates)
      .catch(handleError);
    }

    function getLaboratories () {
      LabService.GetAll(vm.laboratoryRequest)
      .then(setLaboratories)
      .catch(handleError);
    }

    function setAppointment (data) {
      vm.appointment = data;
      return getGroups();
    }

    function setStates(states) {
      vm.states = states;
      vm.states = _.reject(vm.states, function (state) { return state.value === '*'; });
      vm.states = _.map(vm.states, 'name');
    }

    function setLaboratories (data) {
      vm.laboratories = data.results;
    }

    function setSoftware (data) {
      vm.appointment.software = data;
    }

    function setGroups (groups) {
      vm.groups = groups;
      return getAvailableDates();
    }

    function setAvailableDates (dates) {
      vm.availableDates = AppointmentDateService.ParseAvailableDates(dates);
      vm.selectedDate = null;

      for (var i = 0; i < vm.availableDates.length; i++) {
        if (moment(vm.availableDates[i].day).isSame(vm.appointment.date, 'day')) {
          vm.selectedDate = vm.availableDates[i];
          setAvailableHours();
          break;
        }
      }

      if (!vm.selectedDate) {
        var current = {
          day: moment(vm.appointment.date).format('YYYY-MM-DD'),
          hoursByLab: [{
            fullDate: vm.appointment.date,
            hour: moment(vm.appointment.date).format('HH:mm'),
            laboratory: vm.appointment.laboratory
          }]
        };

        vm.availableDates.unshift(current);
        vm.selectedDate = vm.availableDates[0];
        setAvailableHours();
      }
    }

    function setAvailableHours() {
      if (vm.selectedDate) {
        vm.availableHours = vm.selectedDate.hoursByLab;
        vm.selectedHour = null;

        for (var i = 0; i < vm.availableHours.length; i++) {
          if (moment(vm.availableHours[i].fullDate).isSame(vm.appointment.date, 'hour')) {
            vm.selectedHour = vm.availableHours[i];
            break;
          }
        }

        if (!vm.selectedHour) {
          vm.selectedHour = vm.availableHours[0];
        }
      }
    }

    function changeLaboratory () {
      if (vm.selectedHour) {
        vm.selectedLaboratory = vm.selectedHour.laboratory;
      }
    }

    function updateAppointment () {
      if (!_.isEmpty(vm.appointment)) {
        if (vm.selectedDate && vm.selectedHour) {
          vm.date = vm.selectedDate.day + 'T' + vm.selectedHour.hour + ':00.000';
        }

        var app = {
          'date': vm.date,
          'laboratory': vm.appointment.laboratory.name,
          'software': vm.appointment.software.code,
          'group': vm.appointment.group.id,
          'state': vm.appointment.state
        };

        AppointmentService.Update(vm.id, app)
        .then(handleSuccess)
        .catch(handleError);
      }
    }

    function deleteAppointment() {
      if (!_.isEmpty(vm.appointment)) {
        MessageService.confirm('¿Desea realmente eliminar esta cita?')
        .then(function() {
          AppointmentService.Delete(vm.id)
          .then(redirectPage)
          .catch(handleError);
        });
      }
    }

    function redirectPage () {
      $location.path('/Operador/Citas');
    }

    function handleSuccess (data) {
      MessageService.success('Cita actualizada.');
      setAppointment(data);
    }

    function handleError(data) {
      MessageService.error(data.description);
    }
  }
})();
