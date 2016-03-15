<?php
/*
  osapi.tpl

  OneSaas Connect API 2.0.6.29 for OpenCart v1.5.4.1
  http://www.onesaas.com

  Copyright (c) 2012 oneSaas

  1.0.6.2	- Show version in admin UI
  		  
*/
?>

<?php echo $header; ?><?php echo $column_left; ?>
<div id="content">
  <div class="page-header">
    <div class="container-fluid">
      <div class="pull-right">
        <button type="submit" form="form-osapi" data-toggle="tooltip" class="btn btn-primary"><i class="fa fa-save"></i></button>
       <a href="<?php echo $cancel; ?>" data-toggle="tooltip"  class="btn btn-default"><i class="fa fa-reply"></i></a></div>
      <h1><?php echo $heading_title; ?></h1>
      <ul class="breadcrumb">
        <?php foreach ($breadcrumbs as $breadcrumb) { ?>
        <li><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a></li>
        <?php } ?>
      </ul>
    </div>
  </div>
    <!-- RIP modification: -->
  <div class="container-fluid">
      <div class="panel panel-default">
           <div class="panel-heading">
        <h3 class="panel-title"><i class="fa fa-pencil"></i> header</h3>
      </div>
          
          <div class="panel-body">
              <form action="<?php echo $action; ?>" method="post" enctype="multipart/form-data" id="form-osapi" class="form-horizontal">
              <div class="form-group" id="form-group1">
            <label class="col-sm-2 control-label" for="config_key"> Configuration key:</label>
            <div class="col-sm-10">
                <input readonly="true" type="text" name="name" value="<?php echo $configkey; ?>"  id="config_key" class="form-control" />
             
            </div>
          </div> <!-- form-group1  -->    
          
          
              <div class="form-group" id="form-group2">
            <label class="col-sm-2 control-label" for="os_version"> OneSaas Version:</label>
            <div class="col-sm-10">
                <input readonly="true" type="text" name="name" value="<?php echo $os_version; ?>"  id="os_version" class="form-control" />
             
            </div>
          </div> <!-- form-group2  -->      
              
          
          
              <div class="form-group" id="form-group3">
                  <label class="col-sm-2 control-label" for="onesaas_link" >(don't forget your key!) Proceed to :</label>
            <div class="col-sm-10">
                <a href="<?php echo $os_link; ?>" target="_blank" title="OneSaas Connect" id="onesaas_link"  class="btn btn-primary" >OneSaas Connect</a>
              
             
            </div>
          </div> <!-- form-group3  -->      
              
            </form>  
          </div><!-- panel-body  -->
      </div><!-- panel panel-default  -->
      
      
    </div>
  </div>
  <script type="text/javascript"><!--



//--></script>
<?php echo $footer; ?>