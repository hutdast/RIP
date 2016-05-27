<?php
class ControllerPaymentCod extends Controller {
	public function index() {
		$data['button_confirm'] = $this->language->get('button_confirm');

		$data['text_loading'] = $this->language->get('text_loading');
		
		
	
		
		$data['continue'] = $this->url->link('checkout/success');

		if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/template/payment/cod.tpl')) {
			return $this->load->view($this->config->get('config_template') . '/template/payment/cod.tpl', $data);
		} else {
			return $this->load->view('default/template/payment/cod.tpl', $data);
		}
	}

	public function confirm() {
		if ($this->session->data['payment_method']['code'] == 'cod') {
			$this->load->model('checkout/order');

			$this->model_checkout_order->addOrderHistory($this->session->data['order_id'], $this->config->get('cod_order_status_id'));
		}
	}
    
   
    /**
     *In the event the customer void a payment, this function will delete the orders that is being set in
     *rustik_order.
     **/
    public function voidPayment(){
        
    $this->load->model('checkout/order');
       
        $api =  $this->model_checkout_order->getFresbooks('square');
    
        $all_ids = $this->model_checkout_order->getInvoice_num($this->customer->getEmail());
        $all_ids = explode("~!", $all_ids);
        
            $transaction_id = $all_ids[0];
            $url = $api['url'].'/'.$transaction_id.'/void';
            
            //Begin the request
            $curl = curl_init();
            curl_setopt($curl, CURLOPT_URL, $$url);
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
            $this->model_checkout_order->deleteRustikOrder($all_ids[1]);
             $json =[];
            if($errmsg){
                $json['errors'] = $errmsg;
            }else{
                
                $json['success'] = 'Your payment has been cancelled';
                
            }
        
        $this->response->addHeader('Content-Type: application/json');
        $this->response->setOutput(json_encode($json));
    
    }
    
    
    
    
    
    
    
    
    
    
    
}
    

