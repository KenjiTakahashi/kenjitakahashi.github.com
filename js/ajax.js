(function() {

  window.ajax = function(url) {
    return $.ajax({
      url: url,
      success: function(html) {
        var $center;
        $center = $("#center");
        return $center.hide('highlight', {
          color: "#FFFFFF"
        }, function() {
          $center.empty();
          $center.append(html);
          $center.children().hide();
          $center.show();
          return $center.children(".title").show('slide', function() {
            return $center.children(".content").show('blind');
          });
        });
      }
    });
  };

}).call(this);
