$(document).ready(function(){

 /**
  * push button 'Sign up'
  */
  $('#main_sign_up').click(function(){
    $.get(
      '/users/new.js',
      function(data){
        $('.registration_content').html('');
        $('.registration_content').append(data);
      },
      'html'
    );
    $('.registration').css('display', 'block');
  });

 /**
  * click 'Recovery password'
  */
  $('#main_recovery_pswd').click(function(){
    $.get(
      '/recoveries/new.js',
      function(data){
        $('.recovery_content').html('');
        $('.recovery_content').append(data);
      },
      'html'
    );
    $('.recovery').css('display', 'block');
  });

//********* Registration **************

 /**
  * close reginstration form
  */
  $('#registration_close').click(function(){
    $('.registration').css('display', 'none');
  });

 /**
  * create registration
  */
  $('#user_submit').live('click', function(){
    $('#u_form').ajaxForm(function(data){
      alert(data);
    });
  });

//********* Recovery ******************

 /**
  * close recovery password form
  */
  $('#recovery_close').click(function(){
    $('.recovery').css('display', 'none');
  });

 /**
  * send request for password recovery
  */
  $('#recovery_submit').live('click', function(){
    $('#r_form').ajaxForm(function(data){
      alert(data);
    });
  });

});

