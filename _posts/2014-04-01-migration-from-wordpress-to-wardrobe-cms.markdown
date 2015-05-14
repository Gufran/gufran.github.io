---

layout: post_simple
title: Migration From Wordpress To Wardrobe Cms
permalink: post/migration-from-wordpress-to-wardrobe-cms
excerpt: "If this is not your first time on this blog then you might notice few changes here and there. I just moved my blog from Wordpress to [Wardrobe CMS](http://wardrobecms.com).  
I spent last couple of days deciding and planning the migration from Wordpress and I can't think of anything better than moving this entire thing to Laravel.
"

date: 2014-04-01

tags: 
  - "Laravel"
  - "Wardrobe CMS"

---

**Well, Now this blog is powered by Jekyll but read on if you want to.**

If this is not your first time on this blog then you might notice few changes here and there. I just moved my blog from Wordpress to [Wardrobe CMS](http://wardrobecms.com).  
I spent last couple of days deciding and planning the migration from Wordpress and I can't think of anything better than moving this entire thing to Laravel.


Moving the blog was not that tricky at all, well, first - because this is barely a blog right now. I had only 5 posts on it and very little search engine indexing, and then Wordpress is an overkill for a blog like this. I wanted something minimal and wardrobe seems to be the best candidate so far. It is Laravel in core and you paste in the markdown and hit the publish button. Just like that.

In this transition I had to set up a way to manage everything and automate a lot of tasks. Also I trimmed away a lot of Laravel just to keep things minimal, I guess I'll discuss about it in a later post here. Also, this new theme you see here is a mod of a Ghost theme I ported over to Wardrobe and added some features of my liking.  
Right now this is kind of an announcement to let you know that you are on the right blog.  
As a checklist for future posts here is a summary of what I did during the migration.

 - Setup Git to automatically deploy this application on a shared host
 - Prepare a minimal Laravel setup to run Wardrobe
 
Stay tuned for cool stuff that is about to come. In the meantime please feel free to share your thoughts about this new setup.
