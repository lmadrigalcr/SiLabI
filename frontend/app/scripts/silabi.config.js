(function() {
    'use strict';

    angular
      .module('silabi')
      .config(['showErrorsConfigProvider', showErrorsConfigProvider])
      .config(['toastr', configToaster]);

    function configShowErrors(showErrorsConfigProvider) {
      showErrorsConfigProvider.showSuccess(true);
    }

    function configToaster(toastr) {
      toastr.options = {
        "closeButton": true,
        "debug": false,
        "newestOnTop": true,
        "progressBar": false,
        "positionClass": "toast-top-center",
        "preventDuplicates": true,
        "onclick": null,
        "showDuration": "300",
        "hideDuration": "1000",
        "timeOut": "5000",
        "extendedTimeOut": "1000",
        "showEasing": "swing",
        "hideEasing": "linear",
        "showMethod": "fadeIn",
        "hideMethod": "fadeOut"
      }
    }

})();
