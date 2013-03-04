$(function() {
    function unifyHeights() {
        var maxHeight = 0;
        $('#wrapper').children('#leftMenu, #mainContainer').each(function() {
            var height = $(this).outerHeight();
          //  alert(height);
            if ( height > maxHeight ) {
                maxHeight = height;
            }
        });
        $('#leftMenu, #mainContainer').css('height', maxHeight);
        //alert($('#leftMenu'));
    }
    unifyHeights();
  });