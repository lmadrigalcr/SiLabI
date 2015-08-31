(function() {
    'use strict';

    angular
        .module('silabi')
        .service('ProfessorService', ProfessorService);

    ProfessorService.$inject = ['$localStorage', 'RequestService'];

    function ProfessorService($localStorage, RequestService) {

        this.GetAll = function(request)
        {
            if (!request) request = {};
            request.access_token = $localStorage['access_token'];
            return RequestService.get('/professors', request);
        };

        this.GetOne = function(user_name)
        {
            var request = {};
            request.access_token = $localStorage['access_token'];
            return RequestService.get('/professors/' + user_name, request);
        }

        this.Create = function(professor)
        {
            var request = {};
            request.professor = professor;
            request.access_token = $localStorage['access_token'];
            return RequestService.post('/professors', request);
        };

        this.Update = function(id, professor)
        {
            var request = {};
            request.professor = professor;
            request.access_token = $localStorage['access_token'];
            return RequestService.put('/professors/' + id, request);
        };

        this.Delete = function(id)
        {
            var request = {};
            request.access_token = $localStorage['access_token'];
            return RequestService.delete('/professors/'+id, request);
        }

    }
})();
