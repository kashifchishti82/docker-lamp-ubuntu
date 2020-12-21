<?php

$cfg['blowfish_secret'] = 'Gk=m1=EVY56e;9bm.hoP.}3Fm:;1q2{:';

/* Ensure we got the environment */
$vars = array(
    'DOCKER_PMA_ARBITRARY',
    'DOCKER_PMA_HOST',
    'DOCKER_PMA_HOSTS',
    'DOCKER_PMA_VERBOSE',
    'DOCKER_PMA_VERBOSES',
    'DOCKER_PMA_PORT',
    'DOCKER_PMA_PORTS',
    'DOCKER_PMA_SOCKET',
    'DOCKER_PMA_SOCKETS',
    'DOCKER_PMA_USER',
    'DOCKER_PMA_PASSWORD',
    'DOCKER_PMA_ABSOLUTE_URI',
    'DOCKER_PMA_CONTROLHOST',
    'DOCKER_PMA_CONTROLPORT',
    'DOCKER_PMA_PMADB',
    'DOCKER_PMA_CONTROLUSER',
    'DOCKER_PMA_CONTROLPASS',
    'DOCKER_PMA_QUERYHISTORYDB'
);
foreach ($vars as $var) {
    $env = getenv($var);
    if (!isset($_ENV[$var]) && $env !== false) {
        $_ENV[$var] = $env;
    }
}

if (isset($_ENV['DOCKER_PMA_QUERYHISTORYDB'])) {
    $cfg['QueryHistoryDB'] = boolval($_ENV['DOCKER_PMA_QUERYHISTORYDB']);
}

/* Arbitrary server connection */
if (isset($_ENV['DOCKER_PMA_ARBITRARY']) && $_ENV['DOCKER_PMA_ARBITRARY'] === '1') {
    $cfg['AllowArbitraryServer'] = true;
}

/* Play nice behind reverse proxys */
if (isset($_ENV['DOCKER_PMA_ABSOLUTE_URI'])) {
    $cfg['PmaAbsoluteUri'] = trim($_ENV['DOCKER_PMA_ABSOLUTE_URI']);
}

/* Figure out hosts */

/* Fallback to default linked */
$hosts = array('db');

/* Set by environment */
if (!empty($_ENV['DOCKER_PMA_HOST'])) {
    $hosts = array($_ENV['DOCKER_PMA_HOST']);
    $verbose = array($_ENV['DOCKER_PMA_VERBOSE']);
    $ports = array($_ENV['DOCKER_PMA_PORT']);
} elseif (!empty($_ENV['DOCKER_PMA_HOSTS'])) {
    $hosts = array_map('trim', explode(',', $_ENV['DOCKER_PMA_HOSTS']));
    $verbose = array_map('trim', explode(',', $_ENV['DOCKER_PMA_VERBOSES']));
    $ports = array_map('trim', explode(',', $_ENV['DOCKER_PMA_PORTS']));
}

if (!empty($_ENV['DOCKER_PMA_SOCKET'])) {
    $sockets = array($_ENV['DOCKER_PMA_SOCKET']);
} elseif (!empty($_ENV['DOCKER_PMA_SOCKETS'])) {
    $sockets = explode(',', $_ENV['DOCKER_PMA_SOCKETS']);
}

/* Server settings */
for ($i = 1; isset($hosts[$i - 1]); $i++) {
    $cfg['Servers'][$i]['host'] = $hosts[$i - 1];
    if (isset($verbose[$i - 1])) {
        $cfg['Servers'][$i]['verbose'] = $verbose[$i - 1];
    }
    if (isset($ports[$i - 1])) {
        $cfg['Servers'][$i]['port'] = $ports[$i - 1];
    }
    if (isset($_ENV['DOCKER_PMA_USER'])) {
        $cfg['Servers'][$i]['auth_type'] = 'config';
        $cfg['Servers'][$i]['user'] = $_ENV['DOCKER_PMA_USER'];
        $cfg['Servers'][$i]['password'] = isset($_ENV['DOCKER_PMA_PASSWORD']) ? $_ENV['DOCKER_PMA_PASSWORD'] : '';
    } else {
        $cfg['Servers'][$i]['auth_type'] = 'cookie';
    }
    if (isset($_ENV['DOCKER_PMA_PMADB'])) {
      $cfg['Servers'][$i]['pmadb'] = $_ENV['DOCKER_PMA_PMADB'];
      $cfg['Servers'][$i]['relation'] = 'pma__relation';
      $cfg['Servers'][$i]['table_info'] = 'pma__table_info';
      $cfg['Servers'][$i]['table_coords'] = 'pma__table_coords';
      $cfg['Servers'][$i]['pdf_pages'] = 'pma__pdf_pages';
      $cfg['Servers'][$i]['column_info'] = 'pma__column_info';
      $cfg['Servers'][$i]['bookmarktable'] = 'pma__bookmark';
      $cfg['Servers'][$i]['history'] = 'pma__history';
      $cfg['Servers'][$i]['recent'] = 'pma__recent';
      $cfg['Servers'][$i]['favorite'] = 'pma__favorite';
      $cfg['Servers'][$i]['table_uiprefs'] = 'pma__table_uiprefs';
      $cfg['Servers'][$i]['tracking'] = 'pma__tracking';
      $cfg['Servers'][$i]['userconfig'] = 'pma__userconfig';
      $cfg['Servers'][$i]['users'] = 'pma__users';
      $cfg['Servers'][$i]['usergroups'] = 'pma__usergroups';
      $cfg['Servers'][$i]['navigationhiding'] = 'pma__navigationhiding';
      $cfg['Servers'][$i]['savedsearches'] = 'pma__savedsearches';
      $cfg['Servers'][$i]['central_columns'] = 'pma__central_columns';
      $cfg['Servers'][$i]['designer_settings'] = 'pma__designer_settings';
      $cfg['Servers'][$i]['export_templates'] = 'pma__export_templates';
    }
    if (isset($_ENV['DOCKER_PMA_CONTROLHOST'])) {
      $cfg['Servers'][$i]['controlhost'] = $_ENV['DOCKER_PMA_CONTROLHOST'];
    }
    if (isset($_ENV['DOCKER_PMA_CONTROLPORT'])) {
      $cfg['Servers'][$i]['controlport'] = $_ENV['DOCKER_PMA_CONTROLPORT'];
    }
    if (isset($_ENV['DOCKER_PMA_CONTROLUSER'])) {
      $cfg['Servers'][$i]['controluser'] = $_ENV['DOCKER_PMA_CONTROLUSER'];
    }
    if (isset($_ENV['DOCKER_PMA_CONTROLPASS'])) {
      $cfg['Servers'][$i]['controlpass'] = $_ENV['DOCKER_PMA_CONTROLPASS'];
    }
    $cfg['Servers'][$i]['compress'] = false;
    $cfg['Servers'][$i]['AllowNoPassword'] = true;
}
for ($i = 1; isset($sockets[$i - 1]); $i++) {
    $cfg['Servers'][$i]['socket'] = $sockets[$i - 1];
    $cfg['Servers'][$i]['host'] = 'localhost';
}
/*
 * Revert back to last configured server to make
 * it easier in config.user.inc.php
 */
$i--;

/* Uploads setup */
$cfg['UploadDir'] = '';
$cfg['SaveDir'] = '';

/* Include User Defined Settings Hook */
if (file_exists('/etc/phpmyadmin/config.user.inc.php')) {
    include('/etc/phpmyadmin/config.user.inc.php');
}