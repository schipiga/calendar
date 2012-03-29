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
      var data = eval('(' + data + ')'); // covert json to hash
      $('#message_text').html(data['msg']);
      if (data['err_codes']) {
        $.each(data['err_codes'], function(index, value){
          // errors parsing: highlight fault fields
          switch (value.charAt(1)){
            case 'f':
              $('#fio').css('background', '#fff88d');
              break;
            case 'e':
              $('#email').css('background', '#fff88d');
              break;
            case 'p':
              $('#passwd').css('background', '#fff88d');
              $('#confirm_passwd').css('background', '#fff88d');
              break;
          }
        });
      }
      $('.message').css('display', 'block');
    });
  });

 /**
  * remove highlighting from "fio" field, if there is
  */
  $('#fio').live('focus', function(){
    $(this).css('background', 'white');
  });

 /**
  * remove highlighting from "email" field, if there is
  */
  $('#email').live('focus', function(){
    $(this).css('background', 'white');
  });

 /**
  * remove highlighting from "password" field, if there is
  */
  $('#passwd').live('focus', function(){
    $(this).css('background', 'white');
  });
  
 /**
  * remove highlighting from "password confirmation" field, if there is
  */
  $('#confirm_passwd').live('focus', function(){
    $(this).css('background', 'white');
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

//********* Message *******************

  $('#message_close').click(function(){
    $('.message').css('display', 'none');
  });

});
