angular.module('courseWebApp').controller 'StudentCtrl', [
    '$scope',
    'Student'
    ($scope, Student) ->
        # hack it
        $scope.isLogin = true
        $scope.state = 'project'
        $scope.project =
            timelog:
                null
        $scope.group = Student.group
        $scope.groupCreateForm =
            studentId: ""


        $scope.changeState = (state) ->
            $scope.state = state

        $scope.createGroup = () ->
            # TODO(Red): adapte api



]