angular.module('courseWebApp').controller('StudentCtrl', [
    '$scope',
    'Student',
    'Group',
    '$timeout',
    'Chart',
    '$q',
    '$state',
    ($scope, Student, Group, $timeout, Chart, $q, $state) ->
# hack it
        q = async.queue(((task, callback) ->
            task().then () ->
                callback()
        ), 1)


        $scope.loading = false
        $scope.requestLoading = false
        $scope.isLogin = true
        $scope.state = 'index'
        # for project
        $scope.project = null
        $scope.timelogs = null
        $scope.timelog = null
        $scope.projectForm =
            name: ''
            refUrl: ''
            type: 'Android'
            description: ''

        # for group
        $scope.groupForm =
            studentId: ""
            onlyMe: false
        $scope.group = Group
        $scope.hasGroup = () ->
            Group.members.length > 0

        # for groups
        $scope.groups = null
        $scope.studentsWithoutGroup = null

        # for setting
        $scope.passwordForm =
            password: ''
            confirmPassword: ''

        $scope.changeState = (state) ->
            $scope.state = state

        $scope.$watch('state', (newValue, oldValue) ->
            $scope.loading = true
            if newValue == 'index'
                $scope.prepareIndex()
            else if newValue == 'editProject'
                $scope.prepareEditProject()
            else if newValue == 'editGroup'
                $scope.prepareEditGroup()
            else if newValue == 'project'
                $scope.prepareProject()
            else if newValue == 'group'
                $scope.prepareAllGroup()
                $scope.prepareListStudentWithoutGroup()
            else if newValue == 'setting'
                $scope.prepareSetting()
            else
                $scope.loading = false
        )


        $scope.editTimelog = (timelog) ->
            $scope.timelog = angular.copy(timelog)
            timelog.editting = true
            findOwnCostData = false
            angular.forEach(timelog.time_costs, (timeCost) ->
                if timeCost.student.id.toString() == Student.account.toString()
                    timeCost.editting = true
                    findOwnCostData = true
            )
            if not findOwnCostData
                timelog.time_costs[timelog.time_costs.length] =
                    editting: true


        $scope.edittingTimelog = (timelog) ->
            $scope.requestLoading = true
            edittingTimeCost = null
            angular.forEach(timelog.time_costs, (timeCost) ->
                if timeCost.editting
                    edittingTimeCost = timeCost
            )

            Student.editTimelog(timelog.id, edittingTimeCost.cost, timelog.todo).then ((data) ->
                Materialize.toast("修改Timelog成功", 2000)
                $scope.prepareProject()
                $scope.requestLoading = false
            ), (msg) ->
                Materialize.toast(msg, 2000)
                $scope.requestLoading = false

        $scope.cancelEditTimelog = (selectedTimelog) ->
            for value, index in $scope.timelogs
                if $scope.timelogs[index].id == selectedTimelog.id
                    $scope.timelogs[index] = $scope.timelog
            $scope.timelog = null

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
                $scope.prepareAll()
                $scope.requestLoading = false
            ), (msg) ->
                Materialize.toast(msg, 2000)
                $scope.requestLoading = false

        $scope.$watch('groupForm.onlyMe', (newValue, oldValue) ->
            if newValue
                $scope.groupForm.studentId = ""
        )


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
                $scope.prepareEditProject()
            ), (msg) ->
                Materialize.toast(msg, 2000)
                $scope.requestLoading = false

        $scope.resetPassword = () ->
            $scope.requestLoading = true
            Student.resetPassword(
                $scope.passwordForm.password
            ).then ((data) ->
                Materialize.toast("修改密碼成功", 2000)
                $scope.requestLoading = false
            ), (msg) ->
                Materialize.toast(msg, 2000)
                $scope.requestLoading = false

        $scope.prepareIndex = () ->
            $q (resolve, reject) ->
                Chart.renderCommitCharts()
                resolve()
                $scope.loading = false

        $scope.prepareProject = () ->
            $q (resolve, reject) ->
                if not $scope.project?
                    resolve()
                    return
                Student.showTimelog($scope.project.id).then ((data) ->
                    $scope.timelogs = data
                    $scope.loading = false
                    resolve()
                ), (msg) ->
                    $scope.loading = false
                    resolve()

        $scope.prepareEditGroup = () ->
            $q (resolve, reject) ->
                $timeout(() ->
                    $('.modal-trigger').leanModal();
                , 200)
                Student.showGroup().then ((data) ->
                    $scope.loading = false
                    resolve()
                ), (msg) ->
                    $scope.loading = false
                    resolve()

        $scope.prepareEditProject = () ->
            $q (resolve, reject) ->

                Student.showProject().then ((data) ->
                    if data?
                        $scope.project = data
                        $scope.project.gitUrl = "http://127.0.0.1:3000/git/oopcourse#{data.id}.git"
                        $scope.projectForm.name = $scope.project.name
                        $scope.projectForm.refUrl = $scope.project.ref_url
                        $scope.projectForm.type = $scope.project.project_type
                        $scope.projectForm.description = $scope.project.description
                        $timeout(() ->
                            $('#project-textarea').trigger('autoresize');
                        )
                    $scope.renderSelect()
                    $scope.loading = false
                    resolve()
                ), (msg) ->
                    $scope.project = null
                    $scope.projectForm.name = null
                    $scope.projectForm.refUrl = null
                    $scope.projectForm.type = 'Android'
                    $scope.projectForm.description = null
                    $scope.loading = false
                    $scope.renderSelect()
                    resolve()

        $scope.prepareAllGroup = () ->
            $q (resolve, reject) ->
                Student.AllGroup().then ((data) ->
                    $scope.groups = Group.handleAllGroup(data)
                    $scope.loading = false
                    resolve()
                ), (msg) ->
                    $scope.loading = false
                    resolve()

        $scope.prepareListStudentWithoutGroup = () ->
            $q (resolve, reject) ->
                Student.ListSudentWithoutGroup().then ((data) ->
                    $scope.studentsWithoutGroup = data
                    $scope.loading = false
                    resolve()
                ), (msg) ->
                    $scope.loading = false
                    resolve()

        $scope.prepareSetting = () ->
            $scope.loading = false
            $timeout(() ->
                    $('.collapsible').collapsible({
                        accordion : false
                    })
                )

        q.drain = () ->
            $scope.layout.loading = false


        $scope.prepareAll = () ->
            $scope.layout.loading = true
            q.push($scope.prepareIndex)
            q.push($scope.prepareEditGroup)
            q.push($scope.prepareEditProject)
            q.push($scope.prepareProject)
            q.push($scope.prepareAllGroup)
            q.push($scope.prepareListStudentWithoutGroup)
        #            preparedList = [$scope.prepareIndex(), $scope.prepareEditGroup(), $scope.prepareEditProject(), $scope.prepareProject()]
        #            $scope.layout.loading = true
        #            $scope.renderNavBar()
        #            $q.all(preparedList).then((values) ->
        #                $scope.layout.loading = false
        #            )


        $scope.renderSelect = () ->
            $timeout(() ->
                $('select').material_select()
            )

        $scope.renderNavBar = () ->
            $timeout(() ->
                $(".button-collapse").sideNav();
            )


        # local processing
        handleAllGroup = (data) ->
            angular.forEach(data, (group) ->
                if group.project?
                    group.projectName = group.project.name
# TODO(Red): group demo score
            )
            data.sort (a,b) ->
                if a.projectName? and b.projectName?
                    return a.id - b.id
                else if not a.projectName and not b.projectName?
                    return a.id - b.id
                else if a.projectName?
                    return -1
                else if b.projectName?
                    return 1

            $scope.groups = data


        $scope.layout.loading = true
        Student.verifyAccessToken().then ((data) ->
            $scope.layout.loading = false
            $scope.prepareAll()
        ), (msg) ->
            $scope.layout.loading = false
            $state.go('main.started')

])
.filter('studentsName', () ->
    (students) ->
        if not students?
            return ''
        students.map((student) ->
            student.name
        ).join(",")
)
.filter('studentsId', () ->
    (students) ->
        if not students?
            return ''
        students.map((student) ->
            student.id
        ).join(',')
)