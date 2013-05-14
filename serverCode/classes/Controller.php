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

require_once Config::$base_dir . '/classes/User.php';

class Controller
{
    public function handleRequest()
    {
        try {
            switch($_POST['commandName'])
            {
                case 'login':
                    $this->userLogin();
                    break;

                case 'logout':
                    $this->userLogout();
                    break;
                    
                case 'register':
                    $this->userRegister();
                    break;

                case 'createNewUser':
                    $this->createNewUser();
                    break;

                case 'createNewBook':
                    $this->checkUserLoggedIn();
                    $this->createNewBook();
                    break;

                case 'createNewQuote':
                    $this->checkUserLoggedIn();
                    $this->createNewQuote();
                    break;

                case 'editUser':
                    $logged_in_user = $this->checkUserLoggedIn();
                    $this->editUser($logged_in_user);
                    break;

                case 'editBook':
                    $logged_in_user = $this->checkUserLoggedIn();
                    $this->editBook($logged_in_user);
                    break;

                case 'editQuote':
                    $logged_in_user = $this->checkUserLoggedIn();
                    $this->editQuote($logged_in_user);
                    break;

                case 'joinBook':
                    $logged_in_user = $this->checkUserLoggedIn();
                    $this->joinBook($logged_in_user);
                    break;
                    
                case 'leaveBook':
                    $logged_in_user = $this->checkUserLoggedIn();
                    $this->leaveBook($logged_in_user);
                    break;

                case 'inviteToBook':
                    $logged_in_user = $this->checkUserLoggedIn();
                    $this->inviteToBook($logged_in_user);
                    break;

                case 'approveToBook':
                    $logged_in_user = $this->checkUserLoggedIn();
                    $this->approveToBook($logged_in_user);
                    break;
                
                case 'retrieveUser':
                    $logged_in_user = $this->checkUserLoggedIn();
                    $user = $this->retrieveUser($logged_in_user);
                    echo '<p>'.$user->json().'</p>';                    
                    break;
                    
                case 'retrieveBook':
                    $logged_in_user = $this->checkUserLoggedIn();
                    $book = $this->retrieveBook($logged_in_user);
                    echo '<p>'.$book->json().'</p>';
                    break;
                    
                case 'retrieveQuote':
                    $logged_in_user = $this->checkUserLoggedIn();
                    $quote = $this->retrieveQuote($logged_in_user);
                    echo '<p>'.$quote->json().'</p>';
                    break;
            }
        }
        catch (Exception $e) {
            echo '<p>Caught exception: '.$e->getMessage().'</p>';
        }
    }
    
    public function handleJsonRequest()
    {
        if  ( $_POST['json'] ) {
            // TODO: DEBUG('<p>JSON:<br />'.$_POST['json'].'</p>');
            $json_object = json_decode($_POST['json']);
            $json_data = $json_object->data;
            
            switch($json_object->commandName)
            {
                case 'login':
                    $_POST['user_email'] = $json_data->user_email;
                    $_POST['user_password'] = $json_data->user_password;
                    break;
                
                case 'logout':
                    break;
                
                case 'register':
                case "createNewUser":
                case 'editUser':
                    $_POST['user_email'] = $json_data->user_email;
                    $_POST['user_fname'] = $json_data->user_fname;
                    $_POST['user_lname'] = $json_data->user_lname;
                    $_POST['user_role'] = $json_data->user_role;
                    $_POST['user_password'] = $json_data->user_password;
                    break;
                
                case 'createNewBook':
                case 'editBook':
                    $_POST['book_name'] = $json_data->book_name;
                    $_POST['book_description'] = $json_data->book_description;
                    break;
                
                case 'createNewQuote':
                case 'editQuote':
                    $_POST['quote_id'] = $json_data->quote_id;
                    $_POST['book_name'] = $json_data->book_name;
                    $_POST['speaker_email'] = $json_data->speaker_email;
                    $_POST['quote'] = $json_data->quote;
                    $_POST['quote_datetime'] = $json_data->quote_datetime;
                    $_POST['quote_context'] = $json_data->quote_context;
                    $_POST['multi_quote_id'] = $json_data->multi_quote_id;
                    break;
                                                
                case 'joinBook':
                case 'leaveBook':
                case 'retrieveBook':
                    $_POST['book_id'] = $json_data->book_id;
                    break;
                
                case 'inviteToBook':
                case 'approveToBook':
                    $_POST['book_id'] = $json_data->book_id;
                    $_POST['user_email'] = $json_data->user_email;
                    break;
                
                case 'retrieveUser':
                    $_POST['user_id'] = $json_data->user_id;
                    break;
                                        
                case 'retrieveQuote':
                    $_POST['quote_id'] = $json_data->quote_id;
                    break;
            }
            
            $_POST['commandName'] = $json_object->commandName;
            $this->handleRequest();
        }
    }
    
