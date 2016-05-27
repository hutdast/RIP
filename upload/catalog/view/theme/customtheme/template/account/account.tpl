<?php echo $header; ?>

<div class="container">
    <ul class="breadcrumb">
        <?php foreach ($breadcrumbs as $breadcrumb) { ?>

        <li><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a></li>
        <?php } ?>
    </ul>
    <?php if ($success) { ?>
    <div class="alert alert-success"><i class="fa fa-check-circle"></i> <?php echo  $success; ?> </div>
    <?php } ?>

    
     <div  class="row"  ><!-- Row displays begins -->
        <!-- RIP modifications: -->
        <?php foreach($pictures as $pic){ ?> 
        <div class="product-layout col-lg-3 col-md-3 col-sm-6 col-xs-12 " >
            <div class="product-thumb transition ">
                
                <div class="image"  ><img src="<?php echo $pic['source']; ?>"  class=" photo-size"  
                                           
                                               data-toggle="tooltip" data-title="Click image to enlarge" ></div>

                <div > 

                     <button id="<?php echo $pic['source'].'wishbtn'; ?>"  type="button" class="btn-primary wishlistbtn" data-toggle="tooltip" onclick="wishlist.add('<?php echo $pic['source']; ?>');" data-title="Add to Wish List">WishList</button>
                    <button type="button" id="<?php echo $pic['source']; ?>" class="createProduct btn-primary" data-toggle="tooltip" data-title="Select Options"><i class="fa fa-shopping-cart"></i></button>

                     
                    
                    <i id="<?php echo $pic['source'].'cart'; ?>"  class="fa fa-check-circle cart"  style="color: blue;display:none">Cart</i> 

                 
                    <i id="<?php echo $pic['source'].'wish'; ?>"  class="fa fa-heart wishlist" style="color: red;display:none;"></i>
                    

                    <!-- Wish List  ENd.-->
                </div>

            </div>

        </div>
        <?php } ?>
       
    </div><!-- Row displays ends. -->

 


    
    
</div>


<div class="well create-product" style="display:none;" data-toggle="tooltip" data-title="Select your preferences - scroll down for more options">
    <div class="row"><!--Row header Begins -->
        <div class="col-sm-3">
            <label class="control-label" >Dimensions</label>
        </div> 
        <div class="col-sm-3">
            <label class="control-label" >Deep Matte</label>
        </div> 
        <div class="col-sm-3">
            <label class="control-label">Luster</label>
        </div> 



    </div><!--Row header Ends. -->

    <?php foreach($categories as $category){ ?>      
    <div class="row"><!--Row Begins -->

        <div class="col-sm-3">

            <label class="control-label"> <?php echo $category['dimensions']; ?>: </label>
        </div>

<!-- Opt out the values that for deep matte are zero -->
<?php if($category['deep_matte'] != 0){ ?> 
        <div class="col-sm-3">
            <input type="checkbox"  name="value-pair"
                   value="<?php echo $category['dimensions']; ?>~!<?php echo $category['deep_matte']; ?>~!matte" 
                   class="select-Matte"/> &#36;<?php echo $category['deep_matte']; ?>
        </div>
<?php }else { ?> 
<div class="col-sm-3"></div>
<?php } ?> 
<!-- Opt out the values that for luster are zero -->
<?php if($category['luster'] != 0){ ?> 
       <div class="col-sm-3">
            <input type="checkbox"  name="value-pair" value="<?php echo $category['dimensions']; ?>~!<?php echo $category['luster']; ?>~!luster" 
                   class="select-luster"/> &#36;<?php echo $category['luster']; ?>
        </div>
<?php }else { ?> 
<div class="col-sm-3"></div>
<?php } ?> 



    </div><!--Row Ends.-->
    <?php } ?> 

</div>

<div id="photo-display" style="display: none;" >
 
</div>
<!-- //RIP modifications End.  -->
<?php echo $footer; ?>

<script type="text/javascript">
    //RIP Modifications:
$(function(){
     markWish();
    markCart('initial');
    $('.owl-carousel').hide();
});

