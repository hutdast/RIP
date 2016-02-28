<?php
class ControllerProductPicture extends Controller {
	private $error = array();

	public function index() {
		$this->load->language('product/picture');

		$data['breadcrumbs'] = array();

		$data['breadcrumbs'][] = array(
			'text' => $this->language->get('text_home'),
			'href' => $this->url->link('product/picture')
		);

		
			
				        $example = " example";
    }
    
