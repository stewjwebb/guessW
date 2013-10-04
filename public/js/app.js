
  // reading
  var es = new EventSource('/stream');
  es.onmessage = function(e) { $('#chat').append(e.data + "\n"); };

  // writing
  $('form[name=myform]').on('submit',function(e) {
    $.post('/', {msg: "<%= user %>: " + $('#msg').val()});
    $('#msg').val(''); $('#msg').focus();
    e.preventDefault();
  });

  $('[data-pick]').on('click',function(e) {
    $.ajax({url: "/pick/"+$(this).data("pick"), type: "put", success: function() { return location.reload();}});
  });
