var currentform;
var copyField;

var select;

var statusMessage = 0;

/* keep trtack of current page, and trigger refresh if we 'pop'
   a different page (back/forward buttons) */
if (typeof(lastUrl)=='undefined')  var lastUrl=document.URL;
window.onpopstate = function(event)  {
  if (document.URL != lastUrl) location.reload();
};


function init(){
}


// MISCELANEOUS PAGE EVENT HANDLING THAT HAVE NOTHING TO DO WITH THE MAP

function signupHandler() {
      if($('#user_upassword_confirmation').val()!=$('#user_upassword').val()) {
          alert('Passwords do not match');
          $('#user_upassword').val('');
          $('#user_upassword_confirmation').val('')
          event.preventDefault();
          return false;
      }
      var rsa = new RSAKey();
      rsa.setPublic($('#public_modulus').val(), $('#public_exponent').val());
      var res = rsa.encrypt($('#user_upassword').val());
      if (res) {
        $('#user_password').val(hex2b64(res));
        $('#user_upassword').val('');
        $('#user_upassword_confirmation').val('')
        return true;
      }
      alert('Password encryption failed');
      return false;
}

function signinHandler() {
      var rsa = new RSAKey();
      rsa.setPublic($('#public_modulus').val(), $('#public_exponent').val());
      var res = rsa.encrypt($('#session_upassword').val());
      if (res) {
        $('#session_password').val(hex2b64(res));
        $('#session_upassword').val('');
        return true;
      }
      alert('Password encryption failed');
      return false;
}

function linkHandler(entity_name) {
    /* close the dropdown */
    $('.dropdown').removeClass('open');

    /* show 'loading ...' */
    document.getElementById("page_status").innerHTML = 'Loading ...'
    $(function() {
     $.rails.ajax = function (options) {
       options.tryCount= (!options.tryCount) ? 0 : options.tryCount;0;
       options.timeout = 15000*(options.tryCount+1);
       options.retryLimit=3;
       options.complete = function(jqXHR, thrownError) {
         /* complete also fires when error ocurred, so only clear if no error has been shown */
         if(thrownError=="timeout") {
           this.tryCount++;
           document.getElementById("page_status").innerHTML = 'Retrying ...';
           this.timeout=15000*this.tryCount;
           if(this.tryCount<=this.retryLimit) {
             $.rails.ajax(this);
           } else {
             document.getElementById("page_status").innerHTML = 'Timeout';
           }
         }
         if(thrownError=="error") {
           if(jqXHR.status=="409") {
             document.getElementById("page_status").innerHTML = 'Item exists (duplicate save)';
             alert("Error 409: Your item has been saved (we've checked), but the original response from the server was lost.  You can safely navigate away from this page using the menus at the top of the screen.  Use Add -> Route if you wish to continue adding route segments.");
           } else {
             document.getElementById("page_status").innerHTML = 'Error: '+jqXHR.status;
           }

         } 
         if(thrownError=="success") {
           window.scroll(0,0);
           document.getElementById("page_status").innerHTML = '';
           $("form:not(.filter) :input:visible:enabled:first").focus();
         }
         lastUrl=document.URL;
       }
       return $.ajax(options);
     };
   }); 

   
 
}


    function Popup(data, h, w) 
    {
        var mywindow = window.open('', 'routeguides.co.nz', 'height='+h+',width='+w);
        mywindow.document.write('<html><head><title>routeguides.co.nz</title>');
        mywindow.document.write('<link rel="stylesheet" type="text/css" href="/assets/print.css" /> ');
        mywindow.document.write('</head><body >');
        mywindow.document.write(data);
        mywindow.document.write('</body></html>');

        mywindow.focus(); 
        if (navigator.userAgent.toLowerCase().indexOf("chrome") < 0) {
//          mywindow.print(); 
        }
     
        mywindow.focus(); 
        return true;
    }

