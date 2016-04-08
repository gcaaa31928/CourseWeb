angular.module('courseWebApp').controller('AdminCtrl', [
    '$scope',
    'Admin',
    'Group',
    '$q',
    '$timeout',
    '$state'
    ($scope, Admin, Group, $q, $timeout, $state) ->
        q = async.queue(((task, callback) ->
            task().then () ->
                callback()
        ), 1)

        courseQuery = async.queue(((task, callback) ->
            task().then () ->
                callback()
        ), 1)

        scoresQuery = async.queue(((task, callback) ->
            task.do.then ((data) ->
                task.callback(data)
                callback()
            ), () ->
                callback()
        ), 1)


        $scope.state = 'course'
        $scope.inCourse = false;
        $scope.inCreatingCourse = false;
        $scope.loading = false
        $scope.courseLoading = false
        $scope.courses = null
        $scope.requestLoading = false
        $scope.selectedCourse = null
        $scope.selectedGroup = null
        $scope.selectedStudent = null
        $scope.groups = null
        $scope.timelogs = null
        $scope.scoreForm = []
        $scope.scores = []
        $scope.studentsWithoutGroup = null
        $scope.addTeachingForm =
            id: ''
            name: ''
            className: ''
            courseId: ''
        $scope.addStudentForm =
            id: ''
            name: ''
            className: ''
        $scope.addHomeworkForm =
            name: ''
        $scope.passwordForm =
            password: ''
            confirmPassword: ''
        $scope.scoreForm =
            point: ''

        $scope.verifyForm =
            password: ''

        $scope.verifyCallback = null

        $scope.rollCallReqSuccess =
            period: null
            studentId: null

        $scope.students = null

        $scope.tab = 'project'


        $scope.changeState = (state) ->
            $scope.state = state

        $scope.changeTab = (tab) ->
            $scope.tab = tab
            if tab == 'project'
                renderImage()
            else if tab == 'rollcall'
                renderRollCallDate()



        $scope.$watch('state', (newValue, oldValue) ->
            if newValue == 'manage'
                $scope.prepareManage()
            else if newValue == 'setting'
                $scope.prepareSetting()


        )


        $scope.createCourse = () ->
            $scope.inCreatingCourse = true
            $scope.inCourse = false

        $scope.form =
            courseId: ""

        $scope.timelogDate = ''
        $scope.rollCallDate = null

        $scope.submitVerify = () ->
            if $scope.verifyForm.password == "oop#{("0" + new Date().getDate()).slice(-2)}"
                ($scope.verifyCallback || angular.noop)()
            else
                Materialize.toast("身份驗證失敗", 2000)
            $scope.verifyForm.password = ''
            $('#verify-modal').closeModal()

        $scope.submitCreateCourse = () ->
            $scope.requestLoading = true
            Admin.createCourseStudent($scope.form.courseId).then ((data) ->
                Materialize.toast("建立課程成功", 2000)
                $scope.prepareCourse()
                $scope.requestLoading = false
            ), (msg) ->
                Materialize.toast(msg, 2000)
                $scope.requestLoading = false


        $scope.submitAddStudent = () ->
            $scope.requestLoading = true
            Admin.addStudent(
                $scope.addStudentForm.id,
                $scope.addStudentForm.name,
                $scope.addStudentForm.className,
                $scope.selectedCourse.id
            ).then ((data) ->
                Materialize.toast("增加學生成功", 2000)
                $scope.prepareListStudentWithoutGroup()
                $scope.requestLoading = false
            ), (msg) ->
                Materialize.toast(msg, 2000)
                $scope.requestLoading = false

        $scope.submitAddHomework = () ->
            $scope.requestLoading = true
            Admin.addHomework(
                $scope.addHomeworkForm.name,
                $scope.selectedCourse.id
            ).then ((data) ->
                Materialize.toast("增加作業成功", 2000)
                $scope.requestLoading = false
            ), (msg) ->
                Materialize.toast(msg, 2000)
                $scope.requestLoading = false

        checkedDeliverHomework = (homeworks, students) ->
            for student in students
                for homework in homeworks
                    student.deliver = {}
                    student.deliver[homework.id] = false
                for deliver_homework in student.deliver_homeworks
                    student.deliver[deliver_homework.homework_id] = true


        $scope.submitHomeworkState = (handIn, homeworkId, studentId) ->
            $('#verify-modal').openModal()
            $scope.verifyCallback = () ->
                if handIn
                    $scope.submitHandInHomework(homeworkId, studentId)
                else
                    $scope.submitCancelHandInHomework(homeworkId, studentId)


        $scope.submitHandInHomework = (homeworkId, studentId) ->
            $scope.requestLoading = true
            Admin.handInHomework(
                homeworkId
                studentId
            ).then ((data) ->
                Materialize.toast("已登入繳交作業", 2000)
                $scope.requestLoading = false
                $scope.studentReqSuccessId = studentId
            ), (msg) ->
                Materialize.toast(msg, 2000)
                $scope.requestLoading = false

        $scope.submitCancelHandInHomework = (homeworkId, studentId) ->
            $scope.requestLoading = true
            Admin.cancelHandInHomework(
                homeworkId
                studentId
            ).then ((data) ->
                Materialize.toast("已取消登入繳交作業", 2000)
                $scope.requestLoading = false
                $scope.studentReqSuccessId = studentId
            ), (msg) ->
                Materialize.toast(msg, 2000)
                $scope.requestLoading = false

        $scope.submitRollCallState = (state, period, studentId) ->
            $('#verify-modal').openModal()
            $scope.verifyCallback = () ->
                if state
                    $scope.submitAddRollCall(period, studentId)
                else
                    $scope.submitDestroyRollCall(period, studentId)


        $scope.submitAddRollCall = (period, studentId) ->
            $scope.requestLoading = true
            Admin.addRollCall(
                period,
                $scope.rollCallPicker.getDate().getTime(),
                studentId
            ).then ((data) ->
                Materialize.toast("以登記缺課", 2000)
                $scope.requestLoading = false
                $scope.rollCallReqSuccess.period = period
                $scope.rollCallReqSuccess.studentId = studentId
                console.log($scope.rollCallReqSuccess)
            ), (msg) ->
                Materialize.toast(msg, 2000)
                $scope.requestLoading = false

        $scope.submitDestroyRollCall = (period, studentId) ->
            $scope.requestLoading = true
            Admin.destroyRollCall(
                period,
                $scope.rollCallPicker.getDate().getTime(),
                studentId
            ).then ((data) ->
                Materialize.toast("以取消登記缺課", 2000)
                $scope.requestLoading = false
                $scope.rollCallReqSuccess.period = period
                $scope.rollCallReqSuccess.studentId = studentId
            ), (msg) ->
                Materialize.toast(msg, 2000)
                $scope.requestLoading = false

        $scope.submitDeleteStudent = () ->
            $scope.requestLoading = true
            Admin.removeStudent(
                $scope.selectedStudent.id,
            ).then ((data) ->
                Materialize.toast("刪除學生成功", 2000)
                $scope.prepareListStudentWithoutGroup()
                $scope.requestLoading = false
            ), (msg) ->
                Materialize.toast(msg, 2000)
                $scope.requestLoading = false

        $scope.submitScore = (number) ->
            $('#verify-modal').openModal()
            $scope.verifyCallback = () ->
                Admin.createScore(
                    $scope.selectedGroup.project.id,
                    $scope.scoreForm[number].point
                    number,
                ).then ((data) ->
                    Materialize.toast("分數送出成功", 2000)
                    Admin.allScores($scope.selectedGroup.project.id, number).then ((data) ->
                        $scope.scores[number] = data
                    )
                ), (msg) ->
                    Materialize.toast(msg, 2000)

        $scope.submitDestroyScore = (scoreId, number) ->
            $('#verify-modal').openModal()
            $scope.verifyCallback = () ->
                Admin.destroyScore(
                    scoreId
                ).then ((data) ->
                    Materialize.toast("分數刪除成功", 2000)
                    Admin.allScores($scope.selectedGroup.project.id, number).then ((data) ->
                        $scope.scores[number] = data
                    )
                ), (msg) ->
                    Materialize.toast(msg, 2000)

        $scope.submitAddTeachingAssistant = () ->
            $scope.requestLoading = true
            Admin.addTeachingAssistant(
                $scope.addTeachingForm.id,
                $scope.addTeachingForm.name,
                $scope.addTeachingForm.className,
                $scope.addTeachingForm.courseId
            ).then ((data) ->
                Materialize.toast("增加助教成功", 2000)
                $scope.prepareManage()
                $scope.requestLoading = false
            ), (msg) ->
                Materialize.toast(msg, 2000)
                $scope.requestLoading = false

        $scope.resetPassword = () ->
            $scope.requestLoading = true
            Admin.resetPassword(
                $scope.passwordForm.password
            ).then ((data) ->
                Materialize.toast("修改密碼成功", 2000)
                $scope.requestLoading = false
            ), (msg) ->
                Materialize.toast(msg, 2000)
                $scope.requestLoading = false

        $scope.selectCourse = (course) ->
            $scope.inCreatingCourse = false
            $scope.inCourse = true
            $scope.selectedCourse = course
            $scope.prepareSelectedCourse(course)

        scoresQuery.drain = () ->
            $timeout(() ->
                $('#timelog-modal').openModal();
            )

        $scope.openTimelogModal = (group) ->
            $scope.selectedGroup = group
            if group.project?
                Admin.showTimelog(group.project.id).then ((data) ->
                    $scope.timelogs = data
                    scoresQuery.push({
                        do: Admin.allScores(group.project.id, 0)
                        callback: (data) ->
                            $scope.scores[0] = data
                    })
                    scoresQuery.push({
                        do: Admin.allScores(group.project.id, 1)
                        callback: (data) ->
                            $scope.scores[1] = data
                    })
                ), (msg) ->
            else
                Materialize.toast("沒有專案可以顯示", 2000)

        $scope.openDeleteModal = (student) ->
            $scope.selectedStudent = student
            $timeout(() ->
                $('#delete-student-modal').openModal();
            )

        $scope.createTimelog = () ->
            $scope.requestLoading = true
            transferDate = $scope.picker.getDate().getTime()
            Admin.createTimelog(transferDate, $scope.selectedCourse.id).then ((date) ->
                $scope.requestLoading = false
                Materialize.toast("新增Timelog成功", 2000)
            ), (msg) ->
                Materialize.toast(msg, 2000)
                $scope.requestLoading = false

        $scope.editTimelogAcceptance = (group) ->
            timelog = group.project.latest_timelog
            $('#verify-modal').openModal()
            $scope.verifyCallback = () ->
                $scope.requestLoading = true
                Admin.editTimelogAcceptance(timelog.acceptance, timelog.id).then ((data) ->
                    $scope.requestLoading = false
                    if timelog.acceptance
                        Materialize.toast("登記驗收成功", 2000)
                    else
                        Materialize.toast("取消登記驗收成功", 2000)
                    $scope.groupReqSuccessId = group.id
                ), (msg) ->
                    Materialize.toast(msg, 2000)
                    $scope.requestLoading = false

        $scope.isGroupReqSuccess = (group) ->
            if group.id == $scope.groupReqSuccessId
                return true
            false

        $scope.isHomeworkReqSuccess = (student) ->
            if student.id == $scope.studentReqSuccessId
                return true
            false

        $scope.isRollCallReqSuccess = (studentId, period) ->
            if $scope.rollCallReqSuccess.period == period and $scope.rollCallReqSuccess.studentId == studentId
                return true
            false

        $scope.checkRollCalls = (students) ->
            for student in students
                if student.roll_calls?
                    for rollCall in student.roll_calls
                        if rollCall.period == 0
                            student.rollCall1 = true
                        else if rollCall.period == 1
                            student.rollCall2 = true
                        else if rollCall.period == 2
                            student.rollCall3 = true

        q.drain = () ->
            $scope.layout.loading = false

        $scope.prepareManage = () ->
            $q (resolve, reject) ->
                $scope.loading = true
                Admin.listTeachingAssistants().then ((data) ->
                    $scope.teachingAssistants = data
                    $scope.loading = false
                    resolve()
                ), (msg) ->
                    $scope.loading = false
                    resolve()

        $scope.prepareCourse = (course) ->
            $q (resolve, reject) ->
                $scope.loading = true
                Admin.allCourse().then ((data) ->
                    $scope.courses = data
                    $scope.loading = false
                    resolve()
                ), (msg) ->
                    $scope.loading = false
                    resolve()


        $scope.prepareAllGroup = () ->
            $q (resolve, reject) ->
                Admin.allGroup($scope.selectedCourse.id).then ((data) ->
                    $scope.groups = Group.handleAllGroup(data)
                    resolve()
                ), (msg) ->
                    resolve()

        $scope.prepareAllHomeworks= () ->
            $q (resolve, reject) ->
                Admin.allHomeworks($scope.selectedCourse.id).then ((data) ->
                    $scope.homeworks = data
                    resolve()
                ), (msg) ->
                    resolve()

        $scope.prepareAllStudents = () ->
            $q (resolve, reject) ->
                transferDate = new Date().getTime()
                if $scope.rollCallPicker?
                    transferDate = $scope.rollCallPicker.getDate().getTime()
                Admin.allStudents($scope.selectedCourse.id, transferDate).then ((data) ->
                    $scope.students = data
                    checkedDeliverHomework($scope.homeworks, $scope.students)
                    $scope.checkRollCalls($scope.students)
                    resolve()
                ), (msg) ->
                    resolve()

        $scope.prepareListStudentWithoutGroup = () ->
            $q (resolve, reject) ->
                Admin.listStudentWithoutGroup($scope.selectedCourse.id).then ((data) ->
                    $scope.studentsWithoutGroup = data
                    resolve()
                ), (msg) ->
                    resolve()

        $scope.prepareSetting = () ->
            $timeout(() ->
                $('.collapsible').collapsible({
                    accordion: false
                })
            )

        courseQuery.drain = () ->
            $scope.courseLoading = false
            renderTabs()
            renderImage()
            $timeout(() ->
                $scope.picker = new Pikaday({field: $('#datepicker')[0]})
                $('.modal-trigger').leanModal();
                $('.collapsible').collapsible({
                    accordion: false
                })
            )

        $scope.prepareSelectedCourse = (course) ->
            $scope.courseLoading = true
            courseQuery.push($scope.prepareAllGroup)
            courseQuery.push($scope.prepareListStudentWithoutGroup)
            courseQuery.push($scope.prepareAllHomeworks)
            courseQuery.push($scope.prepareAllStudents)

        $scope.prepareAll = () ->
            $scope.layout.loading = true
            q.push($scope.prepareCourse)

        renderImage = () ->
            $timeout(() ->
                $('.materialboxed').materialbox()
            )

        renderRollCallDate = () ->
            $timeout(() ->
                $scope.rollCallDate ?= new Date()
                $scope.rollCallPicker = new Pikaday(
                    field: $('#rollCallDatepicker')[0]
                    onSelect: () ->
                        $scope.prepareAllStudents()
                        $scope.rollCallDate = $scope.rollCallPicker.getDate()
                )
                $scope.rollCallPicker.setDate($scope.rollCallDate)

            )

        renderTabs = () ->
            $timeout(() ->
                $('ul.tabs').tabs();
            )

        $scope.layout.loading = true
        Admin.verifyAccessToken().then ((data) ->
            $scope.layout.loading = false
            $scope.prepareAll()
        ), (msg) ->
            $scope.layout.loading = false
            $state.go('main.started')


])
.directive('comparePassword', () ->
    {
        require: "ngModel",
        scope: {
            otherModelValue: "=comparePassword"
        },
        link: (scope, element, attributes, ngModel) ->
            ngModel.$validators.compareTo = (modelValue) ->
                modelValue == scope.otherModelValue;
            scope.$watch("otherModelValue", () ->
                ngModel.$validate()
            )
    }
)