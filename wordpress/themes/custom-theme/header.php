<!DOCTYPE html>
<html <?php language_attributes(); ?>>
<head>
    <meta charset="<?php bloginfo('charset'); ?>">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><?php wp_title('|', true, 'right'); ?><?php bloginfo('name'); ?></title>
    <?php wp_head(); ?>
</head>
<body <?php body_class(); ?>>
    <header class="header">
        <div class="container">
            <nav class="navbar">
                <a href="<?php echo home_url(); ?>" class="navbar-brand">
                    <?php bloginfo('name'); ?>
                </a>
                <?php
                wp_nav_menu(array(
                    'theme_location' => 'primary',
                    'container' => 'div',
                    'container_class' => 'navbar-nav',
                ));
                ?>
            </nav>
        </div>
    </header>
