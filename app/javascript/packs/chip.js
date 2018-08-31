  document.addEventListener('DOMContentLoaded', function() {
    var elems = document.querySelectorAll('.chips');
    var instances = M.Chips.init(elems, options);
  });

  var chip = {
    tag: 'chip content',
    image: '', //optional
  };

  var instance = M.Chips.getInstance(elem)

