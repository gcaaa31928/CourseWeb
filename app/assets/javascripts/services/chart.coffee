angular.module('courseWebApp').factory 'Chart', [
    '$http',
    '$q',
    '$timeout',
    'Student'
    ($http, $q, $timeout, Student) ->
        factory = {}
        factory.selfCommitTimes = []
        factory.highStandardCommitTimes = []
        factory.lowStandardCommitTimes = []
        factory.averageCommitTimes = []
        factory.commitChartElement = '#commitChart'
        factory.locChartElement = '#locChart'
        factory.timelogChartElement = '#timelogChart'

        remoteDataToChartsData = (data) ->
            chart_logs = []
            for key, value of data
                chart_log = [Date.parse(key), value]
                chart_logs.push(chart_log)
            chart_logs

        factory.getCommitsChart = () ->
            $q (resolve, reject) ->
                Student.showCommitsChart().then ((data) ->
                    factory.selfCommitTimes = remoteDataToChartsData(data.you)
                    factory.averageCommitTimes = remoteDataToChartsData(data.average)
                    factory.highStandardCommitTimes = remoteDataToChartsData(data.high_standard)
                    factory.lowStandardCommitTimes = remoteDataToChartsData(data.low_standard)
                    resolve()
                ), (msg) ->
                    resolve()

        factory.chartInformation = (title, unit, selfValue, standardValues, highStandardValues, lowStandardValues) ->
            title:
                text: title,
                x: -20
            subtitle:
                text: '',
                x: -20
            xAxis:
                type: 'datetime'
                dateTimeLabelFormats:
                    day: '%e. %b'
            yAxis:
                title:
                    text: unit
                plotLines: [{
                    value: 0,
                    width: 1,
                    color: '#808080'
                }]
            legend:
                layout: 'vertical',
                align: 'right',
                verticalAlign: 'middle',
                borderWidth: 0
            series: [{
                name: '高標',
                data: highStandardValues
            }, {
                name: '均標',
                data: standardValues
            }, {
                name: '低標',
                data: lowStandardValues
            }, {
                name: '你',
                data: selfValue
            }]
        factory.renderCommitCharts = () ->

            $timeout(() ->
                $(factory.commitChartElement).highcharts(
                    factory.chartInformation('Commit 次數', '次數', factory.selfCommitTimes, factory.averageCommitTimes,
                        factory.highStandardCommitTimes, factory.lowStandardCommitTimes)
                )
                $(factory.locChartElement).highcharts(
                    factory.chartInformation('程式行數', '行', factory.selfCommitTimes, factory.averageCommitTimes,
                        factory.highStandardCommitTimes, factory.lowStandardCommitTimes)
                )
                $(factory.timelogChartElement).highcharts(
                    factory.chartInformation('時間', '小時', factory.selfCommitTimes, factory.averageCommitTimes,
                        factory.highStandardCommitTimes, factory.lowStandardCommitTimes)
                )
            )
        factory
]