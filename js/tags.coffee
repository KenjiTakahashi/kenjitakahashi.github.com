tags = {"calendar": [["Calendar to the right.", "/2012/03/18/calendar-to-the-right.html"]], "datepicker": [["Calendar to the right.", "/2012/03/18/calendar-to-the-right.html"]], "javascript": [["Calendar to the right.", "/2012/03/18/calendar-to-the-right.html"], ["Deploying meteor application to jit...", "/2012/07/07/deploying-meteor-application-to-jit.su.html"]], "jit.su": [["Deploying meteor application to jit...", "/2012/07/07/deploying-meteor-application-to-jit.su.html"]], "jquery": [["Calendar to the right.", "/2012/03/18/calendar-to-the-right.html"]], "meteor": [["Deploying meteor application to jit...", "/2012/07/07/deploying-meteor-application-to-jit.su.html"]], "this": [["Calendar to the right.", "/2012/03/18/calendar-to-the-right.html"]], "ui": [["Calendar to the right.", "/2012/03/18/calendar-to-the-right.html"]]}
$(document).ready( ->
    options = {
        duration: 'medium'
        easing: 'easeOutQuart'
    }
    callback = ($base, text) ->
        $base.empty()
        for p in tags[text]
            $href = $("<a class='tag' href='##{p[1]}'>").text(p[0])
            $href.bind('click', {url: p[1]}, (event) ->
                ajax(event.data.url)
            )
            $base.append($href)
        $base.css({
            bottom: 'auto'
            top: parseInt($("#cloud").css('height')) + 3
        })
        $base.attr('id', 'events_tag')
        options['direction'] = 'up'
        $base.toggle('slide', options)
    $("#cloud > a").click( ->
        $base = $(".events")
        text = $(this).text()
        if $base.css('display') != 'none'
            if $base.children('a').hasClass('event')
                options['direction'] = 'down'
            $base.toggle('slide', options, -> callback($base, text))
        else
            callback($base, $(this).text())
    )
)
