<?php
    include_once 'classes/Config.php';
    include_once Config::$base_dir . '/classes/Controller.php';
    include_once Config::$base_dir . '/classes/User.php';
    include_once Config::$base_dir . '/classes/Book.php';
    include_once Config::$base_dir . '/classes/Quote.php';
    include_once Config::$base_dir . '/classes/Membership.php';
    
    include (Config::$base_dir .'/jsonize.php');
?>    

    <div id="header" style="width:100%;border-bottom:solid black 1px;height:300px;">
        <form id='form_json' action='' method='post' accept-charset='UTF-8'>
            <input type='hidden' name='json' id='json_text'/>
        </form>
<?php
    if ( isset($_SESSION['user_id']) )
    {
        $logged_in_user = new User();
        $logged_in_user->findUserBy('user_id', $_SESSION['user_id']);
        
        if ( $logged_in_user->getUserRole() == ROLE_SUPERUSER ||
                $logged_in_user->getUserRole() == ROLE_USER )
        {
?>
        <div id="logged_in" style="float:left;">
            Welcome User ID: <?php echo $logged_in_user->getUserEmail(); ?>!
            <form id='logout' action='' method='post' accept-charset='UTF-8'>
                <input type='hidden' name='commandName' value='logout' id='logout' />
                <input type='submit' name='Submit' value='Logout' />
                <input type='submit' class="submit_json" name='Submit_JSON' value='Logout JSON'/><br />
            </form>
            <br />
            <form id='joinBook' action='' method='post' accept-charset='UTF-8' style='float:left;width:150px;'>
                <input type='hidden' name='commandName' value='joinBook' id='joinBook' />
            
                <label for='name' >Join Book (ID): </label>
                <input type='text' name='book_id' id='book_id' maxlength="4" /><br />
                
                <input type='submit' name='Submit' value='Join' />
                <input type='submit' class="submit_json" name='Submit_JSON' value='Join JSON'/><br />
            </form>
            
            <form id='leaveBook' action='' method='post' accept-charset='UTF-8' style='float:left;width:150px;'>
                <input type='hidden' name='commandName' value='leaveBook' id='leaveBook' />
            
                <label for='name' >Leave Book (ID): </label>
                <input type='text' name='book_id' id='book_id' maxlength="4" /><br />
                
                <input type='submit' name='Submit' value='Leave' />
                <input type='submit' class="submit_json" name='Submit_JSON' value='Leave JSON'/><br />
            </form>
            
            <form id='inviteToBook' action='' method='post' accept-charset='UTF-8' style='float:left;width:150px;'>
                <input type='hidden' name='commandName' value='inviteToBook' id='inviteToBook' />
            
                <label for='name' >Invite to Book (ID): </label>
                <input type='text' name='book_id' id='book_id' maxlength="4" /><br />
                
                <label for='email' >Email Address:</label>
                <input type='text' name='user_email' id='user_email' maxlength="100" /><br />
            
                <input type='submit' name='Submit' value='Invite' />
                <input type='submit' class="submit_json" name='Submit_JSON' value='Invite JSON'/><br />
            </form>
            
            <form id='pendingApprovals' action='' method='post' accept-charset='UTF-8' style='float:left;width:175px;'>
                <input type='hidden' name='commandName' value='approveToBook' id='approveToBook' />
            
                <label for='name' >Approve to Book (ID): </label>
                <input type='text' name='book_id' id='book_id' maxlength="4" /><br />
                
                <label for='email' >Email Address:</label>
                <input type='text' name='user_email' id='user_email' maxlength="100" /><br />
            
                <input type='submit' name='Submit' value='Approve' />
                <input type='submit' class="submit_json" name='Submit_JSON' value='Approve JSON'/><br />
            </form>
        </div>
<?php
        }
        elseif ( $logged_in_user->getUserRole() == ROLE_NON_USER )
        {
?>
        <form id='form_register' action='' method='post' accept-charset='UTF-8' style="float:left;">
            <p>Please register...</p>
            <label for='email' >Email Address: <?php echo $logged_in_user->getUserEmail(); ?></label>
            <input type='hidden' name='commandName' value='register' id='register' />
            
            <label for='name' >First Name: </label>
            <input type='text' name='user_fname' id='user_fname' maxlength="100" /><br />
    
            <label for='name' >Last Name: </label>
            <input type='text' name='user_lname' id='user_lname' maxlength="100" /><br />
      
            <label for='password' >Password:</label>
            <input type='password' name='user_password' id='user_password' maxlength="100" /><br />
            
            <input type='submit' name='Submit' value='Register' />
            <input type='submit' class="submit_json" name='Submit_JSON' value='Register JSON'/><br />
        </form>
<?php            
        }
    } 
    else {
?>
        <form id='form_login' action='' method='post' accept-charset='UTF-8' style="float:left;">
            <input type='hidden' name='commandName' value='login' id='login' />
            
            <label for='email' >Email Address:</label>
            <input type='text' name='user_email' id='user_email' maxlength="100" /><br />
      
            <label for='password' >Password:</label>
            <input type='password' name='user_password' id='user_password' maxlength="100" /><br />
            
            <input type='submit' name='Submit' value='Login' />
            <input type='submit' class="submit_json" name='Submit_JSON' value='Login JSON'/><br />
        </form>
<?php 
    }
?>
        <div id='menu' style='float:right;'>
            <a href="<?php echo Config::$base_url ?>/">Home</a>
            <a href="<?php echo Config::$base_url ?>/views/books.php">My Books</a>
            <a href="<?php echo Config::$base_url ?>/json.php">JSON</a>
        </div>
        
        <div id="results" style='clear:both;width:80%;float:left;'>
<?php         
        $controller = new Controller();
        if ( isset($_POST['Submit']) )
        {
            $controller->handleRequest();
        }
        elseif ( isset($_POST['json']) )
        {
            $controller->handleJsonRequest();
        }
?>        
        </div>
    </div>