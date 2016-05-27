



<?php if (!isset($redirect)) { ?>
<div class="table-responsive">
  <table class="table table-bordered table-hover">
    <thead>
      <tr>
        <td class="text-left"><?php echo $column_name; ?></td>
        <td class="text-left"><?php echo $column_model; ?></td>
        <td class="text-right"><?php echo $column_quantity; ?></td>
        <td class="text-right"><?php echo $column_price; ?></td>
        <td class="text-right"><?php echo $column_total; ?></td>
      </tr>
    </thead>
    <tbody>
      <?php foreach ($products as $product) { ?>
      <tr>
          <td class="text-left"><img class="photo-size"  src="<?php echo $product['name']; ?>"/>  
          
          <?php if($product['recurring']) { ?>
          <br />
          <span class="label label-info"><?php echo $text_recurring_item; ?></span> <small><?php echo $product['recurring']; ?></small>
          <?php } ?></td>
          <td class="text-left">
               &nbsp;<small> - <?php echo $product['option']; ?></small>
          <br />
   
          </td>
        <td class="text-right"><?php echo $product['quantity']; ?></td>
        <td class="text-right"><?php echo $product['price']; ?></td>
        <td class="text-right"><?php echo $product['total']; ?></td>
      </tr>
     <?php } ?>
     
    </tbody>
    <tfoot>
      <?php foreach ($totals as $total) { ?>
      <tr>
        <td colspan="4" class="text-right"><strong><?php echo $total['title']; ?>:</strong></td>
        <td class="text-right"><?php echo $total['text']; ?></td>
      </tr>
      <?php } ?>

	<tr>
       <td colspan="4">
	<!-- Square payment -->
 <label>Card Number</label>
  <div id="sq-card-number"> </div>
  <label>CVV</label>
  <div id="sq-cvv"></div>
  <label>Expiration Date</label>
  <div id="sq-expiration-date"></div>
  <label>Postal Code</label>
  <div id="sq-postal-code"></div>
<button type="submit" class="btn btn-primary"  onclick="requestCardNonce()">Submit</button> 

	</td>
	</tr>

    </tfoot>
  </table>


</div>


<?php echo $payment; ?>
<?php } else { ?>
<script type="text/javascript"><!--
location = '<?php echo $redirect; ?>';
//--></script>
<?php } ?>

<script>                 
  var paymentForm = new SqPaymentForm({
    applicationId: 'sq0idp-Lwd43MWPdW_TUDj_5Z1jYA', // <-- REQUIRED: Add Application ID
    inputClass: 'sq-input',
    inputStyles: [
      {
        fontSize: '15px'
      }
    ],
    cardNumber: {
      elementId: 'sq-card-number',
      placeholder: '•••• •••• •••• ••••'
    },
    cvv: {
      elementId: 'sq-cvv',
      placeholder: 'CVV'
    },
    expirationDate: {
      elementId: 'sq-expiration-date',
      placeholder: 'MM/YY'
    },
    postalCode: {
      elementId: 'sq-postal-code'
    },
    callbacks: {
      cardNonceResponseReceived: function(errors, nonce, cardData) {
        if (errors) {
          // handle errors
          errors.forEach(function(error) { console.log(error.message); alert(error.message);  });
        } else {
          // handle nonce
        $.ajax({
    url: 'index.php?route=checkout/confirm/squarePayment',      
            type: 'post',
            data: {nonce :nonce,total:'<?php echo $product['total']; ?>'},
            dataType: 'json',
            complete: function() {
          $("#button-confirm").show();
	       $("#btn-void").show();
           },
          success: function(json) {
		          if(!json['error']){
		alert('payment success');
			}else{
		alert('Payment did not go thru, contact administration');          
                                                     
		}
            },
            error: function(xhr, ajaxOptions, thrownError) {
            alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
            }
    });  
	
         
        }
      },
      unsupportedBrowserDetected: function() {
        // Alert the buyer that their browser is not supported
	alert('Your browser is not compatible with our payment system');
      }
    }
  });

paymentForm.build();	

  function requestCardNonce() {            
   paymentForm.requestCardNonce();      
  }
  </script>


