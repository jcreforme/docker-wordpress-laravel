<?php
/**
 * Plugin Name: Laravel Integration
 * Description: Custom plugin to integrate WordPress with Laravel backend
 * Version: 1.0
 * Author: Your Name
 */

// Prevent direct access
if (!defined('ABSPATH')) {
    exit;
}

class LaravelIntegration {
    
    public function __construct() {
        add_action('init', array($this, 'init'));
        add_action('rest_api_init', array($this, 'register_api_routes'));
    }
    
    public function init() {
        // Add any initialization code here
    }
    
    public function register_api_routes() {
        // Custom endpoint for Laravel to fetch WordPress data
        register_rest_route('laravel/v1', '/posts', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_posts_for_laravel'),
            'permission_callback' => '__return_true'
        ));
        
        register_rest_route('laravel/v1', '/categories', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_categories_for_laravel'),
            'permission_callback' => '__return_true'
        ));
        
        register_rest_route('laravel/v1', '/users', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_users_for_laravel'),
            'permission_callback' => '__return_true'
        ));
    }
    
    public function get_posts_for_laravel($request) {
        $page = $request->get_param('page') ?: 1;
        $per_page = $request->get_param('per_page') ?: 10;
        
        $posts = get_posts(array(
            'numberposts' => $per_page,
            'offset' => ($page - 1) * $per_page,
            'post_status' => 'publish',
            'orderby' => 'date',
            'order' => 'DESC'
        ));
        
        $formatted_posts = array();
        
        foreach($posts as $post) {
            $formatted_posts[] = array(
                'id' => $post->ID,
                'title' => $post->post_title,
                'content' => $post->post_content,
                'excerpt' => $post->post_excerpt,
                'date' => $post->post_date,
                'modified' => $post->post_modified,
                'author' => array(
                    'id' => $post->post_author,
                    'name' => get_the_author_meta('display_name', $post->post_author),
                    'email' => get_the_author_meta('user_email', $post->post_author)
                ),
                'categories' => wp_get_post_categories($post->ID, array('fields' => 'names')),
                'tags' => wp_get_post_tags($post->ID, array('fields' => 'names')),
                'permalink' => get_permalink($post->ID),
                'featured_image' => get_the_post_thumbnail_url($post->ID, 'full')
            );
        }
        
        return new WP_REST_Response($formatted_posts, 200);
    }
    
    public function get_categories_for_laravel($request) {
        $categories = get_categories(array(
            'hide_empty' => false
        ));
        
        $formatted_categories = array();
        
        foreach($categories as $category) {
            $formatted_categories[] = array(
                'id' => $category->term_id,
                'name' => $category->name,
                'slug' => $category->slug,
                'description' => $category->description,
                'count' => $category->count
            );
        }
        
        return new WP_REST_Response($formatted_categories, 200);
    }
    
    public function get_users_for_laravel($request) {
        $users = get_users();
        
        $formatted_users = array();
        
        foreach($users as $user) {
            $formatted_users[] = array(
                'id' => $user->ID,
                'username' => $user->user_login,
                'email' => $user->user_email,
                'display_name' => $user->display_name,
                'registered' => $user->user_registered,
                'roles' => $user->roles
            );
        }
        
        return new WP_REST_Response($formatted_users, 200);
    }
}

// Initialize the plugin
new LaravelIntegration();
?>
