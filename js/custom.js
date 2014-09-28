(function($) {
    "use strict";

    var $emptyHeaders = $('.blog-no-header').parents('.post-header');
    $emptyHeaders.parents('.post-item').addClass('no-header');
    $emptyHeaders.remove();
})(jQuery);

;(function(a) {
    'use strict';

    a.fn.liveFilter = function(b, c, d) {
        var e = {
                filterChildSelector: null,
                filter: function(b, c) {
                    return a(b).text().toUpperCase().indexOf(c.toUpperCase()) >= 0
                },
                before: function() {},
                after: function() {}
            },
            d = a.extend(e, d),
            f = a(this).find(c);
        d.filterChildSelector && (f = f.find(d.filterChildSelector));
        var g = d.filter;
        a(b).keyup(function() {
            var b = a(this).val(),
                e = f.filter(function() {
                    return g(this, b)
                }),
                h = f.not(e);
            d.filterChildSelector && (e = e.parents(c), h = h.parents(c).hide()), d.before.call(this, e, h), e.show(), h.hide(), "" === b && (e.show(), h.show()), d.after.call(this, e, h)
        })
    }
} (jQuery));

$(function() {
    $("#tag-container").liveFilter("#tag-search", ".tag-wrapper", {
        filterChildSelector: "a"
    });
});

$(function() {
    $('.contact-link').click(function(e) {
        document.location = String.fromCharCode(109,97,105,108,116,111,58,109,101,64).concat(document.location.host.replace('www.', ''));
        e.preventDefault();
    });
});
