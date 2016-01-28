angular.module('courseWebApp').controller 'StudentCtrl', [
    '$scope',
    'Student',
    'Group',
    '$timeout',
    'Chart',
    ($scope, Student, Group, $timeout, Chart) ->
# hack it
        $scope.loading = false
        $scope.requestLoading = false
        $scope.isLogin = true
        $scope.state = 'index'
        $scope.project = null
        $scope.groupForm =
            studentId: ""
        $scope.projectForm =
            name: ''
            refUrl: ''
            type: 'Android'
            description: ''

        $scope.group = Group
        $scope.hasGroup = () ->
            Group.members.length > 0

        $scope.changeState = (state) ->
            $scope.state = state


        $scope.$watch('state', (newValue, oldValue) ->
            $scope.loading = true
            if newValue == 'index'
                Chart.renderCommitCharts()
                $scope.loading = false
            else if newValue == 'editProject'
                $scope.prepareEditProject()
            else if newValue == 'editGroup'
                $scope.prepareEditGroup()
            else
                $scope.loading = false
        )


        $scope.createGroup = () ->
            $scope.requestLoading = true
            Student.createGroup($scope.groupForm.studentId).then ((data) ->
                Materialize.toast("建立團隊成功", 2000)
                $scope.prepareEditGroup()
                $scope.requestLoading = false
            ), (msg) ->
                Materialize.toast(msg, 2000)
                $scope.requestLoading = false

        $scope.destroyGroup = () ->
            $scope.requestLoading = true
            Student.destroyGroup().then ((data) ->
                Materialize.toast("解散團隊成功", 2000)
                $scope.prepareEditGroup()
                $scope.requestLoading = false
            ), (msg) ->
                Materialize.toast(msg, 2000)
                $scope.requestLoading = false


        $scope.createProject = () ->
            $scope.requestLoading = true
            Student.createProject(
                $scope.projectForm.name,
                $scope.projectForm.refUrl,
                $scope.projectForm.type,
                $scope.projectForm.description
            ).then ((data) ->
                Materialize.toast("建立專案成功", 2000)
                $scope.requestLoading = false
                $scope.prepareEditProject()
            ), (msg) ->
                Materialize.toast(msg, 2000)
                $scope.requestLoading = false

        $scope.editProject = () ->
            $scope.requestLoading = true
            Student.editProject(
                $scope.projectForm.name,
                $scope.projectForm.refUrl,
                $scope.projectForm.type,
                $scope.projectForm.description
            ).then ((data) ->
                Materialize.toast("修改專案成功", 2000)
                $scope.requestLoading = false
            ), (msg) ->
                Materialize.toast(msg, 2000)
                $scope.requestLoading = false


        $scope.prepareEditGroup = () ->
            $timeout(() ->
                $('.modal-trigger').leanModal();
            , 200)
            Student.showGroup().then ((data) ->
                $scope.loading = false
            ), (msg) ->
                $scope.loading = false

        $scope.prepareEditProject = () ->
            $scope.renderSelect()
            Student.showProject().then ((data) ->
                if data?
                    $scope.project = data
                    $scope.projectForm.name = $scope.project.name
                    $scope.projectForm.refUrl = $scope.project.ref_url
                    $scope.projectForm.type = $scope.project.project_type
                    $scope.projectForm.description = $scope.project.description
                    $timeout(() ->
                        $('#project-textarea').trigger('autoresize');
                    )
                $scope.loading = false
            ), (msg) ->
                $scope.projectForm.name = null
                $scope.projectForm.refUrl = null
                $scope.projectForm.type = 'Android'
                $scope.projectForm.description = null
                $scope.loading = false


        $scope.renderSelect = () ->
            $timeout(() ->
                $('select').material_select()
            ,300)

        $scope.renderNavBar = () ->
            $timeout(() ->
                $(".button-collapse").sideNav();
            )

        Chart.renderCommitCharts()
        $scope.renderSelect()
        $scope.renderNavBar()

]