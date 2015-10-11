(function() {
    'use strict';

    angular
      .module('silabi')
      .controller('ProfessorsDetailController', ProfessorsDetailController);

    ProfessorsDetailController.$inject = ['$scope', '$routeParams', '$location', 'ProfessorService', 'GenderService', 'MessageService'];

    function ProfessorsDetailController($scope, $routeParams, $location, ProfessorService, GenderService, MessageService) {
        var vm = this;
        vm.username = $routeParams.username;
        vm.update = updateProfessor;
        vm.delete = deleteProfessor;

        activate();

        function activate() {
          GenderService.GetAll().
          then(setGenders)
          .catch(handleError);

          ProfessorService.GetOne(vm.username).
          then(setProfessor)
          .catch(handleError);
      	}

        function updateProfessor() {
          if (!_.isEmpty(vm.professor)) {
            if (vm.password) {
              var hash = CryptoJS.SHA256(vm.password).toString(CryptoJS.enc.Hex);
              vm.professor.password = hash;
            }
            ProfessorService.Update(vm.professor.id, vm.professor)
            .then(handleUpdate)
            .catch(handleError);
          }
        }

        function deleteProfessor() {
          if (!_.isEmpty(vm.professor)) {
            MessageService.confirm("¿Desea realmente eliminar este docente?")
            .then(function() {
              ProfessorService.Delete(vm.professor.id)
              .then(redirectToProfessors)
              .catch(handleError)
            });
          }
        }

        function setGenders(genders) {
          vm.genders = genders;
        }

        function setProfessor(professor) {
          vm.professor = professor;
        }

        function redirectToProfessors() {
          $location.path("/Operador/Docentes");
        }

        function handleUpdate(professor) {
          setProfessor(professor);
          MessageService.success("Docente actualizado.");
          $scope.$broadcast('show-errors-reset');
        }

        function handleError(data) {
          MessageService.error(data.description);
        }
    }
})();
