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

class Quote {
    private $quote_id;
    private $book_id;
    private $speaker_id;
    private $author_id;
    private $quote;
    private $quote_context;
    private $multi_quote_id;
    private $quote_datetime;
    private $quote_registration;

    function Quote() {
        $this->quote_id = null;
        $this->book_id = null;
        $this->speaker_id = null;
        $this->author_id = null;
        $this->quote = null;
        $this->quote_context = null;
        $this->multi_quote_id = null;
        $this->quote_datetime = null;
        $this->quote_registration = null;        
    }
    
    private function setQuoteId($quote_id) {
        // assigned from database
    }
    
    /**
     * Returns the Quote ID
     */
    function getQuoteId() {
        return $this->quote_id;
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
     * Sets the Speaker ID
     * @param $speaker_id
     */
    function setSpeakerId($speaker_id) {
        $this->speaker_id = $speaker_id;
    }
    
    /**
     * Returns the Speaker ID
     */
    function getSpeakerId() {
        return $this->speaker_id;
    }
    
    /**
     * Sets the Author ID
     * @param $author_id
     */
    function setAuthorId($author_id) {
        $this->author_id = $author_id;
    }
    
    /**
     * Returns the Author ID
     */
    function getAuthorId() {
        return $this->author_id;
    }
    
    /**
     * Sets the Quote
     * @param $quote
     */
    function setQuote($quote) {
        $this->quote = $quote;
    }
    
    /**
     * Returns the Quote
     */
    function getQuote() {
        return $this->quote;
    }
    
    /**
     * Sets the Quote Context
     * @param $quote_context
     */
    function setQuoteContext($quote_context) {
        $this->quote_context = $quote_context;
    }
    
    /**
     * Returns the Quote Context
     */
    function getQuoteContext() {
        return $this->quote_context;
    }
    
    /**
     * Sets the Multi Quote ID for the next quote in the chain
     * 
     * @param $multi_quote_id
     */
    function setMultiQuoteId($multi_quote_id) {
        /* TODO: Will there ever be a reason to delete a quote in the middle and retain the rest of the chain?
         * If so we need the prev quote ID too...
         */
        $this->multi_quote_id = $multi_quote_id;
    }
    
    /**
     * Returns the Multi Quote ID for the next quote in the chain
     */
    function getMultiQuoteId() {
        return $this->multi_quote_id;
    }
    
    /**
     * Sets the date and time of when the Quote occured
     * 
     * @param $quote_datetime
     */
    function setQuoteDateTime($quote_datetime)
    {
        // TODO: need to convert from the user's timezone to UTC
        date_default_timezone_set('UTC');
        $this->quote_datetime = $quote_datetime;
    }
    
    /**
     * Returns the date and time of when the Quote occured
     */
    function getQuoteDateTime() {
        return $this->quote_datetime;
    }
    
    private function setQuoteRegistrationDate()
    {
        date_default_timezone_set('UTC');
        $this->quote_registration = date("Y-m-d H:i:s");
    }
    
    /**
     * Returns the Quote's registration date
     */
    function getQuoteRegistrationDate() {
        return $this->quote_registration;
    }
    
    /**
     * Find the quote using one of the following column fields:
     *     'quote_id'
     *     'book_id'
     *     'speaker_id'
     *     'author_id'
     *
     * '$this' will be set for the first object
     *
     * @param $column_name
     * @param $value
     * @return NULL|multitype:Quote - null on error, array of Quote objects
     *
     */
    public function findQuoteBy($column_name, $value) {
        if ($column_name != 'quote_id' && $column_name != 'book_id' && $column_name != 'speaker_id'
                && $column_name != 'author_id') {
            // TODO: WARNING('Column name: '.$column_name.' is not supported');
            return null;
        }
    
        $db_connection = new DbConnection();
        $db_connection->dbConnect();
    
        $result = array();
        $data = $db_connection->selectEquals('quotes', $column_name, $value);
        while ($record = mysql_fetch_assoc($data))
        {
            // Set the object
            $quote = new Quote();
            $quote->quote_id = $record['quote_id'];
            $quote->book_id = $record['book_id'];
            $quote->speaker_id = $record['speaker_id'];
            $quote->author_id = $record['author_id'];
            $quote->quote = $record['quote'];
            $quote->quote_context = $record['quote_context'];
            $quote->multi_quote_id = $record['multi_quote_id'];
            $quote->quote_datetime = $record['quote_datetime'];
            $quote->quote_registration = $record['quote_registration'];
            
            $result[] = $quote;
        }
        
        // Set the first result in this
        if ($result[0]) {
            $this->quote_id = $result[0]->quote_id;
            $this->book_id = $result[0]->book_id;
            $this->speaker_id = $result[0]->speaker_id;
            $this->author_id = $result[0]->author_id;
            $this->quote = $result[0]->quote;
            $this->quote_context = $result[0]->quote_context;
            $this->multi_quote_id = $result[0]->multi_quote_id;
            $this->quote_datetime = $result[0]->quote_datetime;
            $this->quote_registration = $result[0]->quote_registration;
        }
        
        $db_connection->dbDisconnect();
        return $result;
    }
    
    /**
     * Writes the quote information to the database. There are 2 usages for this function:
     *     1. Create a new quote
     *         In order to create a new quote, the book_id, speaker_id, author_id and the quote must 
     *         be set.  The quote_id and the quote_registration will be automatically generated.
     *
     *     2. Update an existing quote
     *         In order to update an existing quote, the quote object must have been retrieved from the
     *         database.  This is verfied by ensuring the quote_id is set from a previous SELECT.
     *         The book_id, speaker_id, author_id and the quote must also be set for the update to occur.
     *         The quote_id and the quote_registration cannot be changed.
     *
     * @throws Exception
     * @return string - Returns the executed SQL statement
     */
    public function writeToDb() {
        $sql_query = null;
    
        // Ensure non-null fields are created
        if ($this->book_id && $this->speaker_id && $this->author_id && $this->quote)
        {
            // TODO: Check if the book_id, speaker_id and author_id are valid
            // TODO: Should this function be responsible for creating the speaker as a non-user?

            $db_connection = new DbConnection();
            $db_connection->dbConnect();
            
            if ($this->quote_id)
            {
                // Try updating the quote
                $data = $db_connection->selectEquals('quotes', 'quote_id', $this->quote_id);
                $record = mysql_fetch_assoc($data);
                if ($record) {
                    // TODO: DEBUG( echo 'QUOTE ALREADY EXISTS!! <br />' );
                    // TODO: DEBUG( echo 'UPDATING QUOTE... ' );
                    $primary_keys = array( array('quote_id', $this->quote_id) );
                    $values = array(
                            array('book_id', $this->book_id),
                            array('speaker_id', $this->speaker_id),
                            array('author_id', $this->author_id),
                            array('quote', $this->quote),
                            array('quote_context', $this->quote_context),
                            array('multi_quote_id', $this->multi_quote_id),
                            array('quote_datetime', $this->quote_datetime)
                    );
                    $sql_query = $db_connection->updateRecord('quotes', $primary_keys, $values);
                    // TODO: DEBUG( echo 'DONE <br />' );
                }
                else {
                    $db_connection->dbDisconnect();
                    throw new Exception('Quote ID is invalid');
                }
            }
            else {
                // Create new quote if the exact quote doesn't already exist
                $check_values = array(
                        array('book_id', $this->book_id),
                        array('speaker_id', $this->speaker_id),
                        array('author_id', $this->author_id),
                        array('quote', $this->quote)
                );
                // FIXME: Quote's with apostrophe's mess up here
                
                $data = $db_connection->selectEqualsMultiple('quotes', $check_values);
                $record = mysql_fetch_assoc($data);
                if ($record)
                {
                    $db_connection->dbDisconnect();
                    throw new Exception('Quote already exists in this book');
                }
                else {
                    $this->setQuoteRegistrationDate();
                    if ($this->quote_datetime == '' || $this->quote_datetime == null) {
                        $this->quote_datetime = $this->quote_registration;
                    }
                    $values = array(
                            array('book_id', $this->book_id),
                            array('speaker_id', $this->speaker_id),
                            array('author_id', $this->author_id),
                            array('quote', $this->quote),
                            array('quote_context', $this->quote_context),
                            array('multi_quote_id', $this->multi_quote_id),
                            array('quote_datetime', $this->quote_datetime),
                            array('quote_registration', $this->quote_registration) 
                        );
                    $sql_query = $db_connection->insertInto('quotes', $values);
                    $this->quote_id = $db_connection->getInsertId(); 
                }
            }
            
            $db_connection->dbDisconnect();
        }
        else {
            throw new Exception('Book ID, Speaker ID, Author ID or Quote is null');
        }
    
        return $sql_query;
    }
    
    public function json() {
        return json_encode(get_object_vars($this));
    }
}
?>
