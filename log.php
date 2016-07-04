<?php
$log = './log.txt';
$data = json_decode(file_get_contents('php://input'), true);
$data['ts'] = time()*1000;
file_put_contents($log, json_encode($data) . "\n", FILE_APPEND | LOCK_EX);
?>