    private function userLogin() {
        $user = new User();
        $user->findUserBy('user_email',$_POST['user_email']);
        
        if ($user->getUserId())
        {
            // Check password
            $password_md5 = md5($_POST['user_password']);
            if ($password_md5 == $user->getUserPassword()) {
                if ($user->getUserRole() == ROLE_NON_USER) {
                    // TODO: Get them to change password, add user info
                }
                elseif ($user->getUserRole() == ROLE_BANNED) {
                    throw new Exception('User account has been locked.  Please contact us at...');
                }
                $_SESSION['user_id'] = $user->getUserId();
                $this->pageRefresh('');
            }
            else {
                throw new Exception('Username or password was incorrect');
            }
        }
        else {
            throw new Exception('Username or password was incorrect');
        }
    }
    
    private function userLogout()
    {
        session_destroy();
        $this->pageRefresh('/');
    }
    
    private function userRegister()
    {
        if ( isset($_SESSION['user_id']) )
        {
            $logged_in_user = new User();
            $logged_in_user->findUserBy('user_id', $_SESSION['user_id']);
            
            $logged_in_user->setUserFirstName($_POST['user_fname']);
            $logged_in_user->setUserLastName($_POST['user_lname']);
            $logged_in_user->setUserPassword( md5($_POST['user_password']) );
            $logged_in_user->setUserRole(ROLE_USER);
            $logged_in_user->writeToDb();
            
            $this->pageRefresh('/');
        }
        else {
            throw new Exception('User is not logged in');
        }
    }
        
    private function createNewUser()
    {
        $user = new User();
        
        if ( isset($_SESSION['user_id']) )
        {
            $logged_in_user = new User();
            $logged_in_user->findUserBy('user_id', $_SESSION['user_id']);
            
            if ($logged_in_user->getUserRole() != ROLE_SUPERUSER) {
                throw new Exception('Cannot create a user when logged in');
            }
            else {
                // Only allow a superuser to create accounts with any role
                $user->setUserRole($_POST['user_role']);
            }
        }
        else
        {
            $user->setUserRole(ROLE_USER);
        }
        
        $user->setUserFirstName($_POST['user_fname']);
        $user->setUserLastName($_POST['user_lname']);
        $user->setUserEmail($_POST['user_email']);
        $user->setUserPassword( md5($_POST['user_password']) );
        $user->writeToDb();
    }
    
    private function createNewBook()
    {
        $book = new Book();
        
        $book->setBookName($_POST['book_name']);
        $book->setBookDescription($_POST['book_description']);
        $book->writeToDb();
        
        // Make the creator the admin
        $membership = new Membership();
        $membership->setUserId($_SESSION['user_id']);
        $membership->setBookId($book->getBookId());
        $membership->setMembershipType(BOOK_ADMIN);
        $membership->writeToDb();
    }
    
    private function createNewQuote()
    {
        $quote = new Quote();
        
        $book = new Book();
        $book->findBookBy('book_name', $_POST['book_name']);
        $quote->setBookId($book->getBookId());
        $quote->setAuthorId($_SESSION['user_id']);
        
        $membership = new Membership();
        $membership->setUserId($quote->getAuthorId());
        $membership->setBookId($quote->getBookId());
        
        // TODO: Superuser's that are not book members should be allowed to create Quotes
        if ($membership->getMembershipType() == BOOK_ADMIN || 
                $membership->getMembershipType() == BOOK_MEMBER)
        {
            $speaker = new User();
            $speaker->findUserBy('user_email', $_POST['speaker_email']);
            if ($speaker->getUserID() == null) {
                $speaker = $this->addNonUser($_POST['speaker_email']);
            }
            $quote->setSpeakerId($speaker->getUserId());
            
            $quote->setQuote($_POST['quote']);
            $quote->setQuoteDateTime($_POST['quote_datetime']);
            $quote->setQuoteContext($_POST['quote_context']);
            $quote->setMultiQuoteId($_POST['multi_quote_id']);
            $quote->writeToDb();
        }
        else {
            throw new Exception('User is not a member of this book');
        }
    }
    
