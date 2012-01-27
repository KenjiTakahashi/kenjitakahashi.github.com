dates = {
    '2012-01-01': ['sth']
    '2012-01-04': []
}
$(document).ready( ->
    $("#calendar").datepicker({
        showOtherMonths: true
        selectOtherMonths: true
        beforeShowDay: (date) ->
            for d, _ of dates
                if new Date(Date.parse(d)).setHours(0, 0, 0, 0) == date.setHours(0, 0, 0, 0)
                    return [true, '']
            return [false, '']
        onSelect: (dateText, inst) ->
            alert(new Date(dateText))
    })
)
