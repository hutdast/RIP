<?php
class ControllerCommonDashboard extends Controller {
	public function index() {
		$this->load->language('common/dashboard');

		$this->document->setTitle($this->language->get('heading_title'));
		
		 //RIP modification:Check if the folder is 30 days older
                $date = time();//Today's date equivalent to NOW() sql
                $this->load->model('customer/customer');
                $customers = $this->model_customer_customer->getCustomers();
                foreach ($customers as $customer){
                  $dateAdded = strtotime($customer['date_added']);
                  $directory = DIR_IMAGE.'catalog/'.$customer['folder_name'];
                  if(file_exists($directory)){
                     $filenames = scandir($directory); 
                       //Delete after 31 days as soon the admin logs in, this function is triggered
                    if(($date - $dateAdded) > 2741509 ){
                    $customerID = $customer['customer_id'];
                        //Disable customer so he/she wont be able to log in
                        $tempdb['status'] = 0;
                        $this->model_customer_customer->editCustomer($customerID, $tempdb);
                         foreach ($filenames as $file){
                      if(is_file($directory.'/'.$file)){
                          unlink($directory.'/'.$file);
                      }
                  }//foreach files end
                  //Then we remove the directory
                 rmdir(DIR_IMAGE.'catalog/'.$customer['folder_name']);
                }//Check in date ends
           }//Check for directory exist end.
       
      }//foreach customers  end.
                
                //RIP modification:End.

		$data['heading_title'] = $this->language->get('heading_title');

		$data['text_sale'] = $this->language->get('text_sale');
		$data['text_map'] = $this->language->get('text_map');
		$data['text_activity'] = $this->language->get('text_activity');
		$data['text_recent'] = $this->language->get('text_recent');

		$data['breadcrumbs'] = array();

		$data['breadcrumbs'][] = array(
			'text' => $this->language->get('text_home'),
			'href' => $this->url->link('common/dashboard', 'token=' . $this->session->data['token'], 'SSL')
		);

		$data['breadcrumbs'][] = array(
			'text' => $this->language->get('heading_title'),
			'href' => $this->url->link('common/dashboard', 'token=' . $this->session->data['token'], 'SSL')
		);

		// Check install directory exists
		if (is_dir(dirname(DIR_APPLICATION) . '/install')) {
			$data['error_install'] = $this->language->get('error_install');
		} else {
			$data['error_install'] = '';
		}

		$data['token'] = $this->session->data['token'];

		$data['header'] = $this->load->controller('common/header');
		$data['column_left'] = $this->load->controller('common/column_left');
		$data['order'] = $this->load->controller('dashboard/order');
		$data['sale'] = $this->load->controller('dashboard/sale');
		$data['customer'] = $this->load->controller('dashboard/customer');
		$data['online'] = $this->load->controller('dashboard/online');
		$data['map'] = $this->load->controller('dashboard/map');
		$data['chart'] = $this->load->controller('dashboard/chart');
		$data['activity'] = $this->load->controller('dashboard/activity');
		$data['recent'] = $this->load->controller('dashboard/recent');
		$data['footer'] = $this->load->controller('common/footer');

		// Run currency update
		if ($this->config->get('config_currency_auto')) {
			$this->load->model('localisation/currency');

			$this->model_localisation_currency->refresh();
		}

		$this->response->setOutput($this->load->view('common/dashboard.tpl', $data));
	}
}