    private function joinBook($logged_in_user)
    {
        $membership = $logged_in_user->getMembership($_POST['book_id']);     
           
        if ($membership->getMembershipType() == null) {
            $membership->setMembershipType(BOOK_REQUESTED);
        }
        elseif ($membership->getMembershipType() == BOOK_INVITED) {
            $membership->setMembershipType(BOOK_MEMBER);
        }
        
        $membership->writeToDb();
    }
    
    private function leaveBook($logged_in_user)
    {
        $membership = $logged_in_user->getMembership($_POST['book_id']);
        
        if ($membership && $membership->getMembershipType())
        {
            $membership->removeFromDb();
        }
        else {
            throw new Exception('User is not a member of this book');
        }
    }
    
    private function inviteToBook($logged_in_user)
    {
        $membership = $logged_in_user->getMembership($_POST['book_id']);
          
        if ($logged_in_user->getUserRole() == ROLE_SUPERUSER || 
                $membership->getMembershipType() == BOOK_ADMIN)
        {
            $invited_user = new User();
            $invited_user->findUserBy('user_email', $_POST['user_email']);
            
            if ($invited_user->getUserId() == null)
            {
                $invited_user = $this->addNonUser($_POST['user_email']);
            }
            $membership_invite = new Membership();
            $membership_invite->setUserId($invited_user->getUserId());
            $membership_invite->setBookId($_POST['book_id']);
            $membership_invite->setMembershipType(BOOK_INVITED);
            
            $membership_invite->writeToDb();
        }
        else {
            throw new Exception('Only book admins can invite new users');
        }
    }
    
    private function approveToBook($logged_in_user)
    {
        $membership = $logged_in_user->getMembership($_POST['book_id']);

        if ($logged_in_user->getUserRole() == ROLE_SUPERUSER || 
                $membership->getMembershipType() == BOOK_ADMIN)
        {
            $requested_user = new User();
            $requested_user->findUserBy('user_email', $_POST['user_email']);

            if ($requested_user->getUserId() != null)
            {
                $membership_request = new Membership();
                $membership_request->setUserId($requested_user->getUserId());
                $membership_request->setBookId($_POST['book_id']);
                
                if ($membership_request->getMembershipType() != BOOK_ADMIN)
                {
                    $membership_request->setMembershipType(BOOK_MEMBER);
                    $membership_request->writeToDb();
                }
            }
            else {
                throw new Exception('Could not find requested user');
            }
        }
        else {
            throw new Exception('Only book admins can approve users');
        }
    }
    
    private function editUser($logged_in_user)
    {
        $user = new User();
        // $user->findUserBy('user_id', $_POST['user_id']);
        $user->findUserBy('user_email', $_POST['user_email']);
        
        if ($user->getUserId())
        {
            if ($logged_in_user->getUserRole() == ROLE_SUPERUSER)
            {
                // Only superuser can change the role
                $user->setUserRole($_POST['user_role']);
            }
            elseif ($logged_in_user->getUserRole() == ROLE_USER &&
                    $logged_in_user->getUserId() == $user->getUserId())
            {
                $user = $logged_in_user;
            }
            else
            {
                throw new Exception('User does not have sufficient privileges to edit user');
            }
            
            $user->setUserFirstName($_POST['user_fname']);
            $user->setUserLastName($_POST['user_lname']);
            $user->setUserEmail($_POST['user_email']);
            $user->setUserPassword( md5($_POST['user_password']) );
            $user->writeToDb();
        }
        else {
            throw new Exception('User not found');
        }
    }
    
    private function editBook($logged_in_user)
    {
        $book = new Book();
        // $book->findBookBy('book_id', $_POST['book_id']);
        $book->findBookBy('book_name', $_POST['book_name']);
        
        $membership = $logged_in_user->getMembership($book->getBookId());
        
        if ($membership)
        {
            if ($logged_in_user->getUserRole() == ROLE_SUPERUSER || 
                    $membership->getMembershipType() == BOOK_ADMIN)
            {
                $book->setBookName($_POST['book_name']);
                $book->setBookDescription($_POST['book_description']);
                $book->writeToDb();
            }
            else {
                throw new Exception('User does not have sufficient privileges to edit book');
            }
        }
        else {
            throw new Exception('Book not found');
        }
    }
    
