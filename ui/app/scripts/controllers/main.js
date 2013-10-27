'use strict';

angular.module('quakestatsApp')
    .controller('MainCtrl', ['$scope', 'Players', function ($scope, Players) {
        $scope.players = Players.query();
    }]);
