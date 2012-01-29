(function() {

  window.ajax = function(url) {
    return $.get(url, function(html) {
      var $center;
      $center = $("#center");
      return $center.hide('highlight', {
        color: "#FFFFFF"
      }, function() {
        $center.empty();
        $center.append(html);
        $center.children().hide();
        $center.show();
        $center.children(".title").show('slide', function() {
          return $center.children(".content").show('blind');
        });
        $center.children("#disqus_thread").show();
        return $("#disqus_thread").disqus({
          domain: 'kenjitakahashi',
          title: document.title,
          developer: 1,
          show_count: true,
          ready: function() {
            return console.log(1);
          }
        });
      });
    });
  };

}).call(this);
