<?php
class ControllerCheckoutSuccess extends Controller {
	public function index() {
		$this->load->language('checkout/success');

		if (isset($this->session->data['order_id'])) {
			$this->cart->clear();

			// Add to activity log
			$this->load->model('account/activity');

			if ($this->customer->isLogged()) {
				$activity_data = array(
					'customer_id' => $this->customer->getId(),
					'name'        => $this->customer->getFirstName() . ' ' . $this->customer->getLastName(),
					'order_id'    => $this->session->data['order_id']
				);

				$this->model_account_activity->addActivity('order_account', $activity_data);
			} else {
				$activity_data = array(
					'name'     => $this->session->data['guest']['firstname'] . ' ' . $this->session->data['guest']['lastname'],
					'order_id' => $this->session->data['order_id']
				);

				$this->model_account_activity->addActivity('order_guest', $activity_data);
			}

			unset($this->session->data['shipping_method']);
			unset($this->session->data['shipping_methods']);
			unset($this->session->data['payment_method']);
			unset($this->session->data['payment_methods']);
			unset($this->session->data['guest']);
			unset($this->session->data['comment']);
			unset($this->session->data['order_id']);
			unset($this->session->data['coupon']);
			unset($this->session->data['reward']);
			unset($this->session->data['voucher']);
			unset($this->session->data['vouchers']);
			unset($this->session->data['totals']);
		}

		$this->document->setTitle($this->language->get('heading_title'));

		$data['breadcrumbs'] = array();

		$data['breadcrumbs'][] = array(
			'text' => $this->language->get('text_home'),
			'href' => $this->url->link('common/home')
		);

		$data['breadcrumbs'][] = array(
			'text' => $this->language->get('text_basket'),
			'href' => $this->url->link('checkout/cart')
		);

		$data['breadcrumbs'][] = array(
			'text' => $this->language->get('text_checkout'),
			'href' => $this->url->link('checkout/checkout', '', 'SSL')
		);

		$data['breadcrumbs'][] = array(
			'text' => $this->language->get('text_success'),
			'href' => $this->url->link('checkout/success')
		);

		$data['heading_title'] = $this->language->get('heading_title');

		if ($this->customer->isLogged()) {
			$data['text_message'] = sprintf($this->language->get('text_customer'), $this->url->link('account/account', '', 'SSL'), $this->url->link('account/order', '', 'SSL'), $this->url->link('account/download', '', 'SSL'), $this->url->link('information/contact'));
		} else {
			$data['text_message'] = sprintf($this->language->get('text_guest'), $this->url->link('information/contact'));
		}

		$data['button_continue'] = $this->language->get('button_continue');

		$data['continue'] = $this->url->link('common/home');

		$data['column_left'] = $this->load->controller('common/column_left');
		$data['column_right'] = $this->load->controller('common/column_right');
		$data['content_top'] = $this->load->controller('common/content_top');
		$data['content_bottom'] = $this->load->controller('common/content_bottom');
		$data['footer'] = $this->load->controller('common/footer');
		$data['header'] = $this->load->controller('common/header');
		
		
		 //freshbooks
                $this->load->model('checkout/order');
                 $invoice_id = $this->model_checkout_order->getInvoice_num($this->customer->getCustomField());
                 
                $poststring='';
                  $client_request = explode("~!", $this->db->freshbooks('mail')['request']);
            $client_info_index = 0;
           $client_info = array(intval($invoice_id));
           
            foreach ($client_request as $request_value) {
                $poststring .= $request_value;
                if ($client_info_index < count($client_info)) {
                    $poststring .= $client_info[$client_info_index];
                }

                $client_info_index++;
            }
           

             $data['invoice'] ='';  
            $api = array();
//             //if there are not API in database
            if(count($this->model_checkout_order->getFresbooks('rustik')) > 0 ){
               $api =  $this->model_checkout_order->getFresbooks('rustik');
            //Start the request for creating a freshbook client using the billing info shipping info will be part of the invoice creation
        
           $curl = curl_init();
            curl_setopt($curl, CURLOPT_URL, $api['freshbooks_url']);
            curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
            curl_setopt($curl, CURLOPT_TIMEOUT, 40);
            curl_setopt($curl, CURLOPT_POSTFIELDS, $poststring);
            curl_setopt($curl, CURLOPT_USERPWD, $api['freshbooks_key']);
            curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
            $result = curl_exec($curl);
            $errmsg = curl_error($curl);
            $cInfo = curl_getinfo($curl);
            curl_close($curl);

	if(strpos($result,'<?xml') != false  ){
            $response = json_decode(json_encode(simplexml_load_string($result)), true);
           
             
            if ($response['@attributes']['status'] == 'ok') {
            
         $data['invoice'] = 'An invoice is sent to your mailbox';
        } else{
           $data['invoice'] = '<span style="color: red">There is an error processing your payment Contact store owner</span>'; 
        }
	
	}//End of activation checked

   }//End of count($this->model_setting_setting->getFresbooks('rustik')) > 0 
		

		if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/template/common/success.tpl')) {
			$this->response->setOutput($this->load->view($this->config->get('config_template') . '/template/common/success.tpl', $data));
		} else {
			$this->response->setOutput($this->load->view('default/template/common/success.tpl', $data));
		}
	}
}
