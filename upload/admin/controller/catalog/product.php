<?php

class ControllerCatalogProduct extends Controller {

    private $error = array();

    public function index() {
        $this->language->load('catalog/product');

        $this->document->setTitle($this->language->get('heading_title'));

        $this->load->model('catalog/product');

        $this->getList();
    }

     //RIP modifications:
    public function add() {
        $this->language->load('catalog/product');

        $this->document->setTitle($this->language->get('heading_title'));

        $this->load->model('catalog/product');

            $this->session->data['success'] = $this->language->get('text_success');
            if (isset($this->request->get['dimensions']) && isset($this->request->get['size']) || isset($this->request->get['luster']) || 
                    isset($this->request->get['deep_matte'])) {
                $url = '';
                $dbData['dimensions'] = $this->request->get['dimensions'];
                foreach ($this->model_catalog_product->getCategory() as $category) {
                    if ($category['dimensions'] == $dbData['dimensions']) {
                          $dbData['dimensions'] = null;
                         $url = '&check=~!';
                    break;
                    }
                }
                // If dimensions is not null then we can enter it to db
                if( $dbData['dimensions'] != null){
                    $dbData['size'] = $this->request->get['size'];
                $dbData['luster'] = $this->request->get['luster'];
                $dbData['deep_matte'] = $this->request->get['deep_matte'];
                $this->model_catalog_product->addCategory($dbData);
                } 
                 $this->response->redirect($this->url->link('catalog/product', 'token=' . $this->session->data['token'].$url, 'SSL'));
            }


       
    }
 //RIP modifications:End.
    
    
    public function delete() {
        $this->language->load('catalog/product');

        $this->document->setTitle($this->language->get('heading_title'));

        $this->load->model('catalog/product');

        if (isset($this->request->post['selected']) && $this->validateDelete()) {
            foreach ($this->request->post['selected'] as $product_id) {
                $this->model_catalog_product->deleteProduct($product_id);
            }

            $this->session->data['success'] = $this->language->get('text_success');

            $url = '';

            if (isset($this->request->get['filter_name'])) {
                $url .= '&filter_name=' . urlencode(html_entity_decode($this->request->get['filter_name'], ENT_QUOTES, 'UTF-8'));
            }

            if (isset($this->request->get['filter_model'])) {
                $url .= '&filter_model=' . urlencode(html_entity_decode($this->request->get['filter_model'], ENT_QUOTES, 'UTF-8'));
            }

            if (isset($this->request->get['filter_price'])) {
                $url .= '&filter_price=' . $this->request->get['filter_price'];
            }

            if (isset($this->request->get['filter_quantity'])) {
                $url .= '&filter_quantity=' . $this->request->get['filter_quantity'];
            }

            if (isset($this->request->get['filter_status'])) {
                $url .= '&filter_status=' . $this->request->get['filter_status'];
            }

            if (isset($this->request->get['sort'])) {
                $url .= '&sort=' . $this->request->get['sort'];
            }

            if (isset($this->request->get['order'])) {
                $url .= '&order=' . $this->request->get['order'];
            }

            if (isset($this->request->get['page'])) {
                $url .= '&page=' . $this->request->get['page'];
            }

            $this->response->redirect($this->url->link('catalog/product', 'token=' . $this->session->data['token'] . $url, 'SSL'));
        }

        $this->getList();
    }

    //RIP modifications:

    protected function getList() {
        $dbData = array();
        $data['token'] = $this->session->data['token'];
        if (isset($this->session->data['success'])) {
            $data['success'] = $this->session->data['success'];

            unset($this->session->data['success']);
        } else {
            $data['success'] = '';
        }


        $data['table_title'] = "Categories";

        $data['categories'] = $this->model_catalog_product->getCategory();

        $data['header'] = $this->load->controller('common/header');
        $data['column_left'] = $this->load->controller('common/column_left');
        $data['footer'] = $this->load->controller('common/footer');

        $this->response->setOutput($this->load->view('catalog/product_list.tpl', $data));
    }

    public function deleteCategory() {
        $this->load->model('catalog/product');
        $dbData = array();


        if (isset($this->request->get['dimensions'])) {
            $dbData['dimensions'] = $this->request->get['dimensions'];
            $this->model_catalog_product->updateCategory($dbData);
        }

        $this->response->redirect($this->url->link('catalog/product', 'token=' . $this->session->data['token'], 'SSL'));
    }

    public function updateRecord() {

        $this->load->model('catalog/product');

        $dbData = array();

        if (isset($this->request->get['price_change'])) {
            $dbData['price_change'] = $this->request->get['price_change'];
            $dbData['dimensions'] = $this->request->get['dimensions_edit'];
            if(isset($this->request->get['luster_edit'])){
                $dbData['luster'] = $this->request->get['luster_edit'];
            }else if(isset($this->request->get['deep_matte_edit']) ){
                $dbData['deep_matte'] = $this->request->get['deep_matte_edit'];
               
            }
            
            $this->model_catalog_product->updateCategory($dbData);
            
            $this->session->data['success'] = $this->language->get('text_success');
            
           $this->response->redirect($this->url->link('catalog/product', 'token=' . $this->session->data['token'], 'SSL'));
        }

       
    }

    //RIP modifications: End.
}