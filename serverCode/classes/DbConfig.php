<?php
/**
 * @package kickir.com
 * @subpackage database
 * 
 *
 * NOTICE:  Written by Kickir, LLC
 *  
 *  
 * Copyright 2013 Kickir LLC
 * 
 *  Licensed as per Kickir LLC Services Agreement;
 *  you may not use this file except in compliance with the Kickir Services Agreement.
 *  You may obtain a copy of the Services Agreement from Kickir LLC upon request.
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the Services Agreement for the specific language governing permissions and
 *  limitations under the Services Agreement.
 *
 */

class DbConfig {
    protected $server_name;
    protected $username;
    protected $password;
    protected $db_name;
    
    function DbConfig() {
        $this->server_name = 'localhost';
        $this->username = 'quotebook';
        $this->password = 'BhWVJvhNLqcZa2yp';
        $this->db_name = 'quotebook';
    }
}

?>