<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Api_Model extends CI_Model{

	public function __construct(){
		parent::__construct();
	}
	
   
    public function login($_apikey, $_apisecret, $_username="", $_password=""){
        $this->db->where('api_key',$_apikey);
        $this->db->where('api_secret',$_apisecret);
        $query = $this->db->get('api');
        
        if($query->num_rows()>0){
            //Username
            if($_username == "" || $_password == ""){
                    $data["status"] = "error";
                    $data["error_message"] = "Please fill all the fields";
                    $data["code"] = 400;
            }else{
                $this->db->select('user_id,user_name,user_email,user_created');
                $this->db->where('user_name',$_username);
                $this->db->where('user_password',md5($_password));

                $query = $this->db->get('users');

                if($query->num_rows()>0){
                    $data["status"] = "success";
                    $data["code"] = 200;
                    $data["result"] = $query->result();
                }else{
                    $data["status"] = "error";
                    $data["error_message"] = "Please check your credentials.";
                    $data["code"] = 400;
                }
            }
        }else{
            $data["status"] = "error";
            $data["error_message"] = "You don't have any authorization to see.";
            $data["code"] = 400;
        }
        return $data;
    }
    
    public function register($_apikey, $_apisecret, $_username, $_password, $_email){
        $this->db->where('api_key',$_apikey);
        $this->db->where('api_secret',$_apisecret);
        $query = $this->db->get('api');
        
        if($query->num_rows()>0){
            //Username
            if($_username == "" || $_password == "" || $_email == ""){
                    $data["status"] = "error";
                    $data["error_message"] = "Please fill all the fields";
                    $data["code"] = 400;
            }else{
                
                
                $this->db->where('user_name',$_username);
                $query = $this->db->get('users');
                
                if($query->num_rows()>0){
                    $data["status"] = "error";
                    $data["error_message"] = "Username is already exist. Please pick a different username.";
                    $data["code"] = 400;
                }else{
                    
                    $datainsert = array(
                        "user_name" => $_username,
                        "user_password" => md5($_password),
                        "user_email" => $_email,
                        "user_created" => date("Y-m-d H:i:s")
                    );
                    $this->db->insert('users', $datainsert); 
                    
                    
                    $this->db->select('user_id,user_name,user_email,user_created');
                    $this->db->where('user_name',$_username);
                    $this->db->where('user_password',md5($_password));

                    $query = $this->db->get('users');

                        $data["status"] = "success";
                        $data["code"] = 200;
                        $data["result"] = $query->result();
                   
                }
               
            }
        }else{
            $data["status"] = "error";
            $data["error_message"] = "You don't have any authorization to see.";
            $data["code"] = 400;
        }
        return $data;
    }
}



