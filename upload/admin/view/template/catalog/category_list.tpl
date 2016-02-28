<?php echo $header; ?><?php echo $column_left; ?>
<div id="content">
    <!-- RIP modification: header modification to embed the editing section.-->
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

    <!-- RIP: header modification ends.-->




    <!-- Body begins here -->

    <div class="panel panel-default">

        <div class="panel-heading">
            <h3 class="panel-title"><i class="fa fa-list"></i> <?php echo $heading_title; ?></h3>
        </div>
        <div class="panel-body">


            <div class="well">
                <div class="row">
                    <!-- Package Name section  -->
                    <div class="col-sm-2">
                        <div class="form-group">
                            <label class="control-label" for="package_id">Package Name</label>
                            <input type="text" name="package_name" value="" placeholder="Package Name" id="package_id" class="form-control" />
                        </div>
                    </div>
                    <!-- Package Name section End. -->

                    <!-- Package Price section  -->
                    <div class="col-sm-2">
                        <div class="form-group">
                            <label class="control-label" for="price_id">Package Price</label>
                            <input type="text" name="price" value="" placeholder="Package Price" id="price_id"
                                   class="form-control" />
                        </div>

                    </div>
                    <!-- Package Price section End. -->



                    <!-- Description textarea section  -->
                    <div class="col-sm-2">
                        <div class="form-group">

                            <label class="control-label" for="description-id">Descriptions</label>
                            <textarea name="descriptions" class="form-control"  id="descriptions-id"></textarea> 
                            <input type="hidden" id="description-id" value=""/>
                        </div>
                    </div>
                    <!-- Description textarea section End. -->

                    <div class="col-sm-2">

                        <button type="button" id="add-package" class="btn btn-primary pull-right">
                            <i class="fa fa-plus"></i> ADD </button>
                    </div>
                </div>

            </div>




            <div class="table-responsive">


                <table title="<?php echo $heading_title; ?>" id="type_table" class="table table-bordered table-hover">
                    <thead>
                    <div class="panel-heading text-center">
                        <h3 class="panel-title"><?php echo $heading_title; ?></h3>
                    </div>
                    </thead>
                    <thead>
                        <tr>

                            <td class="text-left">
                                Package Name
                            </td>
                            <td class="text-left">
                                Package Price
                            </td>
                            <td class="text-left">
                                Descriptions (use comma for new line entries)
                            </td>


                            <td class="text-right"><?php echo "Action"; ?></td>
                        </tr>
                    </thead>

                    <tbody>
                        <?php if (isset($packages)) { ?>
                        <?php foreach ($packages as $package) { ?>
                        <tr>
                            <!-- Dimensions Editing sections -->
                            <td>
                                <?php echo $package['package_name']; ?>

                            </td>
                            <!-- Dimensions Editing sections end -->

                            <!-- Size Editing sections -->
                            <td contenteditable="true" class="edit" id="<?php echo $package['package_name'].'~!'.'price';?>">
                                <i class="fa fa-pencil"></i>
                                <?php echo $package['price']; ?>
                            </td>
                            <!-- Size Editing sections end -->

                            <!-- Luster Editing sections -->
                            <td contenteditable="true" class="edit" id="<?php echo $package['package_name'].'~!'.'descriptions';?>"> 
                                <i class="fa fa-pencil"></i>
                                <?php foreach (explode('~!',$package['descriptions']) as $descrip) { ?>
                                <?php echo $descrip; ?></br>
                                <?php } ?>

                            </td>
                            <!-- Luster Editing sections end -->


                            <td>
                                <button type="button" id="button-delete" onclick="deleteRow('<?php echo $package['package_name']; ?>');"  
                                        class="btn btn-primary pull-right" ><i class="fa fa-trash-o"></i> Delete </button>

                            </td>
                        </tr>
                        <?php } ?>
                        <?php } else { ?>
                        <tr>
                            <td class="text-center" colspan="8"><?php echo "There are no results"; ?></td>
                        </tr>
                        <?php } ?>




                    </tbody>
                </table>
            </div>



        </div>
    </div>
</div>




<script type="text/javascript" ><!--
    $().ready(function () {
        var n = location.href.search('~!');
        if (n >= 0) {
            alert('You entered a duplicate for package name!');
        }

    });

    $('#descriptions-id').on('blur', function () {
        var descrip = $(this).val().split('\n');
        var container = '';
        for (var item in descrip) {
            container += descrip[item] + '~!';
        }

        $('#description-id').val(container);

    });

    $('#add-package').on('click', function () {

        var params = Array();


        params.push($('input[name=\'package_name\']').val());
        params.push(parseFloat($('input[name=\'price\']').val()));
        params.push($('#description-id').val());
        sendEntries(params, 'add');


    });




    function sendEntries(parameters, option) {

        //declare url destination
        var url;
        //Check if it is a new entry or editing
        var package_name = parameters[0];
        var price = parameters[1];
        var descriptions = parameters[2];

        if (option == 'add') {
            url = 'index.php?route=catalog/category/add&token=<?php echo $token; ?>';
            //Check if package_name is set and price are numbers
            if ($.trim(package_name) && !isNaN($.trim(price))) {

                url += '&package_name=' + encodeURIComponent(package_name) + '&price=' + encodeURIComponent(price) +
                        '&descriptions=' + encodeURIComponent(descriptions);
                location = url;

            } else {
                alert("check your inputs for null and price should be a digit");

            }
            //Else it is editing
        } else {
            url = 'index.php?route=catalog/category/edit&token=<?php echo $token; ?>';

            //Check if package_name is set and matte and luster price are numbers
            if ($.trim(package_name) && price) {
//For edit we have to use var price as it represents either price or descriptions
                if (!isNaN($.trim(price)) && descriptions) {
                     
                    //Check description for isPrice
                    url += '&package_name=' + encodeURIComponent(package_name) + '&price=' + encodeURIComponent(price) +
                            '&editing=' + encodeURIComponent('editing');
                   
                } else if (!descriptions && $.trim(price)) {
                    
                    url += '&package_name=' + encodeURIComponent(package_name) + '&descriptions=' + encodeURIComponent(price) +
                            '&editing=' + encodeURIComponent('editing');
                  
                }
                 location = url;

            } else {
                alert("check your inputs for null ");

            }



        }
    }





    $('.edit').on('blur', function () {
        var params = Array();
        var name = $(this).attr('id').split('~!');
        var thevalue = $.trim($(this).text());
        var temp = '';
        var isPrice = true;
        if (name[1] == 'price') {
          
            temp = parseFloat(thevalue);
        } else if (name[1] == 'descriptions') {
            isPrice = false;
           
            var arr = thevalue.split(',');
            for (var item in arr) {
                temp += $.trim(arr[item])+ '~!';
            }

        }
        params.push(name[0]);
        params.push(temp);
        params.push(isPrice);

        sendEntries(params, 'edit');
    });


    function deleteRow(r) {
        var url = 'index.php?route=catalog/category/delete&token=<?php echo $token; ?>&package_name=' + encodeURIComponent(r)+
                '&delete=' + encodeURIComponent('delete');
        location = url;
    }


    //--></script>
<?php echo $footer; ?>