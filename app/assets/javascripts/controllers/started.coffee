angular.module('courseWebApp').controller 'StartedCtrl', [
    '$scope',
    '$timeout'
    ($scope, $timeout) ->
#            $('.parallax').parallax()
#            return
        $timeout ->
            $('.parallax').parallax()



]