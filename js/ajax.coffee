window.ajax = (url) ->
    $.get(url, (html) ->
        $center = $("#center")
        $center.hide('highlight', {color: "#FFFFFF"}, ->
            $center.empty()
            $center.append(html)
            $center.children().hide()
            $center.show()
            $center.children(".title").show('slide', ->
                $center.children(".content").show('blind')
            )
            $center.children("#disqus_thread").show()
            $("#disqus_thread").disqus({
                domain: 'kenjitakahashi'
                title: document.title
                developer: 1
                show_count: true
                ready: ->
                    console.log(1)
            })
        )
    )
