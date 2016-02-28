<?php

class ControllerCommonCart extends Controller {

//RIP modifications
    public function index() {
        $this->load->language('common/cart');

        // Totals
        $this->load->model('extension/extension');

        $total_data = array();
        $total = 0;
        $taxes = $this->cart->getTaxes();

        // Display prices
        if ($this->customer->isLogged() || !$this->config->get('config_customer_price')) {

            $results = $this->model_extension_extension->getExtensions('total');

            foreach ($results as $result) {
                if ($this->config->get($result['code'] . '_status')) {
                    $this->load->model('total/' . $result['code']);

                    $this->{'model_total_' . $result['code']}->getTotal($total_data, $total, $taxes);
                }
            }

            $data['text_empty'] = $this->language->get('text_empty');
            $data['text_cart'] = $this->language->get('text_cart');
            $data['text_checkout'] = $this->language->get('text_checkout');
            $data['text_recurring'] = $this->language->get('text_recurring');
            $data['text_items'] = sprintf($this->language->get('text_items'), $this->cart->countProducts(), $this->currency->format($total));
            $data['text_loading'] = $this->language->get('text_loading');

            $data['button_remove'] = $this->language->get('button_remove');

            $this->load->model('tool/image');
            $this->load->model('tool/upload');

            $data['products'] = array();
            $option_data = array();

            foreach ($this->cart->getProducts() as $product) {
                $image = $product['name'];
                $option_data = $product['option'];


                // Display prices
                if (($this->config->get('config_customer_price') && $this->customer->isLogged()) || !$this->config->get('config_customer_price')) {
                    $price = $this->currency->format($this->tax->calculate($product['price'], $product['tax_class_id'], $this->config->get('config_tax')));
                } else {
                    $price = false;
                }

                // Display prices
                if (($this->config->get('config_customer_price') && $this->customer->isLogged()) || !$this->config->get('config_customer_price')) {
                    $total = $this->currency->format($this->tax->calculate($product['price'], $product['tax_class_id'], $this->config->get('config_tax')) * $product['quantity']);
                } else {
                    $total = false;
                }
                $first = strripos($image, "/") + 1;
                $end = strripos($image, ".") - $first;
                $productTitle = substr($image, $first, $end);

                $data['products'][] = array(
                    'cart_id' => $product['cart_id'],
                    'thumb' => $product['name'],
                    'name' => $productTitle,
                    'option' => $option_data,
                    'quantity' => $product['quantity'],
                    'price' => $this->currency->format($product['price']),
                    'total' => $product['total'],
                    'href' => $this->url->link('product/product', 'product_id=' . $product['product_id'])
                );
            }
        }//End of for each of $this->cart->getProducts() as product


        $data['totals'] = array();

        foreach ($total_data as $result) {
            $data['totals'][] = array(
                'title' => $result['title'],
                'text' => $this->currency->format($result['value']),
            );
        }

        $data['cart'] = $this->url->link('checkout/cart');
        $data['checkout'] = $this->url->link('checkout/checkout', '', 'SSL');

        if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/template/common/cart.tpl')) {
            return $this->load->view($this->config->get('config_template') . '/template/common/cart.tpl', $data);
        } else {
            return $this->load->view('default/template/common/cart.tpl', $data);
        }
    }

//RIP modifications End.
    public function info() {
        $this->response->setOutput($this->index());
    }

}
