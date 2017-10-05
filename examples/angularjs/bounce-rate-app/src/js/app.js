// MODULE
var weatherApp = angular.module('weatherApp', ['ngRoute', 'ngResource']);

// ROUTES
weatherApp.config(function($routeProvider) {

    $routeProvider
    
    .when('/', {
        templateUrl: '/templates/home.htm',
        controller: 'homeController'
    })
    
    .when('/forecast', {
        templateUrl: '/templates/forecast.htm',
        controller: 'forecastController'
    })
    
});

// CONTROLLERS
weatherApp.controller('homeController', ['$scope', function($scope){ 
}]);

weatherApp.controller('forecastController', ['$scope', function($scope){ 
}]);