(function() {
    'use strict';

    angular
      .module('silabi')
      .controller('CourseDetailController', CourseDetail);

    CourseDetail.$inject = ['$routeParams', '$location', 'CourseService', 'MessageService'];

    function CourseDetail($routeParams, $location, CourseService, MessageService) {
      var vm = this;
      vm.course = {};
      vm.id = $routeParams.id;
      vm.update = updateCourse;
      vm.delete = deleteCourse;

      activate();

      function activate() {
        CourseService.GetOne(vm.id)
        .then(setCourse)
        .catch(handleError);
      }

      function updateCourse() {
        if (vm.id) {
          CourseService.Update(vm.course.id, vm.course)
          .then(setCourse)
          .catch(handleError);
        }
      }

      function deleteCourse() {
        if (vm.course) {
          MessageService.confirm("¿Desea realmente eliminar este curso?")
          .then(function () {
            CourseService.Delete(vm.course.id)
            .then(redirectToCourses)
            .catch(handleError);
            }
          );
        }
      }

      function setCourse(course) {
        vm.course = course;
      }

      function redirectToCourses(result) {
        $location.path('/Operador/Cursos');
      }

      function handleError(data) {
        MessageService.error(data.description);
      }
    }
})();