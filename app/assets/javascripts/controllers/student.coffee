angular.module('courseWebApp').controller('StudentCtrl', [
    '$scope',
    'Student',
    'Group',
    '$timeout',
    'Chart',
    '$q',
    '$state',
    '$interval',
    '$http'
    ($scope, Student, Group, $timeout, Chart, $q, $state, $interval, $http) ->
# hack it
        q = async.queue(((task, callback) ->
            task().then () ->
                callback()
        ), 1)

        homeworkQueue = async.queue(((task, callback) ->
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
        $scope.selectedTimelog = null
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

        # for log
        $scope.logs = []
        $scope.logIndex = -1
        $scope.gettingLogs = false

        # for homework
        $scope.students = null
        $scope.homeworks = null

        # for timelog
        $scope.addTimeCostForm =
            cost: null
            category: null

        # for me
        $scope.me = null

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
            else if newValue == 'homework'
                $scope.prepareHomeworkPage()
            else if newValue == 'rollCall'
                $scope.prepareRollCalls()
            else
                $scope.loading = false
        )


        $scope.openTimeCostModal = (timelog) ->
            $timeout(() ->
                $scope.requestLoading = true;
                $scope.selectedTimelog = timelog
                $scope.showTimeCosts($scope.selectedTimelog.id).then (() ->
                    $('#editting-time-cost').openModal()
                    $('select').material_select()
                    $scope.requestLoading = false;
                )
            )

        $scope.addTimeCost = () ->
            Student.addTimeCost($scope.selectedTimelog.id, $scope.addTimeCostForm.cost, $scope.addTimeCostForm.category).then ((data) ->
                Materialize.toast("增加花費時間成功", 2000)
                $scope.showTimeCosts($scope.selectedTimelog.id)
                Student.showTimelog($scope.project.id).then ((data) ->
                    $scope.timelogs = data
                )
            ), (msg) ->
                Materialize.toast(msg, 2000)

        $scope.deleteTimeCost = (timeCostId) ->
            Student.destroyTimeCost(timeCostId).then ((data) ->
                Materialize.toast("刪除花費時間成功", 2000)
                $scope.showTimeCosts($scope.selectedTimelog.id)
                Student.showTimelog($scope.project.id).then ((data) ->
                    $scope.timelogs = data
                )
            ), (msg) ->
                Materialize.toast(msg, 2000)

        $scope.editTimelog = (timelog) ->
            $scope.timelog = angular.copy(timelog)
            timelog.editting = true
            $timeout(() ->
                $('#filePhoto').change(()->
                    handleImage(this)
                )
                handleImage = (input) ->
                    if (input.files && input.files[0])
                        reader = new FileReader()
                        reader.onload = (e) ->
                            $('#image_upload_preview').attr('src', e.target.result)
                        reader.readAsDataURL(input.files[0]);
                        timelog.image = input.files[0]
                        Student.uploadTimelogImage(timelog.id, timelog.image).then ((data) ->
                            Materialize.toast("上傳圖片成功", 2000)
                        ), (msg) ->
                            Materialize.toast(msg, 200)
            )


        $scope.edittingTimelog = (timelog) ->
            $scope.requestLoading = true
            edittingTimeCost = null
            angular.forEach(timelog.time_costs, (timeCost) ->
                if timeCost.editting
                    edittingTimeCost = timeCost
            )

            Student.editTimelog(timelog.id, timelog.todo).then ((data) ->
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
                Chart.getCommitsChart().then ((data) ->
                    $scope.loading = false
                    Chart.renderCommitCharts()
                    $scope.renderNews()
                    resolve()
                ), (msg) ->
                    $scope.loading = false
                    resolve()

        $scope.prepareProject = () ->
            $q (resolve, reject) ->
                if not $scope.project?
                    resolve()
                    return
                Student.showTimelog($scope.project.id).then ((data) ->
                    $scope.timelogs = data
                    $scope.loading = false
                    $scope.renderImage()
                    resolve()
                ), (msg) ->
                    $scope.loading = false
                    resolve()

        $scope.prepareRollCalls = () ->
            $q (resolve, reject) ->
                Student.getInfo().then ((data) ->
                    $scope.me = data
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
                        $scope.project.gitUrl = "#{config.url}/git/oopcourse#{data.id}.git"
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

        checkedDeliverHomework = (homeworks, students) ->
            for student in students
                for homework in homeworks
                    student.deliver = {}
                    student.deliver[homework.id] = false
                for deliver_homework in student.deliver_homeworks
                    student.deliver[deliver_homework.homework_id] = true

        checkRollCalls = (students) ->
            for student in students
                if student.roll_calls?
                    for rollCall in student.roll_calls
                        if rollCall.period == 0
                            student.rollCall1 = true
                        else if rollCall.period == 1
                            student.rollCall2 = true
                        else if rollCall.period == 2
                            student.rollCall3 = true


        $scope.showTimeCosts = (timelogId) ->
            $q (resolve, reject) ->
                Student.showTimeCosts(timelogId).then ((data) ->
                    $scope.selectedTimelog.time_costs = data
                    resolve()
                ), (msg) ->
                    resolve()

        $scope.prepareAllHomeworks = () ->
            $q (resolve, reject) ->
                Student.allHomeworks().then ((data) ->
                    $scope.homeworks = data
                    resolve()
                ), (msg) ->
                    resolve()

        $scope.prepareAllStudents = () ->
            $q (resolve, reject) ->
                Student.allStudents().then ((data) ->
                    $scope.students = data
                    checkedDeliverHomework($scope.homeworks, $scope.students)
                    checkRollCalls($scope.students)
                    resolve()
                ), (msg) ->
                    resolve()


        homeworkQueue.drain = () ->
            $scope.loading = false


        $scope.prepareHomeworkPage = () ->
            $scope.loading = true
            homeworkQueue.push($scope.prepareAllHomeworks)
            homeworkQueue.push($scope.prepareAllStudents)

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
                    accordion: false
                })
            )

        q.drain = () ->
            $scope.layout.loading = false


        $scope.prepareAll = () ->
            $scope.layout.loading = true
            #            q.push($scope.prepareIndex)
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

        $scope.renderImage = () ->
            $timeout(() ->
                $('.materialboxed').materialbox()
            )

        $scope.renderSelect = () ->
            $timeout(() ->
                $('select').material_select()
            )

        $scope.renderNavBar = () ->
            $timeout(() ->
                $(".button-collapse").sideNav();
            )

        $scope.renderNews = () ->
            if $scope.newsTimeout?
                return
            $scope.newsTimeout = () ->
                $interval(() ->
                    if $scope.state != 'index'
                        $scope.log_time = null
                        $scope.log_id = null
                        return
                    if $scope.logs.length <= 3 and $scope.gettingLogs == false
                        $scope.log_time ?= new Date().getTime()
                        $scope.gettingLogs = true
                        $scope.getLogs($scope.log_id, $scope.log_time)
                    if $scope.logs.length <= 0
                        return
                    $scope.log_time = null if $scope.logs.length >= 1
                    log = $scope.logs.pop()
                    text = log.text
                    log.moment = new Date(log.created_at).toLocaleTimeString()
                    $('#ticker').prepend("<li>#{log.moment}: #{text}</li>")
                    $('#ticker li:first').slideUp(0).slideDown()
                    if $('#ticker li').length >= 10
                        $('#ticker li:last').slideUp('swing', () ->
                            $(this).remove()
                        )
                , 2000)
        #            $scope.newsTimeout()

        $scope.getLogs = (after_id, after_time = null) ->
            $q (resolve, reject) ->
                url = "/api/notification/get_logs?after_time=#{after_time}" if after_time?
                url = "/api/notification/get_logs?after_id=#{after_id}" if after_id?
                $http.get(url).then ((response) ->
                    if response.data.data?
                        for log in response.data.data
                            $scope.logs.unshift(log)
                    $scope.log_id = null
                    $scope.log_id = $scope.logs[0].id if $scope.logs.length >= 1
                    $scope.gettingLogs = false
                    resolve()
                ), (response) ->
                    $scope.gettingLogs = false
                    resolve()


        # local processing

        handleAllGroup = (data) ->
            angular.forEach(data, (group) ->
                if group.project?
                    group.projectName = group.project.name
# TODO(Red): group demo score
            )
            data.sort (a, b) ->
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
.filter('studentsId', () ->
    (students) ->
        if not students?
            return ''
        students.map((student) ->
            student.id
        ).join(',')
)
.filter('timeCostCategory', () ->
    (category_id) ->
        switch category_id
            when 0 then return '程式撰寫'
            when 1 then return '程式規劃'
            when 2 then return '找尋素材'
            when 3 then return '素材整理'
            when 4 then return '團隊討論'
)
.filter('grade', () ->
    (score) ->
        if score >= 90
            return 'A+'
        else if score >= 85
            return 'A'
        else if score >= 80
            return 'A-'
        else if score >= 75
            return 'B+'
        else if score >= 70
            return 'B'
        else if score >= 65
            return 'B-'

)