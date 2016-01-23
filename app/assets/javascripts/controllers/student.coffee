angular.module('courseWebApp').controller 'StudentCtrl', [
    '$scope',
    ($scope) ->
        # hack it
        $scope.isLogin = true
        $scope.state = 'project'
        $scope.project = null
        $scope.group = null
        $scope.groupCreateForm =
            studentId: ""

        $scope.changeState = (state) ->
            $scope.state = state

        $scope.createGroup = () ->



]