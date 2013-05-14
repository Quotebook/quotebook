<?php session_start(); ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>My Books</title>
    
    <style type="text/css">
        label { display:block; }
    </style>
</head>

<body>
<?php
    include ('../header.php');
    
    echo '<h2>My Books:</h2>';
    if ( isset($_SESSION['user_id']) )
    {        
        $logged_in_user = new User();
        $logged_in_user->findUserBy('user_id', $_SESSION['user_id']);
        $my_books = $logged_in_user->getBooks();
        
        foreach($my_books as $book)
        {
?>
        <div id="<?php echo 'book_'.$book->getBookId(); ?>" class="book">
            Book Name: <?php echo $book->getBookName(); ?><br />
            Book Description: <?php echo $book->getBookDescription(); ?><br />
        </div>
        <br />
<?php
        }            
    }
    else {
        echo 'User is not logged in.';
    }
?>
</body>
</html>
