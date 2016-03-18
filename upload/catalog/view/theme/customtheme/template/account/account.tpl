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
   <div class="row">

        <!-- RIP modifications: -->
        <?php foreach($pictures as $pic){ ?> 
        <div class="product-layout col-lg-3 col-md-3 col-sm-6 col-xs-12" >
            <div class="product-thumb transition">
                <div class="thumbnails"  ><img src="<?php echo $pic; ?>"  class="img-responsive photo-size"  style="width: 300px;height:115px;" 
                                               data-toggle="tooltip" data-title="Click image to enlarge" ></div>
                <div class="button-group" > 
                     <button  type="button" data-toggle="tooltip" onclick="wishlist.add('<?php echo $pic; ?>');" data-title="Add to Wish List">WishList</button>

                    <button type="button"  id="<?php echo $pic; ?>" class="createProduct" data-toggle="tooltip" data-title="Select Options"><i class="fa fa-shopping-cart"></i></button>
           
                      <!-- Check which one of those pics are already in the cart therefore viewed -->
                    <?php foreach($cart_products as $productName){ ?>
                    <?php if($pic == $productName['name']){ ?> 
                    <i class="fa fa-check-circle "  style="color: blue;">Cart</i> 

                    <?php break; } ?>
                    <?php }?>
                    <!-- Check which one of those pics are already in the cart therefore viewed  ENd.-->
                      <!-- Check which one of those pics are already in the wishlist  -->
                    <?php foreach($wishlist as $wish){ ?>
                    <?php if($pic == $wish['product_name']){ ?> 
                    
                    <i class="fa fa-heart" style="color: red;"></i>

                    <?php break; } ?>
                    <?php }?>
                    <!-- Wish List  ENd.-->
                    
                </div>
 
                    
            </div>
        </div>
        
        <?php } ?>
    </div>
</div>


<div class="well create-product" style="display:none;"  data-toggle="tooltip" data-title="Select your preferences - scroll down for more options">
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

<div id="photo-display" style="display:none;"><img src="" id="full-figure" style="width: 500px; height: 450px;" /> </div>
<!-- //RIP modifications End.-->
<?php echo $footer; ?>

<script type="text/javascript">
    //RIP Modifications:


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
            if (params[0] == '<?php echo $cart['name']; ?>'){

    $("input[type='checkbox'][name='value-pair']").each(function(){
         
    var checkboxValue = $(this).val();
    //Loop thru all the options
    <?php foreach($cart['option'] as $option){ ?>
            var option = '<?php echo $option; ?>'.split(': ');
    if (checkboxValue.indexOf(option[0]) >= 0 && checkboxValue.indexOf(option[1]) >= 0 ){
    $(this).prop('checked', true);
    options.push(checkboxValue);
    }
    <?php } ?>
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
                    //url = 'index.php?route=catalog/product/add&token=<?php echo $token; ?>';

                    location = 'index.php?route=account/account';
                    $(this).dialog("close");
                    }

            }
    }); //end of the dialog

    }); //end of the createProduct


    $('.cart-delete').on('click', function(){
    location = 'index.php?route=account/account';
    });
                                           
    $('.photo-size').on('mouseenter', function(){

    var src = $(this).attr('src')
            $("#photo-display").dialog({
    open: function () {
    $("#full-figure").attr('src', src);
    },
            width: $( window ).width() * 0.5,
            height:$( window ).height()* 0.7,
            position: { my: "left top", at: "left top", of: window }
    });
    });
    $(".photo-size").on('mouseout', function(){
    $("#photo-display").dialog('close');
    });




</script>
