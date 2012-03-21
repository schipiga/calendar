$(document).ready(function(){

  $('#sign_up').click(function(){
    $('.registration').css('display', 'block');
  });

  $('#recovery_pswd').click(function(){
    $('.recovery').css('display', 'block');
  });

//********* Registration **************

  $('#registration_close').click(function(){
    $('.registration').css('display', 'none');
  });

//********* Recovery ******************

  $('#recovery_close').click(function(){
    $('.recovery').css('display', 'none');
  });

});

