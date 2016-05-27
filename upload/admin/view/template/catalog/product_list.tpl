<?php echo $header; ?><?php echo $column_left; ?>


<!-- All RIP modifications -->


<div id="content">


    <!-- erro purposes -->
    <div class="container-fluid">



        <!-- Body begins here -->
        <div class="panel panel-default">

            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-list"></i> <?php echo "Product type and price"; ?></h3>
            </div>
            <div class="panel-body">

                <!-- filtering begins --> 
                <div class="well">
                    <div class="row">

                        <div class="col-sm-2">
                            <div class="form-group">
                                <label class="control-label" for="dim_id">Description</label>
                                <input type="text" name="dimensions" value="" placeholder="Description" id="dim_id" class="form-control" />
                            </div>
                        </div>

                        <div class="col-sm-2">
                            <div class="form-group">
                                <label class="control-label" for="size_id">Size</label>
                                <input type="text" name="size" value="" placeholder="Size" id="size_id" class="form-control" />
                            </div>
                        </div>

                        <div class="col-sm-2">
                            <div class="form-group">
                                <label class="control-label" for="lus_id">Luster</label>
                                <input type="text" name="luster" value="" placeholder="price" id="lus_id" class="form-control" />
                            </div>
                        </div>

                        <div class="col-sm-2">
                            <div class="form-group">
                                <label class="control-label" for="deep_id">Deep Matte</label>
                                <input type="text" name="deep_matte" value="" placeholder="price" id="deep_id" class="form-control" />
                            </div>

                        </div>

                        <div class="col-sm-2">
<?php if(isset($duplicate)){ ?>
<?php echo $duplicate;} ?>
                            <button type="button" id="button-category" class="btn btn-primary pull-right"><i class="fa fa-plus"></i> ADD </button>
                        </div>
                        
                    </div>

                </div>



                <div class="table-responsive">
                    
                    <table title="Categories" id="type_table" class="table table-bordered table-hover">
                        <thead>
                        <div class="panel-heading text-center">
                            <h3 class="panel-title"><?php echo $table_title; ?></h3>
                        </div>
                        </thead>
                        <thead>
                            <tr>

                                <td class="text-left">
                                    Description
                                </td>
                                <td class="text-left">
                                    Size
                                </td>
                                <td class="text-left">
                                    Luster
                                </td>
                                <td class="text-left">
                                    Deep Matte
                                </td>

                                <td class="text-right"><?php echo "Action"; ?></td>
                            </tr>
                        </thead>

                        <tbody >

                            <?php if (isset($categories)) { ?>
                            <?php foreach ($categories as $category) { ?>

                            <tr>
                                <!-- Dimensions Editing sections -->
                                <td>
                                    <?php echo $category['dimensions']; ?>

                                </td >
                                <!-- Dimensions Editing sections end -->

                                <!-- Size Editing sections -->
                                <td >       
                                   <?php echo $category['size']; ?>
                                </td>
                                <!-- Size Editing sections end -->

                                <!-- Luster Editing sections -->
                                <td contenteditable="true" class="edit" id="<?php echo $category['dimensions'].'~!'.'luster';?>">  
                                   
                                    <i class="fa fa-pencil"></i>  <?php echo $category['luster']; ?>
                                </td>
                                <!-- Luster Editing sections end -->

                                <!-- Deep Matte Editing sections -->
                                <td contenteditable="true" class="edit result" id="<?php echo $category['dimensions'].'~!'.'matte';?>">       
                                   <i class="fa fa-pencil"></i>  <?php echo $category['deep_matte']; ?>

                                </td>
                                <!-- Deep Matte Editing sections end -->

                                <td>

                                    <button type="button" id="button-delete" onclick="deleteRow('<?php echo $category['dimensions']; ?>');"   class="btn btn-primary pull-right" ><i class="fa fa-trash-o"></i> Delete </button>
                                  
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
       $().ready(function(){
           var n = location.href.search('~!'); 
           if(n >= 0){
               alert('You entered a duplicate for dimensions!');
           }
           
       }); 
        
$('#button-category').on('click', function () {
            var params = Array();
            //params.push($('input[name=\'dimensions\']').val());
            params.push($('#dim_id').val());

            params.push($('#size_id').val());
            params.push(parseFloat($('#lus_id').val()));
            params.push(parseFloat($('#deep_id').val()));
            sendEntries(params, 'add');


        });



        function sendEntries(parameters, option) {

            //declare url destination
            var url;
            //Check if it is a new entry or editing
            var dimensions = parameters[0];
            var size = parameters[1];
            var luster = parameters[2];
            var deep_matte = parameters[3];
            if (option == 'add') {
                url = 'index.php?route=catalog/product/add&token=<?php echo $token; ?>';
                //Check if dimensions is set and matte and luster price are numbers
                if ($.trim(dimensions) || !isNaN($.trim(deep_matte))|| !isNaN($.trim(luster))) {
                    url += '&dimensions=' + encodeURIComponent(dimensions) + '&size=' + encodeURIComponent(size) + '&luster=' + encodeURIComponent(luster) + '&deep_matte=' + encodeURIComponent(deep_matte);
                    location = url;
                  
                } else {
                    alert("check your input for null and price should be a digit");

                }
                //Else it is editing
            } else {
                url = 'index.php?route=catalog/product/updateRecord&token=<?php echo $token; ?>';
                var dimensions = parameters[0].split('~!');
                var thevalue =parseFloat($.trim(parameters[1]));
                  //check for input errors
                    if ($.trim(dimensions[0]) && !isNaN(thevalue) ) {
 if(dimensions[1] == 'luster'){
                  
                    url += '&dimensions_edit='+ encodeURIComponent(dimensions[0]) + '&luster_edit=' + encodeURIComponent(thevalue);
                    //else it is matte
                }else{
                     url += '&dimensions_edit='+ encodeURIComponent(dimensions[0])+ '&deep_matte_edit=' + encodeURIComponent(thevalue);
                }
                  url += '&price_change=' + encodeURIComponent('price_change');
                 location = url;
                   
              

                } else {
                    alert("check your input for null and price should be a digit");

                }
      
             

            }
        }





        $('.edit').on('blur', function () {
            var params = Array();
          
            params.push($(this).attr('id'));
            params.push($(this).text());
            
            sendEntries(params, 'edit');

        });


        function deleteRow(r) {
            var url = 'index.php?route=catalog/product/deleteCategory&token=<?php echo $token; ?>&dimensions=' + encodeURIComponent(r);
            location = url;
        }


        //--></script>



    <?php echo $footer; ?>