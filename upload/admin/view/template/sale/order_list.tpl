<?php echo $header; ?><?php echo $column_left; ?>
<div id="content">
    <div class="page-header">

        <div class="container-fluid">

            <h1><?php echo $heading_title; ?></h1>
            <ul class="breadcrumb">
                <?php foreach ($breadcrumbs as $breadcrumb) { ?>
                <li><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a></li>
                <?php } ?>
            </ul>
        </div>
    </div>
    <div class="container-fluid">
        <div class="panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-list"></i> <?php echo $text_list; ?></h3>
            </div>
            <div class="panel-body">





                <form method="post" enctype="multipart/form-data" target="_blank" id="form-order">
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover">
                            <thead>
                                <tr>
                                    <td style="width: 1px;" class="text-center"><input type="checkbox" onclick="$('input[name*=\'selected\']').prop('checked', this.checked);" /></td>

                                    <td class="text-right">
                                        Customer ID
                                    </td>
                                    <td class="text-right">
                                        Customer
                                    </td>
                                    <td class="text-left">
                                        Product &AMP; Description
                                    </td>

                                    <td class="text-right">
                                        Status
                                    </td>
                                    <td class="text-left">
                                        Date Added
                                    </td>

                                    <td class="text-right"><?php echo $column_action; ?></td>
                                </tr>
                            </thead>
                            <tbody>
                                <?php if ($rust_order) { ?>
                                <?php foreach ($rust_order as $order) { ?>
                                <tr>
                                    <td class="text-center"><?php if (in_array($order['rustik_order_id'], $selected)) { ?>
                                        <input type="checkbox" name="selected[]" value="<?php echo $order['rustik_order_id']; ?>" checked="checked" />
                                        <?php } else { ?>
                                        <input type="checkbox" name="selected[]" value="<?php echo $order['rustik_order_id']; ?>" />
                                        <?php } ?>
                                    </td>

                                    <td class="text-right"><?php echo $order['customer_id']; ?></td>

                                    <td class="text-right"><?php echo $order['customer']; ?></td>
                                    <td class="text-left">
                                        <ul>
                                            <?php foreach ( unserialize($order['products']) as $product) { ?>
                                            <li>Tag: <?php echo $product['product_name']; ?> <> <?php echo $product['description']; ?>
                                                <> Qty: <?php echo $product['quantity']; ?></li>

                                            <?php } ?>
                                        </ul>
                                    </td>
                                    <td contenteditable="true" id="<?php echo $order['rustik_order_id'].'~!'.$order['date_added']; ?>" class="text-left edit">
                                        <i class="fa fa-pencil"></i> <?php echo $order['status']; ?></td>
                                    <td class="text-right"><?php echo $order['date_added']; ?></td>

                                    <td class="text-right"> 
                                        <button type="button" value="<?php echo $order['order_id']; ?>" id="<?php echo $order['rustik_order_id']; ?>"  class="btn btn-danger delete"><i class="fa fa-trash-o"></i></button></td>
                                </tr>
                                <?php } ?>
                                <?php } else { ?>
                                <tr>
                                    <td class="text-center" colspan="8"><?php echo $text_no_results; ?></td>
                                </tr>
                                <?php } ?>
                            </tbody>
                        </table>
                    </div>
                </form>
                <div class="row">
                    <div class="col-sm-6 text-left"><?php echo $pagination; ?></div>
                    <div class="col-sm-6 text-right"><?php echo $results; ?></div>
                </div>
            </div>
        </div>
    </div>
  <script type="text/javascript"><!--
      //RIP modifications: editing the status of the order
      $('.edit').on('blur', function () {
         
          var data= $(this).attr('id').split('~!');
         var status = $(this).text().trim(" ");
      
          var url = 'index.php?route=sale/order/edit&id='+encodeURIComponent(data[0])
                  +'&date='+ encodeURIComponent(data[1])+'&status='+status+' &token=<?php echo $token; ?>';
          location = url;
      });
       $('.delete').on('click', function () {
           var url = 'index.php?route=sale/order/delete&id='+encodeURIComponent($(this).attr('id'))+'&token=<?php echo $token; ?>';
           location = url;
       });
      
      
      

//--></script>
  <script type="text/javascript"><!--
$('input[name=\'filter_customer\']').autocomplete({
	'source': function(request, response) {
		$.ajax({
			url: 'index.php?route=customer/customer/autocomplete&token=<?php echo $token; ?>&filter_name=' +  encodeURIComponent(request),
			dataType: 'json',
			success: function(json) {
				response($.map(json, function(item) {
					return {
						label: item['name'],
						value: item['customer_id']
					}
				}));
			}
		});
	},
	'select': function(item) {
		$('input[name=\'filter_customer\']').val(item['label']);
	}
});
//--></script>
  <script type="text/javascript"><!--
