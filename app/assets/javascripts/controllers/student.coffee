angular.module('courseWebApp').controller 'StudentCtrl', [
    '$scope',
    'Student',
    'Group',
    '$timeout',
    'Chart',
    ($scope, Student, Group, $timeout, Chart) ->
        # hack it
        $scope.isLogin = true
        $scope.state = 'index'
        $scope.project =
            timelog:
                null
        $scope.groupForm =
            studentId: ""

        $scope.hasGroup = () ->
            Group.members.length > 0

        $scope.changeState = (state) ->
            $scope.state = state
            if state == 'index'
                Chart.renderCommitCharts()
            else if state == 'editProject'
                $scope.renderSelect()
            else if state == 'editGroup'
                $scope.prepareEditGroup()

        $scope.createGroup = () ->
            # TODO(Red): adapte api
            Student.createGroup($scope.groupForm.studentId).then ((data) ->
                Materialize.toast("建立團隊成功", 2000)
            ), (msg) ->
                Materialize.toast(msg, 2000)

        $scope.renderSelect = () ->
            $timeout(() ->
                $('select').material_select()
            )

        $scope.prepareEditGroup = () ->
            Student.showGroup().then (data) ->


        Chart.renderCommitCharts()
        $scope.renderSelect()
]