<?php
/**
 * @package kickir.com
 * @subpackage quotebook
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
require_once Config::$base_dir . '/classes/DbConnection.php';

define('BOOK_ADMIN', 1);
define('BOOK_MEMBER', 2);
define('BOOK_INVITED', 3);
define('BOOK_REQUESTED', 4);
define('BOOK_BANNED', 5);

class Membership {
    private $user_id;
    private $book_id;
    private $member_id;

    function Membership() {
        $this->user_id = null;
        $this->book_id = null;
        $this->member_id = null;
    }

    /**
     * Sets the User ID
     * 
     * @param $user_id
     */
    function setUserId($user_id) {
        $this->user_id = $user_id;
    }

    /**
     * Returns the User's ID
     */
    function getUserId() {
        return $this->user_id;
    }
    
    /**
     * Sets the Book ID
     * @param $book_id
     */
    function setBookId($book_id) {
        $this->book_id = $book_id;
    }
    
    /**
     * Returns the Book ID
     */
    function getBookId() {
        return $this->book_id;
    }
    
    /**
     * Sets the Membership Type (1=admin, 2=member, 3=invited, 4=banned)
     * 
     * @param $member_type
     */
    function setMembershipType($member_type) {
        $this->member_id = $member_type;
    }
    
    /**
     * Returns the Membership Type
     */
    function getMembershipType() {
        if ($this->member_id == null)
        {
            $this->findMembership();
        }
        return $this->member_id;
    }
    
    /**
     * Find the membership using one of the following column fields:
     *     'user_id'
     *     'book_id'
     *
     * The object fields will be set.
     *
     * @param $column_name
     * @param $value
     * @return NULL|multitype:Membership -  - null on error, array of Membership objects
     *
     */
    function findMembershipBy($column_name, $value)
    {
        if ($column_name != 'user_id' && $column_name != 'book_id')
        {
            // TODO: WARNING('Column name: '.$column_name.' is not supported');
            return null;
        }
    
        $db_connection = new DbConnection();
        $db_connection->dbConnect();

        $result = array();
        $data = $db_connection->selectEquals('memberships', $column_name, $value);
        while ($record = mysql_fetch_assoc($data))
        {
            // Set the object
            $membership = new Membership();
            $membership->user_id = $record['user_id'];
            $membership->book_id = $record['book_id'];
            $membership->member_id = $record['member_id'];
        
            $result[] = $membership;
        }
        
        if ($result[0]) {
            $this->user_id = $result[0]->user_id;
            $this->book_id = $result[0]->book_id;
            $this->member_id = $result[0]->member_id;
        }
        
        $db_connection->dbDisconnect();
        return $result;
    }
    
    /**
     * Find the membership using one of the following column fields:
     *     'user_id' AND 'book_id'
     *
     * The object fields will be set.
     *
     * @return bool
     *
     */
    private function findMembership() {
        if ($this->user_id == null || $this->book_id == null)
        {
            // TODO: WARNING( 'User ID: '.$this->user_id.' or Book ID: '.$this->book_id.' is null' );
            return FALSE;
        }
        
        $db_connection = new DbConnection();
        $db_connection->dbConnect();
    
        $values = array(
                array('user_id', $this->user_id),
                array('book_id', $this->book_id)
        );

        $data = $db_connection->selectEqualsMultiple('memberships', $values);
        $record = mysql_fetch_assoc($data);
        if ($record)
        {
            // Set the object
            $this->member_id = $record['member_id'];
        }

        $db_connection->dbDisconnect();
        return TRUE;
    }
    
    /**
     * Writes the membership information to the database. There are 2 usages for this function:
     *     1. Create a new membership
     *         In order to create a new membership, the user_id, book_id and member_type must
     *         be set.
     *
     *     2. Update an existing membership
     *         In order to update an existing membership, the user_id and book_id combination must  
     *         already exist in the database.
     *
     * @throws Exception
     * @return string - Returns the executed SQL statement
     */
    public function writeToDb() {
        $sql_query = null;
       
        // Ensure non-null fields are created
        if ($this->user_id && $this->book_id && $this->member_id)
        {
            // TODO: Check if the user_id, book_id and member_id are valid
            
            $db_connection = new DbConnection();
            $db_connection->dbConnect();
            
            $primary_keys = array(
                    array('user_id', $this->user_id),
                    array('book_id', $this->book_id)
            );
    
            $data = $db_connection->selectEqualsMultiple('memberships', $primary_keys);
            $record = mysql_fetch_assoc($data);
            if ($record)
            {
                // TODO: DEBUG( echo 'MEMBERSHIP ALREADY EXISTS!! <br />' );
                if ($this->member_id != $record['member_id'])
                {
                    // TODO: DEBUG( echo 'UPDATING MEMBERSHIP... ' );
                    $values = array( array('member_id', $this->member_id) );
                    $sql_query = $db_connection->updateRecord('memberships', $primary_keys, $values);
                    // TODO: DEBUG( echo 'DONE <br />' );
                }
            }
            else {
                $values = array(
                        array('user_id', $this->user_id),
                        array('book_id', $this->book_id),
                        array('member_id', $this->member_id)
                    );
                $sql_query = $db_connection->insertInto('memberships', $values);
            }
            
            $db_connection->dbDisconnect();
        }
        else {
            throw new Exception('User ID, Book ID or Member ID is null');
        }
    
        return $sql_query;
    }
    
    public function removeFromDb()
    {
        if ($this->user_id && $this->book_id)
        {
            $db_connection = new DbConnection();
            $db_connection->dbConnect();
            
            $values = array(
                    array('user_id', $this->user_id),
                    array('book_id', $this->book_id)
            );
            $db_connection->delete('memberships', $values);
            $db_connection->dbDisconnect();
        }
    }
    
    public function json() {
        return json_encode(get_object_vars($this));
    }
}
?>