    private function editQuote($logged_in_user)
    {
        $quote = new Quote();
        $quote->findQuoteBy('quote_id', $_POST['quote_id']);
    
        $membership = $logged_in_user->getMembership($quote->getBookId());
        if ($membership)
        {
            // Make sure the user is authorized to make the change
            if ( $logged_in_user->getUserRole() == ROLE_SUPERUSER ||
                    $membership->getMembershipType() == BOOK_ADMIN ||
                    ($quote->getAuthorId() == $logged_in_user->getUserId() 
                            && $membership->getMembershipType() == BOOK_MEMBER) ||
                    ($quote->getSpeakerId() == $logged_in_user->getUserId() 
                            && $membership->getMembershipType() == BOOK_MEMBER) )
            {
                $quote->setQuote($_POST['quote']);
                $quote->setQuoteContext($_POST['quote_context']);
                $quote->setQuoteDateTime($_POST['quote_datetime']);
                $quote->setMultiQuoteId($_POST['multi_quote_id']);
                $quote->writeToDb();
            }
            else {
                throw new Exception('User does not have sufficient priveleges to edit quote');
            }
        }
        else {
            throw new Exception('Quote not found');
        }
    }
    
    private function retrieveUser($logged_in_user)
    {
        $user = new User();
        if ($logged_in_user->getUserRole() == ROLE_SUPERUSER)
        {
            $user->findUserBy('user_id', $_POST['user_id']);
            if (!$user->getUserId())
            {
                throw new Exception('User not found');
            }
        }
        elseif ($logged_in_user->getUserId() == $_POST['user_id'])
        {
            $user = $logged_in_user;
        }
        else {
            throw new Exception('User does not have sufficient priveleges to retrieve user');
        }
        return $user;
    }
    
    private function retrieveBook($logged_in_user)
    {
        $book = new Book();
        $membership = $logged_in_user->getMembership($_POST['book_id']);
        
        if ($membership)
        {
            if ( $logged_in_user->getUserRole() == ROLE_SUPERUSER ||
                    $membership->getMembershipType() == BOOK_ADMIN || 
                    $membership->getMembershipType() == BOOK_MEMBER )
            {
                $book->findBookBy('book_id', $_POST['book_id']);
            }
            else {
                throw new Exception('User does not have sufficient priveleges to retrieve book');
            }
        }
        else {
            throw new Exception('Book not found');
        }
        
        return $book;
    }
    
    private function retrieveQuote($logged_in_user)
    {
        $quote = new Quote();
        $quote->findQuoteBy('quote_id', $_POST['quote_id']);
        
        $membership = $logged_in_user->getMembership($quote->getBookId());
        if ($membership)
        {
            // Make sure the user is authorized to make the change
            if ( !($logged_in_user->getUserRole() == ROLE_SUPERUSER ||
                    $membership->getMembershipType() == BOOK_ADMIN ||
                    $membership->getMembershipType() == BOOK_MEMBER) )
            {
                throw new Exception('User does not have sufficient priveleges to retrieve quote');
            }
        }
        else {
            throw new Exception('Quote not found');
        }
    
        return $quote;
    }
    
    private function pageRefresh($redirect_url) {
        if ($redirect_url) {
            $redirect_url = ';url='.Config::$base_url.$redirect_url;
        }
        echo '<meta http-equiv="refresh" content="0'.$redirect_url.'">';
    }
    
    private function addNonUser($user_email)
    {
        $user = new User();
        $user->setUserEmail($user_email);
        // TODO: Randomly generate a possword
        $user->setUserPassword( md5("12345") );
        $user->setUserRole(ROLE_NON_USER);
        $user->writeToDb();

        return $user;
    }
    
    private function checkUserLoggedIn()
    {
        $return_user = null;
        $logged_in_user = new User();
    
        if ( isset($_SESSION['user_id']) )
        {
            // Check if the user is superuser or user
            $logged_in_user->findUserBy('user_id', $_SESSION['user_id']);
    
            if ($logged_in_user->getUserRole() == ROLE_SUPERUSER ||
                    $logged_in_user->getUserRole() == ROLE_USER)
            {
                $return_user = $logged_in_user;
            }
            else {
                throw new Exception('User does not have sufficient priveleges');
            }
        }
        else {
            throw new Exception('User is not logged in');
        }
    
        return $return_user;
    }
} 
?>