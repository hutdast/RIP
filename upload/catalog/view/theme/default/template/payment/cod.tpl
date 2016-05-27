<div class="buttons">
  <div class="pull-right">
   <input style="display:none;" type="button" value="<?php echo $button_confirm; ?>" id="button-confirm" class="btn btn-primary" data-loading-text="<?php echo $text_loading; ?>" />
 </div>
<div class="pull-left">
<input style="display:none;" type="button" value="Cancel Payment" id="btn-void" class="btn btn-primary" />
</div>
</div>
<script type="text/javascript"><!--
$('#btn-void').on('click', function() {
$.ajax({
    url: 'https://rustikimagephotography.com/upload/index.php?route=payment/cod/voidPayment',
            type: 'get',
           complete: function() {
	       alert('complete');
           },   
          success: function(json) {
		if(!json['errors']){
                          alert('Your payment has been cancelled');
		}else{
			alert('Your payment cancellation did not go through,please contact administration');
		}
            },          
            error: function(xhr, ajaxOptions, thrownError) {
            alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
            }
    });

});



$('#button-confirm').on('click', function() {
	$.ajax({
		type: 'get',
		url: 'index.php?route=payment/cod/confirm',
		cache: false,
		
		complete: function() {
			$('#button-confirm').button('reset');
		},
		success: function() {
			location = '<?php echo $continue; ?>';
		}
	});
});
//--></script>
