<?php session_start(); ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Quotebook</title>

    <style type="text/css">
        label { display:block; }
    </style>
</head>

<body>
<?php
    include ('header.php');
?>
    <div style="width:60%;float:left">
        <!---------------------- ADD USER SECTION -------------------------->
        <div style="width:50%;height:350px;float:left;">
            <h2>Add / Edit / Find Users</h2>
            <form id='form_user' action='' method='post' accept-charset='UTF-8'>
                <input type='checkbox' name='commandName' id='createNewUser' value='createNewUser'/>Add User<br />
                <input type='checkbox' name='commandName' id='editUser' value='editUser'/>Edit User<br />
            
                <label for='name' >First Name: </label>
                <input type='text' name='user_fname' id='user_fname' maxlength="100" /><br />
        
                <label for='name' >Last Name: </label>
                <input type='text' name='user_lname' id='user_lname' maxlength="100" /><br />
                
                <label for='name' >Role: </label>
                <input type='text' name='user_role' id='user_role' maxlength="1" /><br />
                
                <label for='email' >Email Address*:</label>
                <input type='text' name='user_email' id='user_email' maxlength="100" /><br />
          
                <label for='password' >Password:</label>
                <input type='password' name='user_password' id='user_password' maxlength="100" /><br />
                
                <input type='submit' name='Submit' value='Submit' />
                <input type='submit' class="submit_json" name='Submit_JSON' value='Submit JSON'/><br />
            </form>
        </div>
        
        <!---------------------- ADD BOOK SECTION -------------------------->
        <div style="width:50%;height:350px;float:left;">
            <h2>Add / Edit / Find Books</h2>
            <form id='form_book' action='' method='post' accept-charset='UTF-8'>
                <input type='checkbox' name='commandName' value='createNewBook' id='createNewBook' />Add Book<br />
                <input type='checkbox' name='commandName' value='editBook' id='editBook' />Edit Book<br />
            
                <label for='name' >Book Name*: </label>
                <input type='text' name='book_name' id='book_name' maxlength="100" /><br />
        
                <label for='name' >Book Description: </label>
                <textarea rows="3" cols="25" name='book_description' id='book_description'></textarea><br />
                            
                <input type='submit' name='Submit' value='Submit' />
                <input type='submit' class="submit_json" name='Submit_JSON' value='Submit JSON'/><br />
            </form>
        </div>
        
        <!---------------------- ADD MEMBERSHIP SECTION -------------------------->
        <div style="width:50%;float:left;">
            <!-- 
            <h2>Add / Update Membership</h2>
            <form id='form_membership' action='' method='post' accept-charset='UTF-8'>
                <input type='hidden' name='commandName' value='createNewMembership' id='createNewMembership' />
            
                <label for='name' >User ID*: </label>
                <input type='text' name='user_id' id='user_id' maxlength="100" /><br />
        
                <label for='name' >Book ID*: </label>
                <input type='text' name='book_id' id='book_id' maxlength="100" /><br />
                
                <label for='name' >Membership Type: </label>
                <input type='text' name='member_id' id='member_id' maxlength="100" /><br />
                      
                <input type='submit' name='Submit' value='Submit' />
                <input type='submit' class="submit_json" name='Submit_JSON' value='Submit JSON'/><br />
            </form>
            -->
        </div>
        
        <!---------------------- ADD QUOTE SECTION -------------------------->
        <div style="width:50%;float:left;">
            <h2>Add / Find Quote</h2>
            <form id='form_quote' action='' method='post' accept-charset='UTF-8'>
                <input type='checkbox' name='commandName' value='createNewQuote' id='createNewQuote' />Add Quote<br />
            
                <label for='name' >Book Name: </label>
                <input type='text' name='book_name' id='book_name' maxlength="100" /><br />
        
                <label for='name' >Speaker (email)*: </label>
                <input type='text' name='speaker_email' id='speaker_email' maxlength="100" /><br />
                
                <label for='name' >Quote: </label>
                <textarea rows="3" cols="25" name='quote' id='quote'></textarea><br />
                
                <label for='name' >Date &amp; Time of Quote (YYYY-mm-dd HH:mm:ss): </label>
                <input type='text' name='quote_datetime' id='quote_datetime' maxlength="100" /><br />
                            
                <label for='name' >Context: </label>
                <textarea rows="3" cols="25" name='quote_context' id='quote_context'></textarea><br />
                
                <label for='name' >Multi Quote ID: </label>
                <input type='text' name='multi_quote_id' id='multi_quote_id' maxlength="100" /><br />
                
                <input type='submit' name='Submit' value='Submit' />
                <input type='submit' class="submit_json" name='Submit_JSON' value='Submit JSON'/><br />
            </form>
        </div>
    
        <!---------------------- EDIT QUOTE SECTION -------------------------->
        <div style="width:50%;float:left;">
            <h2>Edit Quote</h2>
            <form id='form_edit_quote' action='' method='post' accept-charset='UTF-8'>
                <input checked type='checkbox' name='commandName' value='editQuote' id='editQuote' />Edit Quote<br />
                
                <label for='name' >Quote ID: </label>
                <input type='text' name='quote_id' id='quote_id' maxlength="4" /><br />
                
                <label for='name' >Quote: </label>
                <textarea rows="3" cols="25" name='quote' id='quote'></textarea><br />
                
                <label for='name' >Date &amp; Time of Quote (YYYY-mm-dd HH:mm:ss): </label>
                <input type='text' name='quote_datetime' id='quote_datetime' maxlength="100" /><br />
                            
                <label for='name' >Context: </label>
                <textarea rows="3" cols="25" name='quote_context' id='quote_context'></textarea><br />
                
                <label for='name' >Multi Quote ID: </label>
                <input type='text' name='multi_quote_id' id='multi_quote_id' maxlength="100" /><br />
                
                <input type='submit' name='Submit' value='Submit' />
                <input type='submit' class="submit_json" name='Submit_JSON' value='Submit JSON'/><br />
            </form>
        </div>
    </div>
    
    <div style="width:30%;float:left"> 
        <h2>Results</h2>
