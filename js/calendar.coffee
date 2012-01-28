dates = {"2012-01-01": [["A Test...", "/2012/01/01/a-test.html"]], "2012-01-02": [["a very long title to test side-pane...", "/2012/01/02/a-long-title.html"]], "2012-01-14": [["Another test...", "/2012/01/14/test-2.html"], ["testing 2-on-1...", "/2012/01/14/test-3.html"]]}
jQuery.datepicker.oldAdjustDate = jQuery.datepicker._adjustDate
jQuery.datepicker._adjustDate = (id, offset, period) ->
    jQuery.datepicker.oldAdjustDate(id, offset, period)
    this._notifyChange(this._getInst($(id)[0]))
jQuery.datepicker.oldSelectDate = jQuery.datepicker._selectDate
jQuery.datepicker._selectDate = (id, dateStr) ->
    jQuery.datepicker.oldSelectDate(id, dateStr)
    this._notifyChange(this._getInst($(id)[0]))
$(document).ready( ->
    options = {
        direction: 'down'
        duration: 'medium'
        easing: 'easeOutQuart'
    }
    arrowsWidth = ->
        $title = $(".ui-datepicker-title")
        width = (252 - parseInt($title.css('width'))) / 2
        $(".ui-datepicker-next, .ui-datepicker-prev").width(width)
        $title.css('display', 'block')
    callback = ($base, dateText) ->
        $base.empty()
        date = dateText.split('/').reverse()
        [date[1], date[2]] = [date[2], date[1]]
        for v in dates[date.join('-')]
            $href = $("<a class='event' href='##{v[1]}'>").text(v[0])
            $href.click( ->
                $.ajax({
                    url: v[1]
                    success: (html) ->
                        $center = $("#center")
                        $center.hide('highlight', {color: "#FFFFFF"}, ->
                            $center.empty()
                            $center.append(html)
                            $center.children().hide()
                            $center.show()
                            $center.children(".title").show('slide', ->
                                $center.children(".content").show('blind')
                            )
                        )
                })
            )
            $base.append($href)
        $base.css('bottom', $("#calendar").css('height'))
        $base.toggle('slide', options)
    $("#calendar").datepicker({
        showOtherMonths: true
        selectOtherMonths: true
        beforeShowDay: (date) ->
            for d, _ of dates
                if new Date(Date.parse(d)).setHours(0, 0, 0, 0) == date.setHours(0, 0, 0, 0)
                    return [true, '']
            return [false, '']
        onSelect: (dateText, inst) ->
            $base = $("#events")
            if $base.css('display') != 'none'
                $base.toggle('slide', options, -> callback($base, dateText))
            else
                callback($base, dateText)
        onChangeMonthYear: (year, month, inst) ->
            $base = $("#events")
            if $base.css('display') != 'none'
                $base.css('bottom', $("#calendar").css('height'))
            arrowsWidth()
    })
    arrowsWidth()
)