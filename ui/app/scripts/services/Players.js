'use strict';

angular.module('quakestatsApp')
    .factory('Players', ['$resource', function ($resource) {
        return $resource(BASE_URL + '/players', {}, {
            query: {method: 'GET', isArray:true}
        });
    }]);
