(function() {
    'use strict';

    angular
        .module('silabi', [
          'ngAnimate',
          'ngCookies',
          'ngResource',
          'ngRoute',
          'ngSanitize',
          'ngTouch',
          'silabi.navbar',
          'silabi.sidebar',
        ]);
})();