angular.module('courseWebApp').factory 'Chart', [
    '$http',
    '$q',
    '$timeout'
    ($http, $q, $timeout) ->
        factory = {}
        factory.selfCommitTimes = [3.9, 4.2, 5.7, 8.5, 11.9, 15.2, 17.0, 16.6, 14.2, 10.3, 6.6, 4.8]
        factory.highStandardCommitTimes = [7.0, 50.9, 9.5, 14.5, 18.2, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6]
        factory.lowStandardCommitTimes = [-0.9, 0.6, 3.5, 8.4, 13.5, 17.0, 18.6, 17.9, 14.3, 9.0, 3.9, 1.0]
        factory.standardCommitTimes = [-0.2, 0.8, 5.7, 11.3, 17.0, 22.0, 24.8, 24.1, 20.1, 14.1, 8.6, 2.5]
        factory.commitChartElement = '#commitChart'
        factory.locChartElement = '#locChart'
        factory.timelogChartElement = '#timelogChart'

        factory.chartInformation = (title, unit, selfValue, standardValues, highStandardValues, lowStandardValues) ->
            title:
                text: title,
                x: -20
            subtitle:
                text: '',
                x: -20
            xAxis:
                categories: ['1', '2', '3', '4', '5', '6',
                    '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18']
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
                    factory.chartInformation('Commit 次數', '次數', factory.selfCommitTimes, factory.standardCommitTimes,
                        factory.highStandardCommitTimes, factory.lowStandardCommitTimes)
                )
                $(factory.locChartElement).highcharts(
                    factory.chartInformation('程式行數', '行', factory.selfCommitTimes, factory.standardCommitTimes,
                        factory.highStandardCommitTimes, factory.lowStandardCommitTimes)
                )
                $(factory.timelogChartElement).highcharts(
                    factory.chartInformation('時間', '小時', factory.selfCommitTimes, factory.standardCommitTimes,
                        factory.highStandardCommitTimes, factory.lowStandardCommitTimes)
                )
            )
        factory
]