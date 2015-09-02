(function() {
    'use strict';

    angular
        .module('silabi.sidebar')
        .directive('professorsSidebar', ProfessorsSideBar);

    function ProfessorsSideBar() {
        var directive = {
            restrict: 'EA',
            templateUrl: 'scripts/shared/directives/sidebar/professors/sidebar.html',
            controller: 'SideBarController',
            controllerAs: 'SideBar',
            bindToController: true
        };
        return directive;
    }
})();