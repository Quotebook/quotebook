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
require_once Config::$base_dir . '/classes/Book.php';
require_once Config::$base_dir . '/classes/Membership.php';

define('ROLE_SUPERUSER', 1);
define('ROLE_USER', 2);
define('ROLE_NON_USER', 3);
define('ROLE_BANNED', 4);


class User {
    private $user_id;
    private $user_email;
    private $user_password;
    private $user_fname;
    private $user_lname;
    private $user_pic;
    private $user_registration;
    private $role_id;
    
    function User() {
        $this->user_id = null;
        $this->user_email = null;
        $this->user_fname = null;
        $this->user_lname = null;
        $this->user_pic = null;
        $this->user_registration = null;
        $this->role_id = null;
    }

    private function setUserId($user_id) {
        // assigned from database
    }
    
    /**
     * Returns the User's ID
     */
    function getUserId() {
        return $this->user_id;
    }
    
    /**
     * Sets the User's email address
     * 
     * @param $user_email
     */
    function setUserEmail($user_email) {
        $this->user_email = $user_email;
    }
    
    /**
     * Returns the User's email address
     */
    function getUserEmail() {
        return $this->user_email;
    }
    
    /**
     * Sets the User's password
     * 
     * @param $user_password
     */
    function setUserPassword($user_password) {
        // TODO: Must be encrypted
        $this->user_password = $user_password;
    }
    
    /**
     * Returns the User's password
     * 
     */
    function getUserPassword() {
        return $this->user_password;
    }
    
    /**
     * Sets the User's first name
     * 
     * @param $user_fname
     */
    function setUserFirstName($user_fname) {
        $this->user_fname = $user_fname;
    }
    
    /**
     * Returns the User's first name
     */
    function getUserFirstName() {
        return $this->user_fname;
    }
    
    /**
     * Sets the User's last name
     * 
     * @param $user_lname
     */
    function setUserLastName($user_lname) {
        $this->user_lname = $user_lname;
    }
    
    /**
     * Returns the User's last name
     * 
     */
    function getUserLastName() {
        return $this->user_lname;
    }
    
    /**
     * Sets the User's picture
     * 
     * @param $user_pic
     */
    function setUserPic($user_pic) {
        // TODO: Upload
        $this->user_pic = $user_pic;
    }
    
    /**
     * Returns the User's picture
     */
    function getUserPic() {
        return $this->user_pic;
    }
    
    /**
     * Sets the User's role (1=superuser, 2=user, 3=non-user, 4=banned)
     *  
     * @param $role_id
     */
    function setUserRole($role_id) {
        // TODO: 'superuser' or 'banned' requires superuser privileges
        $this->role_id = $role_id;
    }
    
    /**
     * Returns the User's role (1=superuser, 2=user, 3=non-user, 4=banned)
     */
    function getUserRole() {
        return $this->role_id;
    }
    
    private function setUserRegistrationDate()
    {
        date_default_timezone_set('UTC');
        $this->user_registration = date("Y-m-d H:i:s");
    }
    
    /**
     * Returns the User's registration date
     */
    function getUserRegistrationDate() {
        return $this->user_registration;
    }
    
    /**
     * Returns a Membership object for this user and the given book_id.  Returns null if the 
     * user_id or book_id is null.
     *  
     * @param $book_id
     * @return <NULL, Membership>
     */
    function getMembership($book_id)
    {
        $membership = null;
        
        if ($this->user_id && $book_id)
        {
            $membership = new Membership();
            $membership->setUserId($this->user_id);
            $membership->setBookId($book_id);
            $membership->getMembershipType();
        }
        return $membership;
    }

    
    /**
     * Returns an array of Book objects for this user
     *
     * @param $book_id
     * @return NULL|multitype:Book - null if user_id is not set, array of Book objects
     *  
     */
    function getBooks()
    {
        $result = null;
        
        if ($this->user_id)
        {
            $result = array();
        
            $membership = new Membership();
            $book_memberships = $membership->findMembershipBy('user_id', $this->user_id);
            foreach($book_memberships as $membership)
            {
                if ($membership->getMembershipType() == BOOK_ADMIN ||
                        $membership->getMembershipType() == BOOK_MEMBER)
                {
                    $book = new Book();
                    $book->findBookBy('book_id', $membership->getBookId());
                    $result[] = $book;
                }
            }
        }
        return $result;
    }

