<!DOCTYPE html>
<!--[if IE]><![endif]-->
<!--[if IE 8 ]><html dir="<?php echo $direction; ?>" lang="<?php echo $lang; ?>" class="ie8"><![endif]-->
<!--[if IE 9 ]><html dir="<?php echo $direction; ?>" lang="<?php echo $lang; ?>" class="ie9"><![endif]  class="<?php echo $styleClass; ?>"-->
<!--[if (gt IE 9)|!(IE)]><!-->
<html  lang="<?php echo $lang; ?>" class="<?php echo $styleClass; ?>">
<!--<![endif]-->
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title><?php echo $title; ?></title>
<base href="<?php echo $base; ?>" />
<?php if ($description) { ?>
<meta name="description" content="<?php echo $description; ?>" />
<?php } ?>
<?php if ($keywords) { ?>
<meta name="keywords" content= "<?php echo $keywords; ?>" />
<?php } ?>

<!-- when using jquery-ui, jquery core comes first, bootstrap commes second then jquery-ui -->
<script src="catalog/view/javascript/jquery/jquery-2.1.1.min.js" type="text/javascript"></script>
<script src="catalog/view/javascript/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
<script   src="https://code.jquery.com/ui/1.11.4/jquery-ui.min.js"   integrity="sha256-xNjb53/rY+WmG+4L6tTl9m6PpqknWZvRt0rO1SRnJzw="crossorigin="anonymous"></script>   
<script src="catalog/view/javascript/jquery/owl-carousel/owl.carousel.min.js" type="text/javascript"></script>

<link href="catalog/view/javascript/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
<link href="catalog/view/theme/default/stylesheet/stylesheet.css" rel="stylesheet">
<link href="//fonts.googleapis.com/css?family=Open+Sans:400,400i,300,700" rel="stylesheet" type="text/css"/>
<link rel="stylesheet" href="catalog/view/javascript/jquery/owl-carousel/owl.carousel.css">
<link rel="stylesheet" href="catalog/view/javascript/jquery/owl-carousel/owl.theme.css">
<link rel="stylesheet" href="catalog/view/javascript/jquery/owl-carousel/owl.transitions.css">
<link href="catalog/view/javascript/bootstrap/css/bootstrap.min.css" rel="stylesheet" media="screen" />




<!--RIP modification: adding the jquery user interface for dialog-->
  <link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
   
 <!--RIP modification: adding the jquery user interface for dialog Ends.-->

<?php foreach ($styles as $style) { ?>
<link href="<?php echo $style['href']; ?>" type="text/css" rel="<?php echo $style['rel']; ?>" media="<?php echo $style['media']; ?>" />
<?php } ?>
<script src="catalog/view/javascript/common.js" type="text/javascript"></script>
<?php foreach ($links as $link) { ?>
<link href="<?php echo $link['href']; ?>" rel="<?php echo $link['rel']; ?>" />
<?php } ?>
<?php foreach ($scripts as $script) { ?>
<script src="<?php echo $script; ?>" type="text/javascript"></script>
<?php } ?>
<?php foreach ($analytics as $analytic) { ?>
<?php echo $analytic; ?>
<?php } ?>
<!-- Square payment  -->
 <script type="text/javascript" src="https://js.squareup.com/v2/paymentform"></script>

  <style type="text/css">
    .sq-input {
      border: 1px solid rgb(223, 223, 223);
      outline-offset: -2px;
     margin-bottom: 5px;
    }
    .sq-input--focus {
      /* how your inputs should appear when they have focus */
      outline: 5px auto rgb(59, 153, 252);
    }
    .sq-input--error {
      /* how your inputs should appear when invalid */
      outline: 5px auto rgb(255, 97, 97);
    }
  </style>

<!-- square payment end. -->



</head>
    
    <!--  RIP MOFICACTIONS: IF USER IS NOT LOGGED THE CART AND OTHER USER SPECIFIC FUNCTIONS ARE NOT DISPLAYED. IN ADDITION, ALL SUB-FUNCTIONALITIES LAYS OUT TRANSPARENTLY TO THE USER. -->
    
    <body style="background-color:rgba(0, 0, 0, 0.2);">
