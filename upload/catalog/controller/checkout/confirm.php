<?php

class ControllerCheckoutConfirm extends Controller {
	

    public function index() {
        $redirect = '';
		

	
        if ($this->cart->hasShipping()) {
            // Validate if shipping address has been set.
            if (!isset($this->session->data['shipping_address'])) {
                $redirect = $this->url->link('checkout/checkout', '', 'SSL');
            }
        } else {
            unset($this->session->data['shipping_address']);
            unset($this->session->data['shipping_method']);
            unset($this->session->data['shipping_methods']);
        }

        // Validate if payment address has been set.
        if (!isset($this->session->data['payment_address'])) {
            $redirect = $this->url->link('checkout/checkout', '', 'SSL');
        }

        // Validate if payment method has been set.
        if (!isset($this->session->data['payment_method'])) {
            //$redirect = $this->url->link('checkout/cart', '', 'SSL');
            $redirect = '';
        }

        // Validate cart has products and has stock.
        if ((!$this->cart->hasProducts() && empty($this->session->data['vouchers'])) || (!$this->cart->hasStock() && !$this->config->get('config_stock_checkout'))) {
            $redirect = $this->url->link('checkout/cart');
        }

        // Validate minimum quantity requirements.
        $products = $this->cart->getProducts();

        foreach ($products as $product) {
            $product_total = 0;

            foreach ($products as $product_2) {
                if ($product_2['product_id'] == $product['product_id']) {
                    $product_total += $product_2['quantity'];
                }
            }
        }

        if (!$redirect) {
            $order_data = array();

            $order_data['totals'] = array();
            $total = 0;
            $taxes = $this->cart->getTaxes();

            $this->load->model('extension/extension');

            $sort_order = array();

            $results = $this->model_extension_extension->getExtensions('total');

            foreach ($results as $key => $value) {
                $sort_order[$key] = $this->config->get($value['code'] . '_sort_order');
            }

            array_multisort($sort_order, SORT_ASC, $results);

            foreach ($results as $result) {
                if ($this->config->get($result['code'] . '_status')) {
                    $this->load->model('total/' . $result['code']);

                    $this->{'model_total_' . $result['code']}->getTotal($order_data['totals'], $total, $taxes);
                }
            }

            $sort_order = array();

            foreach ($order_data['totals'] as $key => $value) {
                $sort_order[$key] = $value['sort_order'];
            }

            array_multisort($sort_order, SORT_ASC, $order_data['totals']);

            $this->load->language('checkout/checkout');

            $order_data['invoice_prefix'] = $this->config->get('config_invoice_prefix');
            $order_data['store_id'] = $this->config->get('config_store_id');
            $order_data['store_name'] = $this->config->get('config_name');

            if ($order_data['store_id']) {
                $order_data['store_url'] = $this->config->get('config_url');
            } else {
                $order_data['store_url'] = HTTP_SERVER;
            }

            if ($this->customer->isLogged()) {
                $this->load->model('account/customer');


                $customer_info = $this->model_account_customer->getCustomer($this->customer->getId());

                $order_data['customer_id'] = $this->customer->getId();
                $order_data['customer_group_id'] = $customer_info['customer_group_id'];
                $order_data['firstname'] = $customer_info['firstname'];
                $order_data['lastname'] = $customer_info['lastname'];
                $order_data['email'] = $customer_info['email'];
                $order_data['telephone'] = $customer_info['telephone'];
                $order_data['fax'] = $customer_info['fax'];
                $order_data['custom_field'] = json_decode($customer_info['custom_field'], true);
            } elseif (isset($this->session->data['guest'])) {
                $order_data['customer_id'] = 0;
                $order_data['customer_group_id'] = $this->session->data['guest']['customer_group_id'];
                $order_data['firstname'] = $this->session->data['guest']['firstname'];
                $order_data['lastname'] = $this->session->data['guest']['lastname'];
                $order_data['email'] = $this->session->data['guest']['email'];
                $order_data['telephone'] = $this->session->data['guest']['telephone'];
                $order_data['fax'] = $this->session->data['guest']['fax'];
                $order_data['custom_field'] = $this->session->data['guest']['custom_field'];
            }

            $order_data['payment_firstname'] = $this->session->data['payment_address']['firstname'];
            $order_data['payment_lastname'] = $this->session->data['payment_address']['lastname'];
            $order_data['payment_company'] = $this->session->data['payment_address']['company'];
            $order_data['payment_address_1'] = $this->session->data['payment_address']['address_1'];
            $order_data['payment_address_2'] = $this->session->data['payment_address']['address_2'];
            $order_data['payment_city'] = $this->session->data['payment_address']['city'];
            $order_data['payment_postcode'] = $this->session->data['payment_address']['postcode'];
            $order_data['payment_zone'] = $this->session->data['payment_address']['zone'];
            $order_data['payment_zone_id'] = $this->session->data['payment_address']['zone_id'];
            $order_data['payment_country'] = $this->session->data['payment_address']['country'];
            $order_data['payment_country_id'] = $this->session->data['payment_address']['country_id'];
            $order_data['payment_address_format'] = $this->session->data['payment_address']['address_format'];
            $order_data['payment_custom_field'] = (isset($this->session->data['payment_address']['custom_field']) ? $this->session->data['payment_address']['custom_field'] : array());

            if (isset($this->session->data['payment_method']['title'])) {
                $order_data['payment_method'] = $this->session->data['payment_method']['title'];
            } else {
                $order_data['payment_method'] = '';
            }

            if (isset($this->session->data['payment_method']['code'])) {
                $order_data['payment_code'] = $this->session->data['payment_method']['code'];
            } else {
                $order_data['payment_code'] = '';
            }

            if ($this->cart->hasShipping()) {
                $order_data['shipping_firstname'] = $this->session->data['shipping_address']['firstname'];
                $order_data['shipping_lastname'] = $this->session->data['shipping_address']['lastname'];
                $order_data['shipping_company'] = $this->session->data['shipping_address']['company'];
                $order_data['shipping_address_1'] = $this->session->data['shipping_address']['address_1'];
                $order_data['shipping_address_2'] = $this->session->data['shipping_address']['address_2'];
                $order_data['shipping_city'] = $this->session->data['shipping_address']['city'];
                $order_data['shipping_postcode'] = $this->session->data['shipping_address']['postcode'];
                $order_data['shipping_zone'] = $this->session->data['shipping_address']['zone'];
                $order_data['shipping_zone_id'] = $this->session->data['shipping_address']['zone_id'];
                $order_data['shipping_country'] = $this->session->data['shipping_address']['country'];
                $order_data['shipping_country_id'] = $this->session->data['shipping_address']['country_id'];
                $order_data['shipping_address_format'] = $this->session->data['shipping_address']['address_format'];
                $order_data['shipping_custom_field'] = (isset($this->session->data['shipping_address']['custom_field']) ? $this->session->data['shipping_address']['custom_field'] : array());

                if (isset($this->session->data['shipping_method']['title'])) {
                    $order_data['shipping_method'] = $this->session->data['shipping_method']['title'];
                } else {
                    $order_data['shipping_method'] = '';
                }

                if (isset($this->session->data['shipping_method']['code'])) {
                    $order_data['shipping_code'] = $this->session->data['shipping_method']['code'];
                } else {
                    $order_data['shipping_code'] = '';
                }
            } else {
                $order_data['shipping_firstname'] = '';
                $order_data['shipping_lastname'] = '';
                $order_data['shipping_company'] = '';
                $order_data['shipping_address_1'] = '';
                $order_data['shipping_address_2'] = '';
                $order_data['shipping_city'] = '';
                $order_data['shipping_postcode'] = '';
                $order_data['shipping_zone'] = '';
                $order_data['shipping_zone_id'] = '';
                $order_data['shipping_country'] = '';
                $order_data['shipping_country_id'] = '';
                $order_data['shipping_address_format'] = '';
                $order_data['shipping_custom_field'] = array();
                $order_data['shipping_method'] = '';
                $order_data['shipping_code'] = '';
            }

            $order_data['products'] = array();
            //Declare the string for Freshbooks invoice///////////////////
           

            $freshbooks_total = "";
            $freshbooks_quantity = 0;

            foreach ($this->cart->getProducts() as $product) {
                $option_data = array();

                $first = strripos($product['name'], "/") + 1;
                $end = strripos($product['name'], ".") - $first;
                $productTitle = substr($product['name'], $first, $end);
                $freshbooks_description = "";
               

                $order_data['products'][] = array(
                    'product_id' => $product['product_id'],
                    'name' => $productTitle,
                    'option' => $product['option'],
                    'quantity' => (int) $product['quantity'],
                    'price' => $product['price'],
                    'total' => $product['total'],
                    'tax' => $this->tax->getTax($product['price'], $product['tax_class_id'])
                );
            }





            // Gift Voucher
            $order_data['vouchers'] = array();



            $order_data['comment'] = $this->session->data['comment'];
            $order_data['total'] = $total;

            if (isset($this->request->cookie['tracking'])) {
                $order_data['tracking'] = $this->request->cookie['tracking'];

                $subtotal = $this->cart->getSubTotal();

                // Affiliate
                $this->load->model('affiliate/affiliate');

                $affiliate_info = $this->model_affiliate_affiliate->getAffiliateByCode($this->request->cookie['tracking']);

                if ($affiliate_info) {
                    $order_data['affiliate_id'] = $affiliate_info['affiliate_id'];
                    $order_data['commission'] = ($subtotal / 100) * $affiliate_info['commission'];
                } else {
                    $order_data['affiliate_id'] = 0;
                    $order_data['commission'] = 0;
                }

                // Marketing
                $this->load->model('checkout/marketing');

                $marketing_info = $this->model_checkout_marketing->getMarketingByCode($this->request->cookie['tracking']);

                if ($marketing_info) {
                    $order_data['marketing_id'] = $marketing_info['marketing_id'];
                } else {
                    $order_data['marketing_id'] = 0;
                }
            } else {
                $order_data['affiliate_id'] = 0;
                $order_data['commission'] = 0;
                $order_data['marketing_id'] = 0;
                $order_data['tracking'] = '';
            }

            $order_data['language_id'] = $this->config->get('config_language_id');
            $order_data['currency_id'] = $this->currency->getId();
            $order_data['currency_code'] = $this->currency->getCode();
            $order_data['currency_value'] = $this->currency->getValue($this->currency->getCode());
            $order_data['ip'] = $this->request->server['REMOTE_ADDR'];

            if (!empty($this->request->server['HTTP_X_FORWARDED_FOR'])) {
                $order_data['forwarded_ip'] = $this->request->server['HTTP_X_FORWARDED_FOR'];
            } elseif (!empty($this->request->server['HTTP_CLIENT_IP'])) {
                $order_data['forwarded_ip'] = $this->request->server['HTTP_CLIENT_IP'];
            } else {
                $order_data['forwarded_ip'] = '';
            }

            if (isset($this->request->server['HTTP_USER_AGENT'])) {
                $order_data['user_agent'] = $this->request->server['HTTP_USER_AGENT'];
            } else {
                $order_data['user_agent'] = '';
            }

            if (isset($this->request->server['HTTP_ACCEPT_LANGUAGE'])) {
                $order_data['accept_language'] = $this->request->server['HTTP_ACCEPT_LANGUAGE'];
            } else {
                $order_data['accept_language'] = '';
            }

            $this->load->model('checkout/order');

            $this->session->data['order_id'] = $this->model_checkout_order->addOrder($order_data);

            $data['text_recurring_item'] = $this->language->get('text_recurring_item');
            $data['text_payment_recurring'] = $this->language->get('text_payment_recurring');

            $data['column_name'] = $this->language->get('Product');
            $data['column_model'] = $this->language->get('Options');
            $data['column_quantity'] = $this->language->get('column_quantity');
            $data['column_price'] = $this->language->get('column_price');
            $data['column_total'] = $this->language->get('column_total');

            $this->load->model('tool/upload');

            $data['products'] = array();

            foreach ($this->cart->getProducts() as $product) {

                $recurring = '';


                $data['products'][] = array(
                    'cart_id' => $product['cart_id'],
                    'product_id' => $product['product_id'],
                    'name' => $product['name'],
                    'option' => $product['option'],
                    'recurring' => $recurring,
                    'quantity' => $product['quantity'],
                    'price' => $this->currency->format($this->tax->calculate($product['price'], $product['tax_class_id'], $this->config->get('config_tax'))),
                    'total' => $this->currency->format($this->tax->calculate($product['price'], $product['tax_class_id'], $this->config->get('config_tax')) * $product['quantity']),
                    'href' => $product['product_id']
                );
            }


            $data['totals'] = array();
		
            foreach ($order_data['totals'] as $total) {
		
                $data['totals'][] = array(
                    'title' => $total['title'],
                    'text' => $this->currency->format($total['value'], 'USD'),
                );
            }	


            //Construct invoice and send to Freshbooks//////////////////////
            $this->load->model('checkout/order');
            $poststring = '';
            $invoice_content ='';
	
         
            foreach ($order_data['products'] as $value) {
                $rustik_order['products'][] = array(
                                                    "product_name" => $value['name'],
                                                    "description" => $value['option'],
                                                    "quantity" => $value['quantity']
                                                    );

                $invoice_content .="<line><name>".$value['name']."</name><description>" . $value['option'] . "</description><unit_cost>"
                        . $value['price'] . "</unit_cost><quantity>" . $value['quantity'] . "</quantity><type>Item</type></line>";
            }
            //Create customer for square
            //Check if customer has an id with square
           $square_id = $this->model_checkout_order->getInvoice_num($this->customer->getEmail());
            if(isset($square_id )){
            $rustik_order['customer']  = $this->customer->getFirstname().'   '.$this->customer->getLastname();
            $rustik_order['status'] = "incomplete";
            $rustik_order['customer_id'] = $this->customer->getId();
            $customer_address =["address_line_1" => $order_data['payment_address_1'], "address_line_2" => $order_data['payment_address_2'], "locality" => $order_data['payment_city'],"administrative_district_level_1" => $order_data['payment_zone'],"postal_code" => $order_data['payment_zone'],"country" => "US"];
            $square_customer = ["given_name" => $this->customer->getFirstname(),"family_name" => $this->customer->getLastname(), "email_address" => $this->customer->getEmail(), "phone_number" => $order_data['telephone'],"note" => "Customer about to make a purchase ", "address" => $customer_address];
            
            $post_string = json_encode($square_customer);
            $api =  $this->model_checkout_order->getFresbooks('square');
            //Begin the request
            $curl = curl_init();
            curl_setopt($curl, CURLOPT_URL, 'https://connect.squareup.com/v2/customers');
            curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
            curl_setopt($curl, CURLOPT_TIMEOUT, 40);
            
            curl_setopt($curl, CURLOPT_HTTPHEADER, array(
                                                         'Content-Type: application/json',
                                                         'Content-Length: ' . strlen($post_string),
                                                         'Authorization: Bearer '.$api['key'])
                        );
            
            curl_setopt($curl, CURLOPT_POSTFIELDS, $post_string);
            curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
            $result = curl_exec($curl);
            $errmsg = curl_error($curl);
            $cInfo = curl_getinfo($curl);
            curl_close($curl);
            $response = json_decode($result,true);
            if(isset($response['customer']['id'])){
                $api['email'] = $this->customer->getEmail();
                $api['invoice_id'] = $response['customer']['id'];
                $this->model_checkout_order->saveInvoice_num($api);
                $order_id = $this->model_checkout_order->addRustikOrder($rustik_order);
            }
        }//end of square payment creation

            //Begin Freshbooks payments
           
            $client_info = array((int) $this->customer->getCustomField(),$order_data['payment_firstname'], $order_data['payment_lastname'],
                $order_data['payment_address_1'],$order_data['payment_address_2'], $order_data['payment_city'],$order_data['payment_zone'],
                'USA',$order_data['payment_postcode'],$invoice_content);


            $client_request = explode("~!", $this->db->freshbooks('create')['request']);
            $client_info_index = 0;
            foreach ($client_request as $request_value) {
                $poststring .= $request_value;
                if ($client_info_index < count($client_info)) {
                    $poststring .= $client_info[$client_info_index];
                }

                $client_info_index++;
            }
            

            $api = array();
             //if there are no API in the database
            if(count($this->model_checkout_order->getFresbooks('rustik')) > 0 ){
               $api =  $this->model_checkout_order->getFresbooks('rustik');
            //Start the request for creating a freshbook client using the billing info shipping info will be part of the invoice creation
            $curl = curl_init();
            curl_setopt($curl, CURLOPT_URL, $api['url']);
            curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
            curl_setopt($curl, CURLOPT_TIMEOUT, 40);
            curl_setopt($curl, CURLOPT_POSTFIELDS, $poststring);
            curl_setopt($curl, CURLOPT_USERPWD, $api['key']);
            curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
            $result = curl_exec($curl);
            $errmsg = curl_error($curl);
            $cInfo = curl_getinfo($curl);
            curl_close($curl);
		
	if(strpos($result, '<?xml') != false ){
            $response = json_decode(json_encode(simplexml_load_string($result)), true);


//If response is ok there is a connection else we have to let customer know
           
$this->load->model('checkout/order');
            if ($response['@attributes']['status'] == 'ok') {
                 $api['email'] = $this->customer->getCustomField();
               $api['invoice_id'] = $response['invoice_id'];
                $this->model_checkout_order->saveInvoice_num($api); 
            } else {

               $this->invoice_id = 'Unable to create invoice';
            }
	}//End of service activation checked

   }//End of count($this->model_setting_setting->getFresbooks('rustik')) > 0 






            $data['payment'] = $this->load->controller('payment/' . $this->session->data['payment_method']);
        } else {
            $data['redirect'] = $redirect;
        }

        if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/template/checkout/confirm.tpl')) {
            $this->response->setOutput($this->load->view($this->config->get('config_template') . '/template/checkout/confirm.tpl', $data));
        } else {
            $this->response->setOutput($this->load->view('default/template/checkout/confirm.tpl', $data));
        }
    }

	public function squarePayment(){
        $this->load->model('checkout/order');
	$json =[];
    $api=[];
	 if(isset($this->request->post['nonce'])){
	 $nonce = $this->request->post['nonce'];
	$amount = str_replace("$","",$this->request->post['total']);
	$amount =  bcmul((double)$amount,100);	
	//Formulate the post_string
	$shipping_address = array(
                "address_line_1" => (isset($this->session->data['shipping_address']['address_1']) ? $this->session->data['shipping_address']['address_1'] : ''),
                "address_line_2" => (isset($this->session->data['shipping_address']['address_2']) ? $this->session->data['shipping_address']['address_2'] : ''),
                "locality" => (isset($this->session->data['shipping_address']['city']) ? $this->session->data['shipping_address']['city'] : '') ,
                "administrative_district_level_1" => (isset($this->session->data['shipping_address']['zone']) ? $this->session->data['shipping_address']['zone'] : '') ,
                "postal_code" => (isset($this->session->data['shipping_address']['postcode']) ? $this->session->data['shipping_address']['postcode'] : '') ,
                "country"=> "US"
                
                );
                
        $billing_address = array(
                        "address_line_1" => (isset($this->session->data['payment_address']['address_1']) ? $this->session->data['payment_address']['address_1'] : ''),
                        "address_line_2" => (isset($this->session->data['payment_address']['address_2']) ? $this->session->data['payment_address']['address_2'] : ''),
                        "administrative_district_level_1" =>  (isset($this->session->data['payment_address']['zone']) ? $this->session->data['payment_address']['zone'] : ''),
                    "locality" => (isset($this->session->data['payment_address']['city']) ? $this->session->data['payment_address']['city'] : ''),
                    "postal_code" => (isset($this->session->data['payment_address']['postcode']) ? $this->session->data['payment_address']['postcode'] : ''),
                                 "country"=> "US");
            
                $amount_money = array('amount' => 0 ,'currency' => 'USD');
            //The poststring
                $post_string =array(
                            "idempotency_key" => uniqid(),
                            "customer_id" => $this->model_checkout_order->getInvoice_num($this->customer->getEmail()),
                            "lastname" => (isset($this->session->data['payment_address']['lastname']) ? $this->session->data['payment_address']['lastname'] : $this->customer->getLastname()),
                            "shipping_address" => $shipping_address,
                            "billing_address" => $billing_address,
                            "buyer_email_address" => $this->customer->getEmail(),
                            "amount_money" => $amount_money,
                            "card_nonce" => $nonce,
                            "note" => 'payment received - simple note',
                             "delay_capture" => false
                );
            $post_string = json_encode($post_string);	
	
	$json['post'] = $post_string;
	$json['total'] = $amount;
    
         
    $api['square'] =  $this->model_checkout_order->getFresbooks('square');
	//Begin the request
            $curl = curl_init();
            curl_setopt($curl, CURLOPT_URL, $api['square']['url']);
            curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
            curl_setopt($curl, CURLOPT_TIMEOUT, 40);

               curl_setopt($curl, CURLOPT_HTTPHEADER, array(
                                                         'Content-Type: application/json',
                                                         'Content-Length: ' . strlen($post_string),
                                                         'Authorization: Bearer '.$api['square']['key'])
                        );

            curl_setopt($curl, CURLOPT_POSTFIELDS, $post_string);
            curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
            $result = curl_exec($curl);
            $errmsg = curl_error($curl);
            $cInfo = curl_getinfo($curl);
           curl_close($curl);
	 $response = json_decode($result,true);
	$json['error'] = $errmsg;
	
	
	
	if(isset($response['transaction']['id'])){
	//record payment
	 $rustik_order = array();
            $rustik_order['customer']  = $this->customer->getFirstname().'   '.$this->customer->getLastname();
            $rustik_order['status'] = "Processing";
                $rustik_order['customer_id'] = $this->customer->getId();
        $notification_text =" Customer name: ".$rustik_order['customer']." \r\n Customer folder: ".$this->customer->getFolderName()." \r\n ";
	foreach ($this->cart->getProducts() as $product) {
		$first = strripos($product['name'], "/") + 1;
                $end = strripos($product['name'], ".") - $first;
                $productTitle = substr($product['name'], $first, $end);
        $notification_text .=" Picture tag: ".$productTitle." \r\n  Description: ".$product['option']." \r\n quantity: ".$product['quantity'];
		  $rustik_order['products'][] = array(
                    "product_name" => $productTitle,
                    "description" => $product['option'],
                    "quantity" => $product['quantity']
                );
        
	}
	$order_id = $this->model_checkout_order->addRustikOrder($rustik_order);
	
	$api['email'] = $this->customer->getEmail();
	$api['invoice_id'] = $response['transaction']['id'].'~!'.$order_id;
	$this->model_checkout_order->saveInvoice_num($api);
        $this->sendNotification($notification_text);
	}
	

	}

	   $this->response->addHeader('Content-Type: application/json');
        $this->response->setOutput(json_encode($json));
	}
//Create an email notification
    public function sendNotification($param){
        
            $mail = new Mail();
            $mail->protocol = $this->config->get('config_mail_protocol');
            $mail->parameter = $this->config->get('config_mail_parameter');
            $mail->smtp_hostname = $this->config->get('config_mail_smtp_hostname');
            $mail->smtp_username = $this->config->get('config_mail_smtp_username');
            $mail->smtp_password = html_entity_decode($this->config->get('config_mail_smtp_password'), ENT_QUOTES, 'UTF-8');
            $mail->smtp_port = $this->config->get('config_mail_smtp_port');
            $mail->smtp_timeout = $this->config->get('config_mail_smtp_timeout');
            
            $mail->setTo($this->config->get('config_email'));
        
            $mail->setFrom($this->config->get('config_email'));
        
            $mail->setSender(html_entity_decode($this->config->get('config_email'), ENT_QUOTES, 'UTF-8'));
            $mail->setSubject(html_entity_decode(sprintf('Order recieved',$this->customer->getFirstname()), ENT_QUOTES, 'UTF-8'));
            $mail->setText($param);
            $mail->send();

    }

    
    
    


}
