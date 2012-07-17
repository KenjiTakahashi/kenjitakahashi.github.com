dates = {"2012-03-18": [["Calendar to the right.", "/2012/03/18/calendar-to-the-right.html"]], "2012-07-07": [["Deploying meteor application to jit...", "/2012/07/07/deploying-meteor-application-to-jit.su.html"]], "2012-07-17": [["Using passport with flatiron (or - ...", "/2012/07/17/using-passport-with-flatiron.html"]]}
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
            $href.bind('click', {url: v[1]}, (event) ->
                ajax(event.data.url)
            ) # had to do it this way, because of JS scoping-thingies...
            $base.append($href)
        $base.css('bottom', $("#calendar").css('height'))
        $base.css({
            top: 'auto'
            bottom: $("#calendar").css('height')
        })
        $base.attr('id', 'events_cal')
        options['direction'] = 'down'
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
            $base = $(".events")
            if $base.css('display') != 'none'
                if $base.children('a').hasClass('tag')
                    options['direction'] = 'up'
                $base.toggle('slide', options, -> callback($base, dateText))
            else
                callback($base, dateText)
        onChangeMonthYear: (year, month, inst) ->
            $base = $(".events")
            if $base.css('display') != 'none' and $base.children('a').hasClass('event')
                $base.css('bottom', parseInt($("#calendar").css('height')) + 5)
            arrowsWidth()
    })
    arrowsWidth()
)
