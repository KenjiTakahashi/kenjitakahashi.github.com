window.ajax = (url) ->
    $.ajax({
        url: url
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
