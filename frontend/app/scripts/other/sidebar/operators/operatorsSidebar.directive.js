(function() {
    'use strict';

    angular
        .module('silabi.sidebar')
        .directive('operatorsSidebar', OperatorsSideBar);

    function OperatorsSideBar() {
        var directive = {
            restrict: 'EA',
            templateUrl: 'scripts/other/sidebar/operators/operators-sidebar.html',
            controller: OperatorsSideBarController,
            controllerAs: 'vm',
            bindToController: true
        };

        return directive;
    }

    OperatorsSideBarController.$inject = ['$location'];

    function OperatorsSideBarController($location) {
      var vm = this;

      vm.isActive = isActive;
      vm.goProfessors = function goProfessors()
      {
        vm.nombre = "hola";
        $location.path("/Operador/Docentes");
      };
      vm.nombre = "s";

      

      function isActive(viewLocation) 
      {
        return viewLocation === $location.path()
      }


    }
})();
