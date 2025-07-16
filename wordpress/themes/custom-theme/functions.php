<?php
/**
 * Theme functions and definitions
 */

// Add theme support for various features
function custom_theme_setup() {
    // Add theme support for post thumbnails
    add_theme_support('post-thumbnails');
    
    // Add theme support for menus
    add_theme_support('menus');
    
    // Register navigation menus
    register_nav_menus(array(
        'primary' => 'Primary Menu',
    ));
    
    // Add theme support for title tag
    add_theme_support('title-tag');
    
    // Add theme support for custom logo
    add_theme_support('custom-logo');
}
add_action('after_setup_theme', 'custom_theme_setup');

// Enqueue styles and scripts
function custom_theme_scripts() {
    wp_enqueue_style('custom-theme-style', get_stylesheet_uri());
}
add_action('wp_enqueue_scripts', 'custom_theme_scripts');

// Add REST API CORS headers for Laravel integration
function add_cors_http_header(){
    header("Access-Control-Allow-Origin: *");
    header("Access-Control-Allow-Methods: GET, POST, OPTIONS, PUT, DELETE");
    header("Access-Control-Allow-Headers: Content-Type, Authorization");
}
add_action('init','add_cors_http_header');

// Custom endpoint for Laravel integration
function custom_api_routes() {
    register_rest_route('custom/v1', '/posts', array(
        'methods' => 'GET',
        'callback' => 'get_custom_posts',
        'permission_callback' => '__return_true'
    ));
}
add_action('rest_api_init', 'custom_api_routes');

function get_custom_posts() {
    $posts = get_posts(array(
        'numberposts' => 10,
        'post_status' => 'publish'
    ));
    
    $formatted_posts = array();
    
    foreach($posts as $post) {
        $formatted_posts[] = array(
            'id' => $post->ID,
            'title' => $post->post_title,
            'content' => $post->post_content,
            'excerpt' => $post->post_excerpt,
            'date' => $post->post_date,
            'author' => get_the_author_meta('display_name', $post->post_author),
            'permalink' => get_permalink($post->ID)
        );
    }
    
    return $formatted_posts;
}
?>
