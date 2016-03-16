<?php

class Cart {

    private $data = array();

    public function __construct($registry) {
        $this->config = $registry->get('config');
        $this->customer = $registry->get('customer');
        $this->session = $registry->get('session');
        $this->db = $registry->get('db');
        $this->tax = $registry->get('tax');
        $this->weight = $registry->get('weight');

        // Remove all the expired carts with no customer ID
        $this->db->query("DELETE FROM " . DB_PREFIX . "cart WHERE customer_id = '0' AND date_added < DATE_SUB(NOW(), INTERVAL 1 HOUR)");

        if ($this->customer->getId()) {
            // We want to change the session ID on all the old items in the customers cart
            $this->db->query("UPDATE " . DB_PREFIX . "cart SET session_id = '" . $this->db->escape($this->session->getId()) . "' WHERE customer_id = '" . (int) $this->customer->getId() . "'");

            // Once the customer is logged in we want to update the customer ID on all items he has
            $cart_query = $this->db->query("SELECT * FROM " . DB_PREFIX . "cart WHERE customer_id = '0' AND session_id = '" . $this->db->escape($this->session->getId()) . "'");

            foreach ($cart_query->rows as $cart) {
                $this->db->query("DELETE FROM " . DB_PREFIX . "cart WHERE cart_id = '" . (int) $cart['cart_id'] . "'");

                // The advantage of using $this->add is that it will check if the products already exist and increaser the quantity if necessary.
                $this->add($cart['product_id'], $cart['quantity'], json_decode($cart['option']), $cart['recurring_id']);
            }
        }
    }

    //RIP modifications:
    //Taxes would have to be clarified is the client taking 100% or share taxes with her customer
    public function getTaxes() {
        $tax_data = array();


        return $tax_data;
    }
    //RIP modification: There are no recurring products therefore whenever this function is called it will return empty array
    public function getRecurringProducts() {
        $product_data = array();
        
        return $product_data;
    }

    public function getProducts() {
        $product_data = array();
        $reward = 0; //to replace when we are doing the packages
        $cart_query = $this->db->query("SELECT * FROM " . DB_PREFIX . "cart WHERE customer_id = '"
                . (int) $this->customer->getId() . "' AND session_id = '" . $this->db->escape($this->session->getId()) . "'");

        foreach ($cart_query->rows as $cart) {
            $recur = '';
            if($cart['recurring_id']){
                $recur = $cart['recurring_id'];
            }
            $product_data[] = array(
                'cart_id' => $cart['cart_id'],
                'product_id' => $cart['product_id'],
                'name' => $cart['product_name'],
                'quantity' => $cart['quantity'],
                'option' => unserialize($cart['option']),
                'reward' => $reward * $cart['quantity'],
                'tax_class_id' => 10,
                'price' => $cart['price'],
                'recurring' => $recur,
                'total' => $cart['price'] * $cart['quantity']
            );


            //$this->remove($cart['cart_id']);
        }

        return $product_data;
    }

    public function add($product_info, $recurring_id = 0) {

        $query = $this->db->query("SELECT COUNT(*) AS total FROM " . DB_PREFIX
                . "cart WHERE customer_id = '" . (int) $this->customer->getId()
                . "' AND session_id = '" . $this->db->escape($this->session->getId())
                . "' AND product_name = '" . $product_info['product_name'] . "' AND recurring_id = '"
                . (int) $recurring_id . "' AND `option` = '" . serialize($product_info['description']) . "'");



        if (!$query->row['total']) {
            $this->db->query("INSERT " . DB_PREFIX . "cart SET customer_id = '" . (int) $this->customer->getId() . "', session_id = '"
                    . $this->db->escape($this->session->getId()) . "', product_name = '" . $product_info['product_name'] . "', recurring_id = '"
                    . (int) $recurring_id . "', `option` = '" . serialize($product_info['description']) . "', quantity = '" . (int) $product_info['quantity'] . "', date_added = NOW(),
                                 price ='" . (double) $product_info['price'] . "', product_id =(SELECT product_id FROM "
                    . DB_PREFIX . "product WHERE product_name = '" . $this->db->escape($product_info['product_name']) . "' AND description ='"
                    . serialize($product_info['description']) . "' LIMIT 1)");
        } else {
            $this->db->query("UPDATE " . DB_PREFIX . "cart SET quantity = (quantity + " . (int) $product_info['quantity'] . ") WHERE customer_id = '"
                    . (int) $this->customer->getId() . "' AND session_id = '" . $this->db->escape($this->session->getId()) . "' AND product_name = '"
                    . (int) $product_info['product_name'] . "' AND recurring_id = '" . (int) $recurring_id . "' AND `option` = '" . serialize($product_info['description']) . "'");
        }
    }

    public function remove($cart_id) {
        $this->db->query("DELETE FROM " . DB_PREFIX . "product WHERE product_id = (SELECT product_id FROM " . DB_PREFIX . "cart WHERE cart_id = '" . (int) $cart_id . "')");
        $this->db->query("DELETE FROM " . DB_PREFIX . "cart WHERE cart_id = '" . (int) $cart_id . "' AND customer_id = '"
                . (int) $this->customer->getId() . "' AND session_id = '" . $this->db->escape($this->session->getId()) . "'");
    }

    //RIP modifications end.

    public function update($cart_id, $quantity) {
        $this->db->query("UPDATE " . DB_PREFIX . "cart SET quantity = '" . (int) $quantity . "' WHERE cart_id = '" . (int) $cart_id . "' AND customer_id = '" . (int) $this->customer->getId() . "' AND session_id = '" . $this->db->escape($this->session->getId()) . "'");
    }

    public function clear() {
        $this->db->query("DELETE FROM " . DB_PREFIX . "cart WHERE customer_id = '" . (int) $this->customer->getId() . "' AND session_id = '" . $this->db->escape($this->session->getId()) . "'");
    }

    
    public function getWeight() {
        $weight = 0;
        /**
          foreach ($this->getProducts() as $product) {
          if ($product['shipping']) {
          $weight += $this->weight->convert($product['weight'], $product['weight_class_id'], $this->config->get('config_weight_class_id'));
          }
          }
         * */
        return $weight;
    }

    public function getSubTotal() {
        $total = 0;

        foreach ($this->getProducts() as $product) {
            $total += $product['total'];
        }

        return $total;
    }

    public function getTotal() {
        $total = 0;

        foreach ($this->getProducts() as $product) {
            $total += $this->tax->calculate($product['price'], $product['tax_class_id'], $this->config->get('config_tax')) * $product['quantity'];
        }

        return $total;
    }

    public function countProducts() {
        $product_total = 0;

        $products = $this->getProducts();

        foreach ($products as $product) {
            $product_total += $product['quantity'];
        }

        return $product_total;
    }

    public function hasProducts() {
        return count($this->getProducts());
    }

    public function hasRecurringProducts() {
        return count($this->getRecurringProducts());
    }

    public function hasStock() {
        $stock = true;
        /**
          foreach ($this->getProducts() as $product) {
          if (!$product['stock']) {
          $stock = false;
          }
          }
         * */
        return $stock;
    }

    //RIP modifications:

    public function hasShipping() {

        $shipping = false;
        /**
          foreach ($this->getProducts() as $product) {
          if ($product['shipping']) {
          $shipping = true;

          break;
          }
          }
         * */
        return $shipping;
    }

    public function hasDownload() {
        $download = false;
        /**
          foreach ($this->getProducts() as $product) {
          if ($product['download']) {
          $download = true;

          break;
          }
          }
         * * */
        return $download;
    }

    //RIP modification ends.
}
