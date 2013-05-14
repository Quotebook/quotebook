<?php session_start(); ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>JSON</title>
    
    <style type="text/css">
        label { display:block; }
    </style>
</head>


<body>

<?php 
    include 'header.php';
?>
    <!---------------------- USER SECTION -------------------------->
    <div style="width:30%;float:left">
        <h2>Retrieve Users</h2>
        <form id='retrieveUser' action='' method='post' accept-charset='UTF-8'>
            <input type='hidden' name='commandName' value='retrieveUser' id='retrieveUser' />
        
            <label for='name' >User ID:</label>
            <input type='text' name='user_id' id='user_id' maxlength="3" /><br />
      
            <input type='submit' class="submit_json" name='Submit' value='Submit' /><br />
        </form>    
    </div>
    
    <!---------------------- BOOK SECTION -------------------------->
    <div style="width:30%;float:left">
        <h2>Retrieve Books</h2>
        <form id='retrieveBook' action='' method='post' accept-charset='UTF-8'>
            <input type='hidden' name='commandName' value='retrieveBook' id='retrieveBook' />
        
            <label for='name' >Book ID:</label>
            <input type='text' name='book_id' id='book_id' maxlength="3" /><br />
      
            <input type='submit' class="submit_json" name='Submit' value='Submit' /><br />
        </form>    
    </div>
    
    <!---------------------- QUOTE SECTION -------------------------->
    <div style="width:30%;float:left">
        <h2>Retrieve Quotes</h2>
        <form id='retrieveQuote' action='' method='post' accept-charset='UTF-8'>
            <input type='hidden' name='commandName' value='retrieveQuote' id='retrieveQuote' />
        
            <label for='name' >Quote ID:</label>
            <input type='text' name='quote_id' id='quote_id' maxlength="3" /><br />
      
            <input type='submit' class="submit_json" name='Submit' value='Submit' /><br />
        </form>    
    </div>


</body>
</html>