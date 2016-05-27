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
    <?php if ($error_warning) { ?>
    <div class="alert alert-danger"><i class="fa fa-exclamation-circle"></i> <?php echo $error_warning; ?>
      <button type="button" class="close" data-dismiss="alert">&times;</button>
    </div>
    <?php } ?>
    <?php if ($success) { ?>
    <div class="alert alert-success"><i class="fa fa-check-circle"></i> <?php echo $success; ?>
      <button type="button" class="close" data-dismiss="alert">&times;</button>
    </div>
    <?php } ?>
    
      <!-- RIP modifications: The entries for Freshbooks credentials -->
    <div class="panel panel-default">
      <div class="panel-heading" data-toggle="collapse" data-target="#body-fresh">
        <h3 class="panel-title"><i class="fa fa-keyboard-o"></i> Freshbooks API entry</h3>
      </div>
        
        <div class="panel-body collapse"  id="body-fresh" >
            
            <form action="<?php echo $form_action; ?>" method="post" enctype="multipart/form-data" id="form-fresh" class="form-horizontal">  
             <div class="form-group">
            <label class="col-sm-2 control-label" for="input-freshbooks-url"><?php echo $entry_freshbooks_url; ?></label>
            <div class="col-sm-10">
              <input  type="text" name="freshbooks_url" value="<?php echo $freshbooks_url; ?>" placeholder="<?php echo $entry_freshbooks_url; ?>" id="input-freshbooks-url" class="form-control" />
            </div>
          </div>
            
             <div class="form-group">
            <label class="col-sm-2 control-label" for="input-freshbooks-key"><?php echo $entry_freshbooks_key; ?></label>
            <div class="col-sm-10">
              <input  type="text" name="freshbooks_key" value="<?php echo $freshbooks_key; ?>" placeholder="<?php echo $entry_freshbooks_key; ?>" id="input-freshbooks-key" class="form-control" />
            </div>
          </div>
            
          <div class="form-group">            
                <div class=" pull-right">
                    <button id="btn-fresh"  type="submit" form="form-fresh"class="btn btn-primary"  >Save API <i id="save-api" style="display: none;" class="fa fa-spinner fa fa-pulse"></i></button>
            </div>   
            </div>
            
            
            </form>
         
        </div>
    </div><!-- End of initial entry -->
    

           <!-- RIP modifications: The entries for Freshbooks credentials End.-->
    
    
    
    
    
    
    
    <div class="panel panel-default">
      <div class="panel-heading">
        <h3 class="panel-title"><i class="fa fa-list"></i> <?php echo $text_list; ?></h3>
      </div>
      <div class="panel-body">
        <div class="table-responsive">
          <table class="table table-bordered table-hover">
            <thead>
              <tr>
                <td class="text-left"><?php echo $column_name; ?></td>
                <td></td>
                <td class="text-left"><?php echo $column_status; ?></td>
                <td class="text-right"><?php echo $column_sort_order; ?></td>
                <td class="text-right"><?php echo $column_action; ?></td>
              </tr>
            </thead>
            <tbody>
              <?php if ($extensions) { ?>
              <?php foreach ($extensions as $extension) { ?>
              <tr>
                <td class="text-left"><?php echo $extension['name']; ?></td>
                <td class="text-center"><?php echo $extension['link'] ?></td>
                <td class="text-left"><?php echo $extension['status'] ?></td>
                <td class="text-right"><?php echo $extension['sort_order']; ?></td>
                <td class="text-right"><?php if (!$extension['installed']) { ?>
                  <a href="<?php echo $extension['install']; ?>" data-toggle="tooltip" title="<?php echo $button_install; ?>" class="btn btn-success"><i class="fa fa-plus-circle"></i></a>
                  <?php } else { ?>
                  <a onclick="confirm('<?php echo $text_confirm; ?>') ? location.href='<?php echo $extension['uninstall']; ?>' : false;" data-toggle="tooltip" title="<?php echo $button_uninstall; ?>" class="btn btn-danger"><i class="fa fa-minus-circle"></i></a>
                  <?php } ?>
                  <?php if ($extension['installed']) { ?>
                  <a href="<?php echo $extension['edit']; ?>" data-toggle="tooltip" title="<?php echo $button_edit; ?>" class="btn btn-primary"><i class="fa fa-pencil"></i></a>
                  <?php } else { ?>
                  <button type="button" class="btn btn-primary" disabled="disabled"><i class="fa fa-pencil"></i></button>
                  <?php } ?></td>
              </tr>
              <?php } ?>
              <?php } else { ?>
              <tr>
                <td class="text-center" colspan="6"><?php echo $text_no_results; ?></td>
              </tr>
              <?php } ?>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</div>
<?php echo $footer; ?>

<script type="text/javascript">
    
    $('#btn-fresh').on('click',function(){
        var freshbooksUrl = $('input[name=\'freshbooks_url\']').val();
        var freshbooksKey = $('input[name=\'freshbooks_key\']').val();
  
     $.ajax({
            url: '<?php echo $form_action; ?>',
          type: 'post',
	dataType: 'html',
	data: {
            freshbooks_url : freshbooksUrl,
            freshbooks_key : freshbooksKey
        },
		
            beforeSend: function () {
              $("#save-api").show();
            },
            complete: function () {
                
                $("#save-api").hide();
            },
            success: function () {
             $("#btn-fresh").text("Freshbooks API is saved");
            },
            error: function (xhr, ajaxOptions, thrownError) {
                alert('The API was not recorded into the database');
            }
        });
    
    });
    
    
   
    
</script>