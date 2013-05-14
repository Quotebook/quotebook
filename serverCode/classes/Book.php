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

class Book {
    private $book_id;
    private $book_name;
    private $book_description;
    private $book_registration;

    function Book() {
        $this->book_id = null;
        $this->book_name = null;
        $this->book_description = null;
        $this->book_registration = null;
    }

    private function setBookId($book_id) {
        // assigned from database
    }

    /**
     * Returns the Book ID
     */
    function getBookId() {
        return $this->book_id;
    }

    /**
     * Sets the Book name
     * 
     * @param $book_name
     */
    function setBookName($book_name) {
        $this->book_name = $book_name;
    }
    
    /**
     * Returns the Book name
     */
    function getBookName() {
        return $this->book_name;
    }
    
    /**
     * Sets the Book description
     *
     * @param $book_name
     */
    function setBookDescription($book_description) {
        $this->book_description = $book_description;
    }
    
    /**
     * Returns the Book description
     */
    function getBookDescription() {
        return $this->book_description;
    }
    
    private function setBookRegistrationDate()
    {
        date_default_timezone_set('UTC');
        $this->book_registration = date("Y-m-d H:i:s");
    }
    
    /**
     * Returns the Book's registration date
     */
    function getBookRegistrationDate() {
        return $this->book_registration;
    }
    
    /**
     * Find the book using one of the following column fields:
     *     'book_id'
     *     'book_name'
     *
     * The object fields will be set.  Only the first match will be retrieved.
     *
     * @param $column_name
     * @param $value
     * @return NULL|multitype:Book - null on error, array of Book objects
     *
     */
    public function findBookBy($column_name, $value) {
        if ($column_name != 'book_id' && $column_name != 'book_name') {
            // TODO: WARNING('Column name: '.$column_name.' is not supported');
            return null;
        }
    
        $db_connection = new DbConnection();
        $db_connection->dbConnect();
    
        $result = array();
        $data = $db_connection->selectEquals('books', $column_name, $value);
        while ($record = mysql_fetch_assoc($data))
        {
            // Set the object
            $book = new Book();
            $book->book_id = $record['book_id'];
            $book->book_name = $record['book_name'];
            $book->book_description = $record['book_description'];
            $book->book_registration = $record['book_registration'];
            
            $result[] = $book;
        }
        
        if ($result[0]) {
            $this->book_id = $result[0]->book_id;
            $this->book_name = $result[0]->book_name;
            $this->book_description = $result[0]->book_description;
            $this->book_registration = $result[0]->book_registration;
        }
    
        $db_connection->dbDisconnect();
        return $result;
    }
    
    
    /**
     * Writes the book information to the database. There are 2 usages for this function:
     *     1. Create a new book
     *         In order to create a new book, the book_name must be unique.  
     *         The book_id and the book_registration will be automatically generated.
     *
     *     2. Update an existing book
     *         In order to update an existing book, the book object must have been retrieved from the
     *         database.  This is verfied by ensuring the book_id is set from a previous SELECT.
     *         The book_name must also be set for the update to occur.
     *         The book_id and the book_registration cannot be changed.
     *
     * @throws Exception
     * @return string - Returns the executed SQL statement
     */
    public function writeToDb() {
        $sql_query = null;
    
        // Ensure non-null fields are created
        if ($this->book_name)
        {
            $db_connection = new DbConnection();
            $db_connection->dbConnect();
            
            if ($this->book_id)
            {
                // Try updating the book
                $data = $db_connection->selectEquals('books', 'book_id', $this->book_id);
                $record = mysql_fetch_assoc($data);
                if ($record) {
                    // TODO: DEBUG( echo 'BOOK ALREADY EXISTS!! <br />' );
                    // TODO: DEBUG( echo 'UPDATING BOOK... ' );
                    $primary_keys = array( array('book_id', $this->book_id) );
                    $values = array(
                            array('book_name', $this->book_name),
                            array('book_description', $this->book_description)
                    );
                    $sql_query = $db_connection->updateRecord('books', $primary_keys, $values);
                    // TODO: DEBUG( echo 'DONE <br />' );
                }
                else {
                    $db_connection->dbDisconnect();
                    throw new Exception('Book ID is invalid');
                }
            }
            else
            {
                // Create new book if a book with the same name doesn't already exist
                $data = $db_connection->selectEquals('books', 'book_name', $this->book_name);
                $record = mysql_fetch_assoc($data);
                if ($record)
                {
                    $db_connection->dbDisconnect();
                    throw new Exception('Book already exists');
                }
                else {
                    $this->setBookRegistrationDate();
                    $values = array(
                            array('book_name', $this->book_name),
                            array('book_description', $this->book_description),
                            array('book_registration', $this->book_registration)
                    );
                    $sql_query = $db_connection->insertInto('books', $values);
                    $this->book_id = $db_connection->getInsertId();
                }
            }
            
            $db_connection->dbDisconnect();
        }
        else {
            throw new Exception('Book name is null');
        }
        
        return $sql_query;
    }
    
    public function json() {
        return json_encode(get_object_vars($this));
    }
}
?>