    /**
     * Find the user using one of the following column fields:
     *     'user_id'
     *     'user_email'
     *     'user_fname'
     *     'user_lname'
     *     'role_id'     
     * 
     * '$this' will be set for the first object
     * 
     * @param $column_name
     * @param $value
     * @return NULL|multitype:User - null on error, array of User objects
     * 
     */
    public function findUserBy($column_name, $value) {
        if ($column_name != 'user_id' && $column_name != 'user_email' && 
            $column_name != 'user_fname' && $column_name != 'user_lname'&& $column_name != 'role_id') {
            // TODO: WARNING('Column name: '.$column_name.' is not supported');
            return null;
        }
        
        $db_connection = new DbConnection();
        $db_connection->dbConnect();
        
        $result = array();
        $data = $db_connection->selectEquals('users', $column_name, $value);
        while ($record = mysql_fetch_assoc($data))
        {
            // Set the object
            $user = new User();
            $user->user_id = $record['user_id'];
            $user->user_email = $record['user_email'];
            $user->user_password = $record['user_password'];
            $user->user_fname = $record['user_fname'];
            $user->user_lname = $record['user_lname'];
            $user->user_pic = $record['user_pic'];
            $user->user_registration = $record['user_registration'];
            $user->role_id = $record['role_id'];
            
            $result[] = $user;
        }
        
        // Set the first result in this
        if ($result[0]) {
            $this->user_id = $result[0]->user_id;
            $this->user_email = $result[0]->user_email;
            $this->user_password = $result[0]->user_password;
            $this->user_fname = $result[0]->user_fname;
            $this->user_lname = $result[0]->user_lname;
            $this->user_pic = $result[0]->user_pic;
            $this->user_registration = $result[0]->user_registration;
            $this->role_id = $result[0]->role_id;
        }
        
        $db_connection->dbDisconnect();
        return $result;
    }
    
    /**
     * Writes the user information to the database. There are 2 usages for this function:
     *     1. Create a new user
     *         In order to create a new user, the user_email must be unique and the 
     *         user_email and user_password must be set.  The user_id and the user_registration
     *         will be automatically generated.
     *     
     *     2. Update an existing user
     *         In order to update an existing user, the user object must have been retrieved from the
     *         database.  This is verfied by ensuring the user_id is set from a previous SELECT.
     *         The user_email and the user_password must also be set for the update to occur.
     *         The user_id and the user_registration cannot be changed.
     *  
     * @throws Exception
     * @return string - Returns the executed SQL statement
     */
    public function writeToDb() {
        $sql_query = null;
        
        // Ensure non-null fields are created
        if ($this->user_email && $this->user_password)
        {
            $db_connection = new DbConnection();
            $db_connection->dbConnect();
            
            if ($this->user_id)
            {
                // Try updating the user    
                $data = $db_connection->selectEquals('users', 'user_id', $this->user_id);
                $record = mysql_fetch_assoc($data);
                if ($record) {
                    // TODO: DEBUG( echo 'USER ALREADY EXISTS!! <br />' );
                    // TODO: DEBUG( echo 'UPDATING USER... ' );
                    $primary_keys = array( array('user_id', $this->user_id) );
                    $values = array(
                            array('user_email', $this->user_email),
                            array('user_password', $this->user_password),
                            array('user_fname', $this->user_fname),
                            array('user_lname', $this->user_lname),
                            array('user_pic', $this->user_pic),
                            array('role_id', $this->role_id)
                    );
                    $sql_query = $db_connection->updateRecord('users', $primary_keys, $values);
                    // TODO: DEBUG( echo 'DONE <br />' );
                }
                else {
                    $db_connection->dbDisconnect();
                    throw new Exception('User ID is invalid');
                }
            }
            else {
                // Create new user only if the email address isn't already registered
                $data = $db_connection->selectEquals('users', 'user_email', $this->user_email);
                $record = mysql_fetch_assoc($data);
                if ($record) {
                    $db_connection->dbDisconnect();
                    throw new Exception('User email already exists');
                }
                else {
                    $this->setUserRegistrationDate();
                    $values = array(
                            array('user_email',$this->user_email),
                            array('user_password',$this->user_password),
                            array('user_fname',$this->user_fname),
                            array('user_lname',$this->user_lname),
                            array('user_pic',$this->user_pic),
                            array('user_registration',$this->user_registration),
                            array('role_id',$this->role_id)
                    );
                    $sql_query = $db_connection->insertInto('users', $values);
                    $this->user_id = $db_connection->getInsertId();
                }
            }
            
            $db_connection->dbDisconnect();
        }
        else {
            throw new Exception('User email or password is null');
        }
        
        return $sql_query;
    }

    public function json() {
        return json_encode(get_object_vars($this));
    }
}

?>