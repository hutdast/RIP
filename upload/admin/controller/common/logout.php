<?php
class ControllerCommonLogout extends Controller {
	public function index() {
		$this->user->logout();

		unset($this->session->data['token']);
               // unset($this->session); 
               //unset($this->cache);
                 //session_destroy();
   header("Expires: Mon, 26 Jul 1997 05:00:00 GMT");
   header("Cache-Control: no-cache");
   header("Pragma: no-cache");
		$this->response->redirect($this->url->link('common/logout', '', 'SSL'));
           
            
	}
}