$('input[name^=\'selected\']').on('change', function() {
	$('#button-shipping, #button-invoice').prop('disabled', true);

	var selected = $('input[name^=\'selected\']:checked');

	if (selected.length) {
		$('#button-invoice').prop('disabled', false);
	}

	for (i = 0; i < selected.length; i++) {
		if ($(selected[i]).parent().find('input[name^=\'shipping_code\']').val()) {
			$('#button-shipping').prop('disabled', false);

			break;
		}
	}
});

$('input[name^=\'selected\']:first').trigger('change');

// Login to the API
var token = '';

$.ajax({
	url: '<?php echo $store; ?>index.php?route=api/login',
	type: 'post',
	data: 'key=<?php echo $api_key; ?>',
	dataType: 'json',
	crossDomain: true,
	success: function(json) {
        $('.alert').remove();

        if (json['error']) {
    		if (json['error']['key']) {
    			$('#content > .container-fluid').prepend('<div class="alert alert-danger"><i class="fa fa-exclamation-circle"></i> ' + json['error']['key'] + ' <button type="button" class="close" data-dismiss="alert">&times;</button></div>');
    		}

            if (json['error']['ip']) {
    			$('#content > .container-fluid').prepend('<div class="alert alert-danger"><i class="fa fa-exclamation-circle"></i> ' + json['error']['ip'] + ' <button type="button" id="button-ip-add" data-loading-text="<?php echo $text_loading; ?>" class="btn btn-danger btn-xs pull-right"><i class="fa fa-plus"></i> <?php echo $button_ip_add; ?></button></div>');
    		}
        }

		if (json['token']) {
			token = json['token'];
		}
	},
	error: function(xhr, ajaxOptions, thrownError) {
		alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
	}
});

$(document).delegate('#button-ip-add', 'click', function() {
	$.ajax({
		url: 'index.php?route=user/api/addip&token=<?php echo $token; ?>&api_id=<?php echo $api_id; ?>',
		type: 'post',
		data: 'ip=<?php echo $api_ip; ?>',
		dataType: 'json',
		beforeSend: function() {
			$('#button-ip-add').button('loading');
		},
		complete: function() {
			$('#button-ip-add').button('reset');
		},
		success: function(json) {
			$('.alert').remove();

			if (json['error']) {
				$('#content > .container-fluid').prepend('<div class="alert alert-danger"><i class="fa fa-exclamation-circle"></i> ' + json['error'] + ' <button type="button" class="close" data-dismiss="alert">&times;</button></div>');
			}

			if (json['success']) {
				$('#content > .container-fluid').prepend('<div class="alert alert-success"><i class="fa fa-check-circle"></i> ' + json['success'] + ' <button type="button" class="close" data-dismiss="alert">&times;</button></div>');
			}
		},
		error: function(xhr, ajaxOptions, thrownError) {
			alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
		}
	});
});

$('button[id^=\'button-delete\']').on('click', function(e) {
	if (confirm('<?php echo $text_confirm; ?>')) {
		var node = this;

		$.ajax({
			url: '<?php echo $store; ?>index.php?route=api/order/delete&token=' + token + '&order_id=' + $(node).val(),
			dataType: 'json',
			crossDomain: true,
			beforeSend: function() {
				$(node).button('loading');
			},
			complete: function() {
				$(node).button('reset');
			},
			success: function(json) {
				$('.alert').remove();

				if (json['error']) {
					$('#content > .container-fluid').prepend('<div class="alert alert-danger"><i class="fa fa-exclamation-circle"></i> ' + json['error'] + ' <button type="button" class="close" data-dismiss="alert">&times;</button></div>');
				}

				if (json['success']) {
					$('#content > .container-fluid').prepend('<div class="alert alert-success"><i class="fa fa-check-circle"></i> ' + json['success'] + ' <button type="button" class="close" data-dismiss="alert">&times;</button></div>');
				}
			},
			error: function(xhr, ajaxOptions, thrownError) {
				alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
			}
		});
	}
});
//--></script>
  <script src="view/javascript/jquery/datetimepicker/bootstrap-datetimepicker.min.js" type="text/javascript"></script>
  <link href="view/javascript/jquery/datetimepicker/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" media="screen" />
  <script type="text/javascript"><!--
$('.date').datetimepicker({
	pickTime: false
});
//--></script></div>
<?php echo $footer; ?>