//Wishlist function for icon
    function markWish(){
        <?php foreach($wishlist as $wish){ ?>
                $('.wishlist').each(function(){
                    if( $(this).attr('id') == "<?php echo $wish['product_name'].'wish'; ?>" )
                    {
                       $(this).show();
                    }
        });
      <?php }?>  
    }
      
      //Cart function for icon
      function markCart(param){
         if(param == 'initial'){
         <?php foreach($cart_products as $productName){ ?>
           $('.cart').each(function(){
                    if( $(this).attr('id') == "<?php echo $productName['name'].'cart'; ?>" )
                    {
                       $(this).show();
                    }
        });
          <?php }?> 
             
             }else{
                 $('.cart').each(function(){
                    if( $(this).attr('id') == param+'cart')
                    {
                       $(this).show();
                    }
        });
                 
             }
      
      }
        
       //Wish onclick to activate wish icon                               
   $('.wishlistbtn').on('click',function(){
        var nameParts =  $(this).attr('id').split('wishbtn');
       var id = nameParts[0]+'wish';
       $('.wishlist').each(function(){
                    if( $(this).attr('id') == id )
                    {
                       $(this).show();
                    }
        });
      });                                




    $('.createProduct').on('click', function(){
 
   
    //Initialize the array that would send eveything to the back end
    var params = Array();
    //get the product name or product location 
    params.push($(this).attr('id'));
    
    //Create array that capture the options for the product
    var options = Array();
        //Set all checkboxes from the dialog to false initially
         $("input[type='checkbox'][name='value-pair']").each(function(){
         $(this).prop('checked', false);
         });
        
    //Set the options and the checkboxes with initial values if the user has products in the cart
    <?php foreach($cart_products as $cart){ ?>
        //Since we can't have two identical ids the carousel view needs a button with a different is

            if (params[0] == '<?php echo $cart['name']; ?>'){

    $("input[type='checkbox'][name='value-pair']").each(function(){
         
    var checkboxValue = $(this).val();
    //Loop thru all the options
   
            var option = '<?php echo $cart['option']; ?>'.split(': ');
    if (checkboxValue.indexOf(option[0]) >= 0 && checkboxValue.indexOf(option[1]) >= 0 ){
    $(this).prop('checked', true);
    options.push(checkboxValue);
    }
   
    });
    }//End of if statement
    <?php } ?>
            //Create the product as the user makes the selection
            //Deep matte
            $('.select-Matte').change(function(){

    //if it is checked then we capture 
    if ($(this).is(':checked')){
    options.push(this.value);
    } else if (!$(this).is(':checked')){

    var temp1 = options.indexOf(this.value);
    options.splice(temp1, 1);
    }
    });
    //Luster
    $('.select-luster').change(function(){

    //if it is checked then we capture 
    if ($(this).is(':checked')) {
    options.push(this.value);
    } else if (!$(this).is(':checked')){
    var temp2 = options.indexOf(this.value);
    options.splice(temp2, 1);
    }
    });
    params.push(options);
    params.push('<?php echo $customer_id; ?> ');
   
    $(".create-product").dialog({
            

    title: "Cart",
            width: 500,
            height: 240,
            buttons: {
            Cancel:
                    function() {
                    $(this).dialog("close");
                    },
                    AddToCart: function() {

                    if (options.length != 0) {
                    cart.add(params);
                    } else {
                    alert('You did not make any choices!');
                    }
                    markCart(params[0]);
                    $(this).dialog("close");
                    }

            }
    }); //end of the dialog

    }); //end of the createProduct


    $('.cart-delete').on('click', function(){
    location = 'index.php?route=account/account';
    });
                                           
    $('.photo-size').on('click', function(){
       
    var src = $(this).attr('src');

            $("#photo-display").dialog({
    open: function () {
      $("#photo-display").css({"background-image":"url("+src+")","background-repeat":"no-repeat","background-size":"90%"});
     
   
    },
    	 title: "Resize window by pulling bottom corners",
            dialogClass: "dialog-style",
            width: $( window ).width() * 0.5,
            height: $( window ).height() * 0.55,
           
          // position: { my: "center top", at: ("center top+"+(window.innerHeight*.1)) },
             
    }).prev(".ui-dialog-titlebar").css("background","rgba(0, 0, 0, 0.5)");//end of dialog
    
    
    });
    
    





//In order to keep tooltip from showing after the buttin is clicked
$('[data-toggle="tooltip"]').tooltip({
    trigger : 'hover'
});


   



</script>
