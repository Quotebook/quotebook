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

include_once Config::$base_dir . '/classes/DbConfig.php';

define('COLUMN_NAME', 0);
define('VALUE', 1);

class DbConnection extends DbConfig {
    protected $server_name;
    protected $username;
    protected $password;
    protected $db_name;
    
    private $connection_id;
    
    function DbConnection() {
        $this->connection_id = null;
        
        $db_config = new DbConfig();
        $this->server_name = $db_config->server_name;
        $this->username = $db_config->username;
        $this->password = $db_config->password;
        $this->db_name = $db_config->db_name;
    }
    
    function dbConnect() {
        $this->connection_id = mysql_connect($this->server_name, $this->username, $this->password);
        
        if (!$this->connection_id) {
            die('Could not connect: '.mysql_error());
        }
        mysql_select_db($this->db_name, $this->connection_id);
    }
    
    function dbDisconnect() {
        mysql_close($this->connection_id);
        
        $this->connection_id = null;
    }
    
    function selectAll($table_name) {
        $sql_query = 'SELECT * FROM '.$this->db_name.'.'.$table_name;
        return $this->query($sql_query);
    }
    
    function selectEquals($table_name, $column_name, $value) {
        $sql_query = 'SELECT * FROM '.$this->db_name.'.'.$table_name.' WHERE '.$column_name.'=\''.$value.'\'';
        // TODO: DEBUG($sql_query);
        return $this->query($sql_query);
    }
    
    function selectEqualsMultiple($table_name, $values) {
        $sql_query = 'SELECT * FROM '.$this->db_name.'.'.$table_name.' WHERE ';
        
        // Construct the values in the SQL query
        $i = 0;
        $len = count($values);
        foreach($values as $entry) {
            // Reformat the entry to null otherwise inclue quotemarks
            $sql_entry = $entry[COLUMN_NAME].'=';
            if ($entry[VALUE] == '') {
                $sql_entry .= 'null';
            }
            else {
                $sql_entry .= '\''.$entry[VALUE].'\'';
            }
        
            // Add it to the SQL query
            $sql_query .= $sql_entry;
            if ($i != $len - 1) {
                $sql_query .= 'AND ';
            }
        
            $i++;
        }
        
        //TODO: DEBUG(echo $sql_query);
        return $this->query($sql_query);;
    }
        
    function insertInto($table_name, $values) {
        $sql_query = 'INSERT INTO '.$this->db_name.'.'.$table_name;
    
        // Construct the values in the SQL query
        $i = 0;
        $len = count($values);
        $sql_columns = '';
        $sql_values = '';
        foreach($values as $entry) {
            // Reformat the entry to null otherwise inclue quotemarks
            $sql_columns .= $entry[COLUMN_NAME];
            if ($entry[VALUE] == '') {
                $sql_values .= 'null';
            }
            else {
                $sql_values .= '\''.$entry[VALUE].'\'';
            }
        
            // Add commas to the SQL query
            if ($i != $len - 1) {
                $sql_values .= ', ';
                $sql_columns .= ', ';
            }
        
            $i++;
        }
    
        $sql_query .= ' ('.$sql_columns.') VALUES ('.$sql_values.')';
        $this->query($sql_query);
    
        //TODO: DEBUG(echo $sql_query);
        //TODO: ERROR(echo '<br \>'.mysql_error());
        return $sql_query;
    }
    
    function updateRecord($table_name, $primary_keys, $values) {    
        $sql_query = 'UPDATE '.$this->db_name.'.'.$table_name.' SET ';
        
        // Construct the values in the SQL query
        $i = 0;
        $len = count($values);
        foreach($values as $entry) {
            // Reformat the entry to null otherwise inclue quotemarks
            $sql_entry = $entry[COLUMN_NAME].'=';
            if ($entry[VALUE] == '') {
                $sql_entry .= 'null';
            }
            else {
                $sql_entry .= '\''.$entry[VALUE].'\'';
            }
        
            // Add it to the SQL query
            $sql_query .= $sql_entry;
            if ($i != $len - 1) {
                $sql_query .= ', ';
            }
        
            $i++;
        }
        
        $sql_query .= ' WHERE ';
        
        // Construct the primary keys in the SQL query
        $i = 0;
        $len = count($primary_keys);
        foreach($primary_keys as $primary) {
            // Reformat the entry to null otherwise inclue quotemarks
            $sql_entry = $primary[COLUMN_NAME].'=';
            if ($primary[VALUE] == '') {
                $sql_entry .= 'null';
            }
            else {
                $sql_entry .= '\''.$primary[VALUE].'\'';
            }
        
            // Add it to the SQL query
            $sql_query .= $sql_entry;
            if ($i != $len - 1) {
                $sql_query .= 'AND ';
            }
        
            $i++;
        }
        
        $this->query($sql_query);

        //TODO: DEBUG(echo $sql_query);
        //TODO: ERROR( echo '<br \>'.mysql_error() );
        return $sql_query;
    }
    
    function delete($table_name, $values) {
        $sql_query = 'DELETE FROM '.$this->db_name.'.'.$table_name.' WHERE ';
    
        // Construct the values in the SQL query
        $i = 0;
        $len = count($values);
        foreach($values as $entry) {
            // Reformat the entry to null otherwise inclue quotemarks
            $sql_entry = $entry[COLUMN_NAME].'=';
            if ($entry[VALUE] == '') {
                $sql_entry .= 'null';
            }
            else {
                $sql_entry .= '\''.$entry[VALUE].'\'';
            }
    
            // Add it to the SQL query
            $sql_query .= $sql_entry;
            if ($i != $len - 1) {
                $sql_query .= 'AND ';
            }
    
            $i++;
        }
        
        $this->query($sql_query);

        //TODO: DEBUG(echo $sql_query);
        //TODO: ERROR( echo '<br \>'.mysql_error() );
        return $sql_query;
    }
    
    function query($sql_query) {
        $data = mysql_query($sql_query, $this->connection_id);
        return $data;
    }

    function getInsertId() {
        return mysql_insert_id($this->connection_id);
    }
    
}
?>