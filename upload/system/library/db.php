<?php
class DB {
	private $db;

	public function __construct($driver, $hostname, $username, $password, $database, $port = NULL) {
		$class = 'DB\\' . $driver;

		if (class_exists($class)) {
			$this->db = new $class($hostname, $username, $password, $database, $port);
		} else {
			exit('Error: Could not load database driver ' . $driver . '!');
		}
	}
        
        //RIP modifications: making freshbooks available to both admin and catalog section
        public function freshbooks($param) {
               $result = $this->db->query("SELECT * FROM `" . DB_PREFIX . "freshbooks_request` WHERE name = '".$this->db->escape($param)."'"); 
return  $result->row;
    }
        
        
        public function log($param) {
            /////////////////////////////////////////////////////////
                ////////////////////////////////////////////////////////
      
                $string = $param. '\r\n';
          
                if(!is_writable("logger.txt")){
                    die('there is a problem '.$string);
                }else{
                     $handle = fopen("logger.txt", 'a+');
                     fwrite($handle, $string);
                     fclose($handle);
                }
             
                /////////////////////////////////////////////////////////
                ////////////////////////////////////////////////////////
        }
        public function query($sql) {
		return $this->db->query($sql);
	}

	public function escape($value) {
		return $this->db->escape($value);
	}

	public function countAffected() {
		return $this->db->countAffected();
	}

	public function getLastId() {
		return $this->db->getLastId();
	}
}
