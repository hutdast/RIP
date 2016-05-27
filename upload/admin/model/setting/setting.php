<?php
class ModelSettingSetting extends Model {

 //RIP modifications: Enter Freshbook url and key into the api table
    public function setFresbooks($data) {
        $query = $this->db->query("SELECT * FROM " . DB_PREFIX . "freshbooks_api WHERE api_tag = '" . $this->db->escape($data['api_tag']) . "'");
     
        if(count($query->rows) > 1) {
          $this->db->query("UPDATE " . DB_PREFIX . "freshbooks_api SET api_key = '" . $this->db->escape($data['freshbooks_key']) 
           . "', url = '". $this->db->escape($data['freshbooks_url']) . "', WHERE api_tag = '" . $this->db->escape($data['api_tag']) . "'");  
}  else {
  $this->db->query("INSERT INTO " . DB_PREFIX . "freshbooks_api SET url = '" . $this->db->escape($data['freshbooks_url']) . "', api_key = '" . $this->db->escape($data['freshbooks_key']) 
        . "', api_tag = '".$this->db->escape($data['api_tag'])."', date_modified = '".  date('Y-m-d H:i:s')."'");   
}  
      
  }
    
       public function getFresbooks($data) {

    $query = $this->db->query("SELECT * FROM " . DB_PREFIX . "freshbooks_api WHERE api_tag = '" . $this->db->escape($data)."'");
    
$data = array();
         foreach ($query->rows as $result) {
			
		$data['freshbooks_url'] = $result['url'];
		$data['freshbooks_key'] = $result['api_key'];
                $data['date_modified'] =  $result['date_modified'];
		}

		return $data;
      }
    
      public function getAPIs() {
  $query = $this->db->query("SELECT * FROM " . DB_PREFIX . "freshbooks_api ");
  return $query->rows;
      }
      //RIP modifications: Enter Freshbook url and key into the api table End.

	public function getSetting($code, $store_id = 0) {
		$setting_data = array();

		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "setting WHERE store_id = '" . (int)$store_id . "' AND `code` = '" . $this->db->escape($code) . "'");

		foreach ($query->rows as $result) {
			if (!$result['serialized']) {
				$setting_data[$result['key']] = $result['value'];
			} else {
				$setting_data[$result['key']] = json_decode($result['value'], true);
			}
		}

		return $setting_data;
	}

	public function editSetting($code, $data, $store_id = 0) {
		$this->db->query("DELETE FROM `" . DB_PREFIX . "setting` WHERE store_id = '" . (int)$store_id . "' AND `code` = '" . $this->db->escape($code) . "'");

		foreach ($data as $key => $value) {
			if (substr($key, 0, strlen($code)) == $code) {
				if (!is_array($value)) {
					$this->db->query("INSERT INTO " . DB_PREFIX . "setting SET store_id = '" . (int)$store_id . "', `code` = '" . $this->db->escape($code) . "', `key` = '" . $this->db->escape($key) . "', `value` = '" . $this->db->escape($value) . "'");
				} else {
					$this->db->query("INSERT INTO " . DB_PREFIX . "setting SET store_id = '" . (int)$store_id . "', `code` = '" . $this->db->escape($code) . "', `key` = '" . $this->db->escape($key) . "', `value` = '" . $this->db->escape(json_encode($value)) . "', serialized = '1'");
				}
			}
		}
	}

	public function deleteSetting($code, $store_id = 0) {
		$this->db->query("DELETE FROM " . DB_PREFIX . "setting WHERE store_id = '" . (int)$store_id . "' AND `code` = '" . $this->db->escape($code) . "'");
	}

	public function editSettingValue($code = '', $key = '', $value = '', $store_id = 0) {
		if (!is_array($value)) {
			$this->db->query("UPDATE " . DB_PREFIX . "setting SET `value` = '" . $this->db->escape($value) . "', serialized = '0'  WHERE `code` = '" . $this->db->escape($code) . "' AND `key` = '" . $this->db->escape($key) . "' AND store_id = '" . (int)$store_id . "'");
		} else {
			$this->db->query("UPDATE " . DB_PREFIX . "setting SET `value` = '" . $this->db->escape(json_encode($value)) . "', serialized = '1' WHERE `code` = '" . $this->db->escape($code) . "' AND `key` = '" . $this->db->escape($key) . "' AND store_id = '" . (int)$store_id . "'");
		}
	}
}