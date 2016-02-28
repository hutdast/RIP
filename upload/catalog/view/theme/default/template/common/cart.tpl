<!-- //RIP modifications -->
<div id="cart" class="btn-group btn-block">

    <button type="button" data-toggle="dropdown" data-loading-text="<?php echo $text_loading; ?>" class="btn btn-inverse btn-block btn-lg dropdown-toggle"><i class="fa fa-shopping-cart"></i> <span id="cart-total"><?php echo $text_items; ?></span></button>
    <ul class="dropdown-menu pull-right">
        <?php if ($products) { ?>
        <li>
            <table class="table table-striped">
                <?php foreach ($products as $product) { ?>
                <tr>
                    <td class="text-center"><?php if (true) { ?>
                        <img src="<?php echo $product['thumb']; ?>"  title="" class="img-thumbnail" />
                        <?php } ?></td>
                    <td class="text-left"><?php echo $product['name']; ?></br>
                        <?php foreach ($product['option'] as $options) { ?>
                        <div class="text-right"> <?php echo $options; ?></div>
                        <?php } ?>
                    </td>
                    <td class="text-right">x <?php echo $product['quantity']; ?></td>
                    <td class="text-right"><?php echo $product['total']; ?></td>
                    <td class="text-center"><button type="button" onclick="cart.remove('<?php echo $product['cart_id']; ?>');" title="<?php echo $button_remove; ?>" 
                                                    class="btn btn-danger btn-xs cart-delete"><i class="fa fa-times"></i></button></td>
                </tr>
                <!-- Another tray for the options that goes with this product -->

                <?php } ?>

            </table>
        </li>
        <li>
            <div>
                <table class="table table-bordered">
                    <?php foreach ($totals as $total) { ?>
                    <tr>
                        <td class="text-right"><strong><?php echo $total['title']; ?></strong></td>
                        <td class="text-right"><?php echo $total['text']; ?></td>
                    </tr>
                    <?php } ?>
                </table>
                <p class="text-right"><a href="<?php echo $cart; ?>"><strong><i class="fa fa-shopping-cart"></i> <?php echo $text_cart; ?></strong></a>&nbsp;&nbsp;&nbsp;<a href="<?php echo $checkout; ?>"><strong><i class="fa fa-share"></i> <?php echo $text_checkout; ?></strong></a></p>
            </div>
        </li>
        <?php } else { ?>
        <li>
            <p class="text-center"><?php echo $text_empty; ?></p>
        </li>
        <?php } ?>
    </ul>
</div>
<!-- //RIP modifications End.-->