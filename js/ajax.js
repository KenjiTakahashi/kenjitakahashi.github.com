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
        return $center.children("#livefyre").show();
      });
    });
  };

}).call(this);
