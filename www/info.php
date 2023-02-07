<?php

//function get_hmac($data, $hmac_header)
//{
//  $calculated_hmac = base64_encode(hash_hmac('sha256', $data, API_SECRET_KEY, true));
//  return $calculated_hmac;
//}
//
//$data = file_get_contents('php://input');

 $input = file_get_contents( 'php://input' );
 file_put_contents('input.txt', $input, FILE_APPEND )
?>