function loadLink(linkurl) {
   document.getElementById("page_status").innerHTML = 'Loading ...';
   var tryCount=0;
   $.ajax({
          beforeSend: function (xhr){
            xhr.setRequestHeader("Content-Type","application/javascript");
            xhr.setRequestHeader("Accept","text/javascript");
          },
          type: "GET",
          url: linkurl,
          tryCount: (!tryCount) ? 0 : tryCount,
          timeout: 5000*(tryCount+1),
          retryLimit: 3,
          complete: function(jqXHR, thrownError) {
             /* complete also fires when error ocurred, so only clear if no error has been shown */
             if(thrownError=="timeout") {
               this.tryCount++;
               document.getElementById("page_status").innerHTML = 'Retrying ...';
               this.timeout=5000*this.tryCount;
               if(this.tryCount<=this.retryLimit) {
                 $.rails.ajax(this);
               } else {
                 document.getElementById("page_status").innerHTML = 'Timeout';
               }
             }
             if(thrownError=="error") {
                  document.getElementById("page_status").innerHTML = 'Error: '+jqXHR.status;
             }
             if(thrownError=="success") {
               document.getElementById("page_status").innerHTML = '';
             }
             lastUrl=document.URL;
          }
    });


}
function showVersion() {
  loadLink(location.protocol + '//' + location.host + location.pathname+"/?version="+document.getElementById("versions").value);
}

function show_div(div) {
   document.getElementById(div).style.display="block";
}
function hide_div(div) {
   document.getElementById(div).style.display="none";
}


function getSelectedText(elementId) {
    var elt = document.getElementById(elementId);

    if (elt.selectedIndex == -1)
        return null;

    return elt.options[elt.selectedIndex].text;
}


   function clickplus(divname) {
     document.getElementById(divname).style.display = 'block';
     document.getElementById(divname+"plus").style.display="none";
     document.getElementById(divname+"minus").style.display="block";
   }


   function clickminus(divname) {
     document.getElementById(divname).style.display = 'none';
     document.getElementById(divname+"plus").style.display="block";
     document.getElementById(divname+"minus").style.display="none";
   }

function search_huts(field) {
        BootstrapDialog.show({
            title: "Select hut",
            message: $('<div id="info_details2">Retrieving ...</div>'),
            size: "size-small"
        });

        $.ajax({
          beforeSend: function (xhr){
            xhr.setRequestHeader("Content-Type","application/javascript");
            xhr.setRequestHeader("Accept","text/javascript");
          },
          type: "GET",
          timeout: 10000,
          url: "/query?hutfield="+field,
          error: function() {
              document.getElementById("info_details2").innerHTML = 'Error contacting server';
          },
          complete: function() {
              document.getElementById("page_status").innerHTML = '';
          }

        });
 return(false);
}

function attach_file(post_id) {
        BootstrapDialog.show({
            title: "Select attachment",
            message: $('<div id="info_details2">Retrieving ...</div>'),
            size: "size-small"
        });

        $.ajax({
          data: { authenticity_token: window._token },
          beforeSend: function (xhr){
            xhr.setRequestHeader("Content-Type","application/javascript");
            xhr.setRequestHeader("Accept","text/javascript");
          },
          type: "GET",
          timeout: 10000,
          url: "/files/new?post_id="+post_id,
          error: function() {
              document.getElementById("info_details2").innerHTML = 'Error contacting server';
          },
          complete: function() {
              document.getElementById("page_status").innerHTML = '';
          }

        });
 return(false);
}

function submit_search() {
   return false;  
}

function select_hut(field, id, name, x, y, loc, park, park_name) {
  if (field=="hut1") {
    document.contactform.contact_hut1_id.value=id;
    document.contactform.hut1_name.value=name;
    document.contactform.contact_x1.value=x;
    document.contactform.contact_y1.value=y;
    document.contactform.contact_location1.value=loc;
    document.contactform.contact_park1_id.value=park;
    document.contactform.park1_name.value=park_name;
  }
  if (field=="hut2") {
    document.contactform.contact_hut2_id.value=id;
    document.contactform.hut2_name.value=name;
    document.contactform.contact_x2.value=x;
    document.contactform.contact_y2.value=y;
    document.contactform.contact_location2.value=loc;
    document.contactform.contact_park2_id.value=park;
    document.contactform.park2_name.value=park_name;
  }
  return false;
}


function clear_hut(field) {
  if (field=="hut1") {
    document.contactform.contact_hut1_id.value=""
    document.contactform.hut1_name.value="";
  }
  if (field=="hut2") {
    document.contactform.contact_hut2_id.value="";
    document.contactform.hut2_name.value="";
  }
  return false;

}
function submit_search() {
   return false;
}