<nav id="top">
  <div class="container">
   
    <?php echo $language; ?>
    <div id="top-links" class="nav pull-right">
      <ul class="list-inline">
        <li><a href="<?php echo $contact; ?>"><i class="fa fa-envelope-o"></i></a> <span class="hidden-xs hidden-sm hidden-md"><?php echo $telephone; ?></span></li>
          
          
           <?php if ($logged) { ?><!--If customer log in show all below -->
        <li class="dropdown"><a href="<?php echo $account; ?>" title="<?php echo $text_account; ?>" class="dropdown-toggle" data-toggle="dropdown"><i class="fa fa-user"></i> <span class="hidden-xs hidden-sm hidden-md"><?php echo $text_account; ?></span> <span class="caret"></span></a>
          <ul class="dropdown-menu dropdown-menu-right">
           
            <li><a href="<?php echo $account; ?>"><?php echo $text_account; ?></a></li>
            <li><a href="<?php echo $account_edit; ?>">Edit Account</a></li>
            <li><a href="<?php echo $account_pass; ?>">Edit Password</a></li>
            <li><a href="<?php echo $account_add_address; ?>">Edit Address</a></li>
           
            <li><a href="<?php echo $order; ?>"><?php echo $text_order; ?></a></li>
            <li><a href="<?php echo $transaction; ?>"><?php echo $text_transaction; ?></a></li>
            
            <li><a href="<?php echo $logout; ?>"><?php echo $text_logout; ?></a></li>
            
           
           
          </ul>
        </li>
          
        
          
          
        <li><a href="<?php echo $shopping_cart; ?>" title="<?php echo $text_shopping_cart; ?>"><i class="fa fa-shopping-cart"></i> <span class="hidden-xs hidden-sm hidden-md"><?php echo $text_shopping_cart; ?></span></a></li>
          
          
        <li><a href="<?php echo $checkout; ?>" title="<?php echo $text_checkout; ?>"><i class="fa fa-share"></i> <span class="hidden-xs hidden-sm hidden-md"><?php echo $text_checkout; ?></span></a></li>
           <?php } else { ?><!--else If customer is not log in show only the login link-->
            <li><a href="<?php echo $login; ?>"><?php echo $text_login; ?></a></li>
            <li><a  onclick="displayPrices();"> Prices </a></li>
     
  
            <?php } ?>
            <!-- end of the else statement for logged-->
      <li><a href="<?php echo $admin; ?>" target="_blank">Admin</a></li>      
            
      </ul>
    </div>
  </div>
</nav>
    
<header>
  <div class="container">
    <div class="row">
      <div class="col-sm-4">
        <div id="logo">
          <?php if ($logo) { ?>
          
          <a href="<?php echo $home; ?>"><img src="<?php echo $logo; ?>" title="<?php echo $name; ?>" alt="<?php echo $name; ?>" class="img-responsive" /></a>
         
          <?php } else { ?>
          
          <h1><a href="<?php echo $home; ?>"><?php echo $name; ?> </a></h1>
          <?php } ?>
        </div>
        
      </div>
   
          <?php if ($logged) { ?><!--If customer log in show all below -->
          
         <div class="col-sm-3 pull-right"><?php echo $cart; ?></div>
         <?php } ?><!--else If customer is not log in show only the login link-->
    </div>
  </div>
</header>


   <script type="text/javascript">
             function displayPrices(){
                  var data ='<button data-toggle="collapse" data-target="#deep-matte" class="btn-primary">- Deep Matte -</button>';
                      data += '<div id="deep-matte" class="collapse">';          
                      <?php foreach($all_prices as $price){ ?>
                      <?php if($price['deep_matte'] != 0){ ?> 
                      data += "<li><?php echo $price['dimensions']; ?> :<span class=\"pull-right\"style=\"padding-right: 4px;\">";
                      data += "<i class=\"fa fa-usd\"></i> <?php echo doubleval($price['deep_matte']); ?></span></li>";
                      <?php } ?>  <?php } ?>
                      data +=' </div>';
     // End of deep matte section
     data +='<button data-toggle="collapse" data-target="#luster" class="btn-primary" >- Luster -</button>';
                      data += '<div id="luster" class="collapse">';          
                      <?php foreach($all_prices as $price){ ?>
                      <?php if($price['luster'] != 0){ ?> 
                      data += "<li><?php echo $price['dimensions']; ?> :<span class=\"pull-right\"style=\"padding-right: 4px;\">";
                      data += "<i class=\"fa fa-usd\"></i> <?php echo doubleval($price['luster']); ?></span></li>";
                      <?php } ?>  <?php } ?>
                      data +=' </div>';
     // End of luster section
     data +='<button data-toggle="collapse" data-target="#package" class="btn-primary" >- Package Deals -</button>';
                      data += '<div id="package" class="collapse">';          
                      <?php foreach($packages as $package){ ?>
                     
                      data += "<li><?php echo $package['package_name']; ?> :<span class=\"pull-right\"style=\"padding-right: 4px;\">";
                      data += "<i class=\"fa fa-usd\"></i> <?php echo $package['price']; ?></span><ul>";
                   
                     <?php foreach(explode('~!',$package['descriptions']) as $description) { ?>
                      <?php if($description) { ?>
        	  data += "<li> <?php echo trim($description); ?> </li>";
                       <?php } ?>
                         <?php } ?>
                      data +=' </ul></li>';
                <?php } ?>
                data += '</div>';
     // End of package deals section
         var html = '<div id="modal-price" class="modal">';
    html += '  <div class="modal-dialog">';
    html += '    <div class="modal-content">';
    html += '      <div class="modal-header">';
    html += '        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>';
    html += '        <h4 class="modal-title"> Prices </h4>';
    html += '      </div>';
    html += '      <div class="modal-body">' + data + '</div>';
    html += '    </div';
    html += '  </div>';
    html += '</div>';
             $('body').append(html);
        $('#modal-price').modal('show');
                
           
             }
        </script>




    
