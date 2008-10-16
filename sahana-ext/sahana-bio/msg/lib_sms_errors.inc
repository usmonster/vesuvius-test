<?php
/**
 *
 * This is a SMS error handler, you can create and manage a SMS error message container
 * and send the errors via SMS to users accessing Sahana through SMS.
 * Developers should note the fact that, error message length should preferably be less than 160 characters
 * which is the standard SMS length. Text greater than 160 characters should also be supported but should
 * ideally be avoided. Make sure you dont print/echo any message in PHP/HTML as this is supposed to be
 * dealt via an SMS session, so no echoing of messages. Supress all echo strings or use it for debugging only.
 * Echoing any strings will break the SMS message text formation and break the session resulting in user not
 * getting any response to his SMS.
 *
 * PHP version 4 and 5
 *
 * LICENSE: This source file is subject to LGPL license
 * that is available through the world-wide-web at the following URI:
 * http://www.gnu.org/copyleft/lesser.html
 *
 * @package    moduleAPI
 * @subpackage errors
 * @author     Ajay Kumar <ajuonline at gmail dot com><aj at mindtakers dot com>
 * @copyright  Lanka Software Foundation - http://www.opensource.lk
 * @version    $Id: lib_sms_errors.inc,v 1.1 2008-10-06 10:10:44 miyuru Exp $
 * @license    http://www.gnu.org/copyleft/lesser.html GNU Lesser General Public License (LGPL)
 */

function _shn_msg_sms_error_code($error_code){
    $error_code_messages = array(
                                '1' => 'Invalid SMS Keyword Sent. Kindly send HELP to get the list of keywords.',
                                '2' => 'Sahana Server Error. Unable to connect to Data base. Please try later or contact Sahana Admin at.',
                                '3' => 'Login Failed : Invalid user name or password.',
                                '4' => 'Login Failed : You have been banned by an administrator of the system.',
                                '5' => 'Login Failed : This account has been locked.  Please contact the Administrator to unlock the account.',
                                '6' => 'Login Failed : Password log attacked.',
                                '7' => 'Login Failed : Account is not active yet. Contact Administrator to activate your account'
                                );
    if(array_key_exists($error_code, $error_code_messages)){
        return $error_code_messages[$error_code];
    }
    else{
        return 0;
    }
}
?>