<?php   
        
        /********************************** FIND USERS *******************************/
        $user2 = new User();
        $users = $user2->findUserBy('user_email', $_POST['user_email']);
         
        foreach ($users as $my_user) {
?>
           <br />Found User: <br />
           <ul>
               <li>User ID: <?php echo $my_user->getUserId(); ?>
               <li>Name: <?php echo $my_user->getUserLastName().', '.$my_user->getUserFirstName(); ?>
               <li>Email: <?php echo $my_user->getUserEmail(); ?>
               <li>Pic: <?php echo $my_user->getUserPic(); ?>
               <li>Registered: <?php echo $my_user->getUserRegistrationDate(); ?>
               <li>Role: <?php echo $my_user->getUserRole(); ?>
           </ul>
<?php                        
        }        

        /********************************** FIND BOOKS *******************************/
        $book2 = new Book();
        $book2->findBookBy('book_name', $_POST['book_name']); 
       
        if ($book2->getBookId()) {
?>
           <br />Found Book: <br />
           <ul>
               <li>Book ID: <?php echo $book2->getBookId(); ?>
               <li>Name: <?php echo $book2->getBookName(); ?>
               <li>Description: <?php echo $book2->getBookDescription(); ?>
               <li>Registered: <?php echo $book2->getBookRegistrationDate(); ?>
           </ul>
<?php
            $quote = new Quote();
            $book_quotes = $quote->findQuoteBy('book_id', $book2->getBookId());
 
            echo '<br />Found Quotes: <br />';
            
            foreach ($book_quotes as $my_quote) {
?>
                <ul>
                    <li>Quote ID: <?php echo $my_quote->getQuoteId(); ?>
                    <li>Book ID: <?php echo $my_quote->getBookId(); ?>
                    <li>Speaker ID: <?php echo $my_quote->getSpeakerId(); ?>
                    <li>Author ID: <?php echo $my_quote->getAuthorId(); ?>
                    <li>Quote: <?php echo $my_quote->getQuote(); ?>
                    <li>Quote Date/Time: <?php echo $my_quote->getQuoteDateTime(); ?>
                    <li>Quote Context: <?php echo $my_quote->getQuoteContext(); ?>
                    <li>Multi Quote ID: <?php echo $my_quote->getMultiQuoteId(); ?>
                    <li>Registered: <?php echo $my_quote->getQuoteRegistrationDate(); ?>
                </ul>
<?php
            }
        } 
    
        /********************************** FIND QUOTES *******************************/
        $quote2 = new Quote();
        $user = new User();
        $user->findUserBy('user_email', $_POST['speaker_email']);
        $speaker_quotes = $quote2->findQuoteBy('speaker_id', $user->getUserId());
       
        foreach ($speaker_quotes as $my_quote) {
?>
           <br />Found Quote: <br />
           <ul>
               <li>Quote ID: <?php echo $my_quote->getQuoteId(); ?>
               <li>Book ID: <?php echo $my_quote->getBookId(); ?>
               <li>Speaker ID: <?php echo $my_quote->getSpeakerId(); ?>
               <li>Author ID: <?php echo $my_quote->getAuthorId(); ?>
               <li>Quote: <?php echo $my_quote->getQuote(); ?>
               <li>Quote Date/Time: <?php echo $my_quote->getQuoteDateTime(); ?>
               <li>Quote Context: <?php echo $my_quote->getQuoteContext(); ?>
               <li>Multi Quote ID: <?php echo $my_quote->getMultiQuoteId(); ?>
               <li>Registered: <?php echo $my_quote->getQuoteRegistrationDate(); ?>
           </ul>
<?php
        }
        
        /********************************** FIND MEMBERSHIPS *******************************/
        /*
        $membership = new Membership();
        $membership->setUserId($_POST['user_id']);
        $membership->setBookId($_POST['book_id']);
        
        if ($membership->getUserId() && $membership->getBookId()) {
?>
           <br />Found Membership: <br />
           <ul>
               <li>User ID: <?php echo $membership->getUserId(); ?>
               <li>Book ID: <?php echo $membership->getBookId(); ?>
               <li>Membership Type: <?php echo $membership->getMembershipType(); ?>
           </ul>
<?php
        } 
        */
?>
    </div>
    
</body>
</html>