<?php
/**
 * The main template file
 */

get_header(); ?>

<div class="container">
    <main class="content">
        <?php if (have_posts()) : ?>
            <?php while (have_posts()) : the_post(); ?>
                <article id="post-<?php the_ID(); ?>" <?php post_class(); ?>>
                    <header class="entry-header">
                        <h1 class="entry-title">
                            <a href="<?php the_permalink(); ?>"><?php the_title(); ?></a>
                        </h1>
                        <div class="entry-meta">
                            <time datetime="<?php echo get_the_date('c'); ?>">
                                <?php echo get_the_date(); ?>
                            </time>
                            <span class="author">by <?php the_author(); ?></span>
                        </div>
                    </header>

                    <div class="entry-content">
                        <?php the_excerpt(); ?>
                    </div>

                    <footer class="entry-footer">
                        <a href="<?php the_permalink(); ?>" class="read-more">Read More</a>
                    </footer>
                </article>
            <?php endwhile; ?>

            <div class="pagination">
                <?php
                echo paginate_links(array(
                    'prev_text' => '&laquo; Previous',
                    'next_text' => 'Next &raquo;',
                ));
                ?>
            </div>
        <?php else : ?>
            <p>No posts found.</p>
        <?php endif; ?>
    </main>
</div>

<?php get_footer(); ?>
